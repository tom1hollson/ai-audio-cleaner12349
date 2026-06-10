from fastapi import FastAPI, File, UploadFile
from fastapi.responses import FileResponse
import subprocess
import os
import shutil

app = FastAPI(title="AI Audio Cleaner API")

@app.get("/")
def home():
    return {"message": "Cloud Server is Live & Active! 🚀"}

@app.post("/enhance")
async def enhance_audio(file: UploadFile = File(...)):
    # 1. Temporary file name setup
    input_path = f"temp_{file.filename}"
    
    # 2. Uploaded file ko server par save karna
    with open(input_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
        
    wav_path = "processing.wav"
    
    # 3. Audio ko 48kHz WAV format mein convert karna
    subprocess.run(["ffmpeg", "-y", "-i", input_path, "-ar", "48000", wav_path], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    # 4. DeepFilterNet AI CLI tool chalana
    # Cloud (Linux) par hum direct deepFilter executable use kar sakte hain
    subprocess.run(["deepFilter", wav_path], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    output_path = "processing_DeepFilterNet3.wav"
    
    # 5. Temporary kachra saaf karna
    if os.path.exists(input_path): os.remove(input_path)
    if os.path.exists(wav_path): os.remove(wav_path)
    
    # 6. Agar AI ne file bana di toh wapas bhejna, warna error dena
    if os.path.exists(output_path):
        return FileResponse(output_path, media_type="audio/wav", filename=f"Cleaned_{file.filename}")
    else:
        return {"error": "AI Processing Failed. Check server logs."}
