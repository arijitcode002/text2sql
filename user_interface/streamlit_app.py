# streamlit_app.py

import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import tempfile
import os
from pathlib import Path

import json
import httpx
import logging
import sys

logging.basicConfig(
    format='%(asctime)s - %(levelname)s - %(name)s - %(message)s',
    level=logging.INFO,
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)

# Get a logger instance
logger = logging.getLogger(__name__)

backend_ask_api = 'http://backend:5000/text2sql/ask'

save_good_feedback_api = 'http://backend:5000/chromadb/save-good-feedback'

save_bad_feedback_api = 'http://backend:5000/chromadb/save-bad-feedback'

st.title("Text -> SQL ")

query = st.text_input("Please provide input text and I will try to convert it to SQL")

headers = {"Content-Type": "application/json"}
data = {
    "query": query
}
backend_ask_response = httpx.post(backend_ask_api, headers=headers, data=json.dumps(data), timeout=400.0)

logger.info(f"Backend Request - {data}")
logger.info(f"Backend Response - {backend_ask_response.json()}")

st.write("This is the generated SQL - ", backend_ask_response.json()["response"])

# Initialize connection.
conn = st.connection('mysql', type='sql')

# Perform query.
sql_output = backend_ask_response.json()["response"]
df = conn.query(sql_output, ttl=600)

st.dataframe(df)

if st.button("Good SQL?"):
    good_feedback_data = {
        "sql": sql_output,
        "query": query
    }

    save_good_feedback_api_response = httpx.post(save_good_feedback_api, headers=headers,
                                                 data=json.dumps(good_feedback_data), timeout=400.0)

if st.button("Bad SQL?"):
    good_feedback_data = {
        "sql": sql_output,
        "query": query
    }

    save_bad_feedback_api_response = httpx.post(save_bad_feedback_api, headers=headers,
                                                data=json.dumps(good_feedback_data), timeout=400.0)