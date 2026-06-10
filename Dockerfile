# 1. Base Python system lana
FROM python:3.12-slim

# 2. System ko update karna aur FFmpeg/Cargo install karna (Ab koi read-only error nahi aayega!)
RUN apt-get update && apt-get install -y ffmpeg cargo && rm -rf /var/lib/apt/lists/*

# 3. Kaam karne ki jagah set karna
WORKDIR /app

# 4. Requirements file copy karke AI aur FastAPI install karna
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Hamara main.py code copy karna
COPY . .

# 6. Server ko on karna
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
