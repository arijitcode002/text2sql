FROM python:3.10.13

WORKDIR /app/text2sql/backend

RUN apt-get update && apt-get install -y build-essential curl software-properties-common git && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y ca-certificates
RUN update-ca-certificates

COPY requirements.txt /app/text2sql/backend/

RUN pip3 install --verbose --trusted-host=pypi.python.org --trusted-host=pypi.org --trusted-host=files.pythonhosted.org -r requirements.txt

EXPOSE 5000

CMD ["python", "flask-app.py"]