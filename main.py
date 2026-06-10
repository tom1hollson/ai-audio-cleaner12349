from fastapi import FastAPI, File, UploadFile
from fastapi.responses import FileResponse
import subprocess
import os
import shutil

app = FastAPI()

@app.get("/")
def home():
    return {"message": "✅ Cloud Server is Live & Active! 🚀"}

@app.post("/enhance")
async def enhance_audio(file: UploadFile = File(...)):
    input_path = f"temp_{file.filename}"
    with open(input_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
        
    wav_path = "processing.wav"
    
    # 1. Audio ko format karna
    subprocess.run(["ffmpeg", "-y", "-i", input_path, "-ar", "48000", wav_path], capture_output=True)
    
    # 2. AI Tool ko bina "mute" kiye chalana taaki error pakda ja sake
    ai_process = subprocess.run(["deepFilter", wav_path], capture_output=True, text=True)
    
    output_path = "processing_DeepFilterNet3.wav"
    
    if os.path.exists(input_path): os.remove(input_path)
    if os.path.exists(wav_path): os.remove(wav_path)
    
    # 3. Agar success hua toh file bhejo, warna poora error browser mein dikhao
    if os.path.exists(output_path):
        return FileResponse(output_path, media_type="audio/wav", filename=f"Cleaned_{file.filename}")
    else:
        return {
            "error": "AI Processing Failed",
            "reason": ai_process.stderr,   # Yeh line asli culprit pakdegi!
            "logs": ai_process.stdout
        }
