# main.py
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from grok_vision_cantonese import process_image_to_audio
import shutil
import os

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with your app's domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/process-image")
async def process_image(file: UploadFile = File(...)):
    # Save uploaded file temporarily
    temp_path = f"temp_{file.filename}"
    with open(temp_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    
    # Process image
    try:
        description, audio_path = process_image_to_audio(temp_path)
        
        # In production, you would upload the audio file to a cloud storage
        # and return the URL instead of the file path
        
        return {
            "description": description,
            "audioUrl": f"/audio/{os.path.basename(audio_path)}"
        }
    finally:
        # Clean up temporary files
        if os.path.exists(temp_path):
            os.remove(temp_path)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)