# 1. Base Python system lana
FROM python:3.11-slim

# 2. System ko update karna aur FFmpeg, Cargo, Audio Drivers, aur GIT install karna
RUN apt-get update && apt-get install -y ffmpeg cargo libsndfile1 git && rm -rf /var/lib/apt/lists/*

# 3. Kaam karne ki jagah set karna
WORKDIR /app

# 4. Requirements copy karna
COPY requirements.txt .

# 5. PyTorch 2.1.2 CPU version install karna
RUN pip install --no-cache-dir torch==2.1.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cpu

# 6. Baaki AI tools install karna
RUN pip install --no-cache-dir -r requirements.txt

# 7. Hamara main.py code copy karna
COPY . .

# 8. Server ko on karna
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
