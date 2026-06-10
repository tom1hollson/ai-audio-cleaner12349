# 1. Base Python system lana
FROM python:3.12-slim

# 2. System ko update karna aur FFmpeg, Cargo, plus Audio Drivers (libsndfile1) install karna
RUN apt-get update && apt-get install -y ffmpeg cargo libsndfile1 && rm -rf /var/lib/apt/lists/*

# 3. Kaam karne ki jagah set karna
WORKDIR /app

# 4. Requirements copy karna
COPY requirements.txt .

# 🔥 NAYI LINE: PyTorch ke exact versions (2.1.2) lock karna jo DeepFilterNet ke sath perfectly chalte hain
RUN pip install --no-cache-dir torch==2.1.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cpu

# 5. Baaki AI tools install karna
RUN pip install --no-cache-dir -r requirements.txt

# 6. Hamara main.py code copy karna
COPY . .

# 7. Server ko on karna
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
