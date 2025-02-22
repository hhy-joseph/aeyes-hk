import streamlit as st
from grok_vision_cantonese import process_image_to_audio
import os
import time

st.title('AEyes-HK : Accessibility Platform for the Visually Impaired')

# Custom CSS for iOS-like styling with image display
st.markdown("""
    <style>
    .main {
        background-color: #f5f5f5;
        padding: 20px;
    }
    .stButton>button {
        width: 100%;
        height: 60px;
        font-size: 20px;
        border-radius: 15px;
        background-color: #007AFF;
        color: white;
        border: none;
    }
    .stButton>button:hover {
        background-color: #005BB5;
    }
    .title {
        font-size: 36px;
        text-align: center;
        color: #000;
        font-weight: bold;
        margin-bottom: 10px;
    }
    .subtitle {
        font-size: 16px;
        text-align: center;
        color: #666;
        margin-bottom: 20px;
    }
    .image-container {
        display: flex;
        justify-content: center;
        margin: 20px 0;
    }
    .description-box {
        background-color: #fff;
        padding: 15px;
        border-radius: 10px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        font-size: 18px;
        color: #333;
    }
    </style>
""", unsafe_allow_html=True)

st.markdown('<p class="subtitle">用相機描述周圍環境 - 為視障人士設計</p>', unsafe_allow_html=True)  # "Describe surroundings with camera - Designed for the visually impaired"

# Simulate camera button with file uploader
camera_button = st.button("影相", key="camera")  # "Take a picture" in Cantonese
uploaded_file = st.file_uploader("", type=["jpg", "jpeg", "png"], label_visibility="collapsed")

# Process when an image is uploaded
if uploaded_file is not None:
    # Save the uploaded file temporarily
    temp_image_path = f"temp_{uploaded_file.name}"
    with open(temp_image_path, "wb") as f:
        f.write(uploaded_file.getbuffer())
    
    # Display the uploaded image
    st.markdown('<div class="image-container">', unsafe_allow_html=True)
    st.image(temp_image_path, caption="上載嘅相片", width=400)  # "Uploaded photo"
    st.markdown('</div>', unsafe_allow_html=True)
    
    # Process the image with loading spinner and timing
    with st.spinner("處理緊相片，請稍等..."):  # "Processing photo, please wait..."
        start_time = time.time()  # Start timing
        description, audio_file = process_image_to_audio(temp_image_path)
        processing_time = time.time() - start_time  # Calculate processing time
    
    # Display processing time
    st.markdown(f"**處理時間**: {processing_time:.2f} 秒", unsafe_allow_html=True)  # "Processing time: X.XX seconds"
    
    # Display description in a styled box
    with st.expander("文字"):
        st.markdown('<div class="description-box">', unsafe_allow_html=True)
        st.markdown(f"**描述**: {description}", unsafe_allow_html=True)  # "Description:"
        st.markdown('</div>', unsafe_allow_html=True)
    
    # Auto-play audio for vision aid
    if audio_file:
        audio_bytes = open(audio_file, "rb").read()
        st.audio(audio_bytes, format="audio/mp3", start_time=0,autoplay=True)
        st.success("語音描述已播放 🎙️")  # "Audio description played"
    else:
        st.error("無法生成語音")  # "Failed to generate audio"
    
    # Clean up temporary files
    os.remove(temp_image_path)
    if audio_file:
        os.remove(audio_file)
elif camera_button:
    st.warning("請上載一張相片以模擬影相功能")  # "Please upload a photo to simulate camera function"

# Footer
st.markdown('<p class="subtitle">由 xAI 同 AWS 提供技術支援</p>', unsafe_allow_html=True)  # "Powered by xAI and AWS"