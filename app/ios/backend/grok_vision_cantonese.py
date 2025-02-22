# grok_vision_cantonese.py
import os
import base64
from typing import Optional
from openai import OpenAI
from dotenv import load_dotenv
import boto3

# Load environment variables once at module level
load_dotenv()
XAI_API_KEY = os.getenv("XAI_API_KEY")
if not XAI_API_KEY:
    raise ValueError("API key not found in .env file. Please set XAI_API_KEY.")

# Initialize clients globally (can be reused)
XAI_CLIENT = OpenAI(api_key=XAI_API_KEY, base_url="https://api.x.ai/v1")
POLLY_CLIENT = boto3.client('polly', region_name='us-east-1')  # Adjust region as needed

def encode_image(image_path: str) -> str:
    """Encode a local image file to base64 string."""
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

def get_image_description(image_path: str, model: str = "grok-2-vision-1212") -> str:
    """Get a Cantonese description of the image from Grok API."""
    base64_image = encode_image(image_path)
    
    # System prompt for vision aid product
    system_prompt = """
    你係一個專為視障人士設計嘅智能視覺輔助工具。請用繁體中文（廣東話風格）詳細描述圖片內容，重點關注以下幾點：
    1. 圖中有咩主要物件？包括它們嘅形狀、大小、顏色同位置。
    2. 有無任何潛在危險或障礙（例如尖銳嘅東西、地面嘅不平坦、或者阻擋路徑嘅物件）？
    3. 如果有文字，請讀出並解釋其意思。
    4. 提供一個清晰嘅空間關係描述，幫用家想像周圍嘅布局。
    5. 如果係交通站，如巴士站，可以講下目的地、巴士號碼等。
    請用精簡、自然、易明嘅廣東話語氣，確保描述夠精簡同實用，方便視障人士安全行動同理解環境。
    """
    
    # User prompt is now simpler, as the system prompt carries the detailed instructions
    user_prompt = "請描述呢張圖嘅內容。"

    response = XAI_CLIENT.chat.completions.create(
        model=model,
        messages=[
            {"role": "system", "content": system_prompt},
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": user_prompt},
                    {"type": "image_url", "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"}}
                ]
            }
        ],
        max_tokens=2000
    )
    return response.choices[0].message.content

def text_to_cantonese_audio(text: str, output_file: str = "output.mp3") -> Optional[str]:
    """Convert text to Cantonese audio using AWS Polly and save to file."""
    polly_response = POLLY_CLIENT.synthesize_speech(
        Engine='neural',
        Text=text,
        OutputFormat='mp3',
        VoiceId='Hiujin',  # Cantonese voice
        LanguageCode='yue-CN'
    )
    
    if 'AudioStream' in polly_response:
        with open(output_file, 'wb') as audio_file:
            audio_file.write(polly_response['AudioStream'].read())
        return output_file
    return None

def process_image_to_audio(image_path: str) -> tuple[str, Optional[str]]:
    """Process an image to get description and audio."""
    description = get_image_description(image_path)
    audio_file = text_to_cantonese_audio(description)
    return description, audio_file

# Example usage
if __name__ == "__main__":
    image_path = "path/to/your/image.jpg"
    desc, audio = process_image_to_audio(image_path)
    print(f"Description: {desc}")
    print(f"Audio saved as: {audio}")