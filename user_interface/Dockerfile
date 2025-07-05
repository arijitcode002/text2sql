FROM python:3.9-slim

WORKDIR /app/text2sql/user_interface

RUN apt-get update && apt-get install -y build-essential curl software-properties-common git && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y ca-certificates
RUN update-ca-certificates

RUN mkdir -p /app/text2sql/user_interface/.streamlit

COPY secrets.toml /app/text2sql/user_interface/
COPY secrets.toml /app/text2sql/user_interface/.streamlit/
COPY requirements.txt /app/text2sql/user_interface/
COPY streamlit_app.py /app/text2sql/user_interface/

RUN apt-get update && apt-get install -y python3-dev default-libmysqlclient-dev build-essential pkg-config

RUN pip3 install --verbose --trusted-host=pypi.python.org --trusted-host=pypi.org --trusted-host=files.pythonhosted.org -r requirements.txt

EXPOSE 8600

ENTRYPOINT ["streamlit", "run", "streamlit_app.py", "--server.port=8600", "--server.address=0.0.0.0", "--server.enableXsrfProtection=false"]
