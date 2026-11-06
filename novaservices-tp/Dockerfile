FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Version = commit Git, passée par le pipeline
ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}

EXPOSE 8000
# 0.0.0.0 obligatoire pour être joignable depuis l'extérieur du conteneur
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
