import json
import logging
import sys
import uuid

import chromadb
import httpx
from chromadb.config import Settings
from flask import Flask, request

app = Flask(__name__)

good_feedback_metdata = "good_feedback_metdata"
bad_feedback_metdata = "bad_feedback_metdata"
table_metadata = "table_metadata"
column_metadata = "columns_metadata"
ollama_generate_api = 'http://ollama:11434/api/generate'
stream_enabled = False

logging.basicConfig(
        format='%(asctime)s - %(levelname)s - %(name)s - %(message)s',
        level=logging.INFO,
        handlers=[
            logging.StreamHandler(sys.stdout)
        ]

    )

# Get a logger instance
logger = logging.getLogger(__name__)

chroma_client = chromadb.HttpClient(host="chroma", port = 8000, settings=Settings(allow_reset=True, anonymized_telemetry=False))
#chroma_client = chromadb.HttpClient(host="127.0.0.1", port = 8000, settings=Settings(allow_reset=True, anonymized_telemetry=False))

@app.route('/text2sql/ask', methods=['POST'])
def ask():
    json_request = request.json
    query = json_request.get("query")
    
    #raw_table_metadata = get_table_metadata(query)
    json_table_metadata = get_table_metadata(query)
    distances = json_table_metadata.get("distances")[0]
    documents = json_table_metadata.get("documents")[0]
    metadatas = json_table_metadata.get("metadatas")[0]

    valid_table_zip_list = [(metadata, doc) for distance, doc, metadata in zip(distances, documents, metadatas) if distance <= 1]
    all_column_metadata = []
    all_table_metadata = []
    for metadata, doc in valid_table_zip_list:
        all_table_metadata.append(doc)
        table_name = metadata['tableName']
        #raw_column_metadata = get_column_metadata(table_name)
        json_column_metadata = get_column_metadata (table_name)
        column_details = json_column_metadata.get("documents")
        all_column_metadata.append(column_details)

    prompt = build_sql_prompt(all_table_metadata, all_column_metadata, query)

    headers = {"Content-Type": "application/json"}

    data = {
        "model": "mistral",
        "prompt": prompt,
        "stream": stream_enabled
    }

    ollama_response = httpx.post(ollama_generate_api, headers=headers, data=json.dumps(data), timeout=300.0)
    logger.info(f"Ollama Request (data)")
    logger.info(f"Ollama Response (ollama_response.json())")

    return ollama_response.json()

@app.route('/chromadb/init', methods=['POST'])
def chromadb_init():
    load_table_metadata()
    load_columns_metadata()
    return json.dumps('{"message": "success"}')

@app.route('/chromadb/reset', methods=['POST'])
def chromadb_reset():
    json_request = request.json
    reset_column = json_request.get("reset_column")
    reset_table = json_request.get("reset_table")

    if reset_column:
        reset_columns_metadata()

    if reset_table:
        reset_table_metadata()
    return json.dumps('{"message": "success"}')

@app.route('/chromadb/get_tables', methods=['POST'])
def chromadb_get_tables():
    json_request = request.json
    query = json_request['query']
    return get_table_metadata(query)

@app.route('/chromadb/get-columns', methods=['POST'])
def chromadb_get_columns():
    json_request = request.json
    query = json_request['query']
    return get_column_metadata (query)

@app.route('/chromadb/save-good-feedback', methods=['POST'])
def chromadb_save_good_feedbacks():
    json_request = request.json
    sql = json_request.get("sql")
    query= json_request.get("query")
    collection = chroma_client.get_or_create_collection(name=good_feedback_metdata)
    collection.add(
        documents=[query],
        metadatas=[{"sql": sql}],
        ids=[f"{uuid.uuid4()}"]
    )
    return json.dumps('{"message": "success"}')

@app.route('/chromadb/save-bad-feedback', methods=['POST'])
def chromadb_save_bad_feedbacks():
    json_request = request.json
    sql = json_request.get("sql")
    query = json_request.get("query")
    collection = chroma_client.get_or_create_collection(name=bad_feedback_metdata)
    collection.add(
        documents=[query],
        metadatas=[{"sql": sql}],
        ids=[f"{uuid.uuid4()}"]
    )
    return json.dumps('{"message": "success"}')

@app.route('/chromadb/get-good-feedback', methods=['POST'])
def chromadb_get_good_feedbacks():
    json_request = request.json
    query = json_request['query']
    document_collection = chroma_client.get_or_create_collection(name=good_feedback_metdata)
    return document_collection.query(query_texts=[query], n_results=2)

@app.route('/chromadb/get-bad-feedback', methods=['POST'])
def chromadb_get_bad_feedbacks():
    json_request = request.json
    query = json_request['query']
    document_collection = chroma_client.get_or_create_collection(name=bad_feedback_metdata)
    return document_collection.query(query_texts=[query], n_results=2)

def get_table_metadata (query):
    document_collection = chroma_client.get_or_create_collection(name=table_metadata)
    return document_collection.query(query_texts=[query], n_results=2)

def get_column_metadata(table_name):
    document_collection = chroma_client.get_or_create_collection(name=column_metadata)
    return document_collection.get(where={"tableName": table_name})

def reset_table_metadata():
    chroma_client.delete_collection(name=table_metadata)

def reset_columns_metadata():
    chroma_client.delete_collection(name=column_metadata)

def load_columns_metadata():
    collection = chroma_client.get_or_create_collection(name=column_metadata)

    #Load your JSON file
    with open("column_matadata.json", "r") as f:
        data = json.load(f)

    #Prepare documents, IDs, and metadata
    documents = []
    ids = []
    metadatas = []

    for i, item in enumerate(data):
        document_text = f"{item['tableName']}.{item['columnName']} - {item['columnDescription']}, {item['columnDefinition']}"
        #documents.append(item["columnDefinition"])
        documents.append(document_text)
        ids.append(f"{item['tableName']}_{item['columnName']}_{i}")
        metadatas.append({"tableName": item["tableName"]})

    #Add documents to ChromaDB
    collection.add(
        documents=documents,
        ids=ids,
        metadatas=metadatas
    )

def load_table_metadata():
    collection = chroma_client.get_or_create_collection(name=table_metadata)

    #Load your JSON file
    with open("table_metadata.json", "r") as f:
        data= json.load(f)

    # Prepare and add documents
    for i, item in enumerate(data["tableMatadata"]):
        table_name = item["tableName"]
        description = item["description"]
        document_text = f"{table_name} - {description}"

        collection.add(
            documents=[document_text],
            metadatas=[{"tableName": table_name}],
            ids = [f"{table_name}_{i}"]
        )

def build_sql_prompt(table_metadata, column_matadata, user_question):
    # Build table section
    table_section = "\n".join([
        f"- {table}"
        for table in table_metadata
    ])

    #Build column section
    column_section = "\n".join([
        f"- {col}"
        for col in column_matadata
    ])

    # Final formatted prompt
    prompt = f"""
You are a SQL: assistant. Below in the database schema documentation.

### Tables:
{table_section}

### Columns:
{column_section}

### Task
{user_question}

Write a correct and optimized SQL query based on the above. Only provide the SQL query, nothing else.
"""
    return prompt

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
    #app.run(host='0.0.0.0', port=9000)