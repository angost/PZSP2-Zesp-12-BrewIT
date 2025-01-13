FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt requirements.txt
RUN apt-get update && apt-get install -y bash
RUN apt-get update && apt-get install -y libpq-dev gcc
RUN pip install -r requirements.txt
RUN apt-get -y install gunicorn
COPY . .
RUN chmod +x wait-for-it.sh
