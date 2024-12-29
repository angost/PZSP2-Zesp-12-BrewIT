FROM python:3.11-alpine

WORKDIR /app

COPY . /app

RUN apk add --update libpq-dev python3-dev build-base

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

#CMD ["python", "manage.py", "runserver_plus", "--cert-file", "localhost.crt", "--key-file", "localhost.key"]
