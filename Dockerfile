
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --retries 10 --timeout 120 -r requirements.txt

COPY app.py ml_engine.py ./
COPY dataset/ ./dataset/
COPY models/ ./models/
COPY outputs/ ./outputs/
COPY static/ ./static/
COPY templates/ ./templates/

EXPOSE 5002

CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:${PORT:-5002} --workers 2 --timeout 120 app:app"]
