# 1. Base Python system lana
FROM python:3.12-slim

# 2. System ko update karna aur FFmpeg/Cargo install karna
RUN apt-get update && apt-get install -y ffmpeg cargo && rm -rf /var/lib/apt/lists/*

# 3. Kaam karne ki jagah set karna
WORKDIR /app

# 4. Requirements copy karna
COPY requirements.txt .

# 🔥 NAYI LINE: Sabse pehle CPU wala chhota PyTorch install karna (Taaki server crash na ho)
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu

# 5. Baaki AI tools install karna
RUN pip install --no-cache-dir -r requirements.txt

# 6. Hamara main.py code copy karna
COPY . .

# 7. Server ko on karna
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
