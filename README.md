# AEyes-HK: Accessibility Platform for the Visually Impaired

AEyes-HK is an innovative accessibility platform designed to empower visually impaired individuals by converting real-time visual information into detailed audio descriptions in Cantonese. Using advanced AI vision models and text-to-speech technology, this app transforms images—such as photos, signs, or documents—into natural, easy-to-understand narrations, enabling users to "see" their surroundings through sound.

Built with xAI's Grok Vision for image analysis and AWS Polly for Cantonese audio synthesis, AEyes-HK aims to provide a portable, real-time, and affordable alternative to traditional assistive tools like screen readers or human aides.

## Features

* **Real-Time Image Processing**: Point your phone camera at an object or scene, and get an instant audio description in Cantonese.
* **Detailed Descriptions**: Highlights key objects, potential hazards, environmental context, and text (e.g., signs or labels).
* **Cantonese Narration**: Uses AWS Polly's neural Cantonese voice (Hiujin) for natural and clear audio output.
* **User-Friendly Interface**: Built with Streamlit, featuring an iOS-inspired design for simplicity and accessibility.
* **Safety-Focused**: Alerts users to obstacles or dangers in their environment.

## How It Works

1. **Capture**: Users upload an image (simulating a camera feed in the prototype).
2. **Analyze**: The image is processed by xAI's Grok Vision model, generating a detailed Cantonese description.
3. **Narrate**: The description is converted into audio using AWS Polly and played automatically.
4. **Interact**: Users can view the text description and replay the audio as needed.

## Target Audience

* **Visually Impaired Individuals**: Primary users seeking independence in navigating their surroundings.
* **Caregivers**: Supporting visually impaired loved ones with a reliable tool.
* **Assistive Technology Providers**: Organizations looking to integrate or license this technology.

## Monetization Potential

* **Subscription Model**: Monthly or yearly plans for individual users.
* **Partnerships**: Collaborate with accessibility organizations or NGOs.
* **Licensing**: Offer the tech to smartphone manufacturers or assistive device companies.

## Prerequisites

To run AEyes-HK locally, ensure you have the following:

* Python 3.8+
* xAI API Key: Obtain from xAI for Grok Vision access.
* AWS Credentials: Set up an AWS account with access to Polly.
* Dependencies: Listed in requirements.txt (see Installation).

## Installation

### Clone the Repository:
```bash
git clone https://github.com/hhy-joseph/aeyes-hk.git
cd aeyes-hk
```

### Set Up a Virtual Environment (optional but recommended):
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### Install Dependencies:
```bash
pip install -r requirements.txt
```

Required packages include streamlit, openai, boto3, python-dotenv, and others.

### Configure Environment Variables:
Create a `.env` file in the root directory with the following:
```text
XAI_API_KEY=your_xai_api_key_here
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
```

### Run the App:
```bash
streamlit run app.py
```

## Usage

1. Launch the App: After running the command above, open your browser at http://localhost:8501.
2. Upload an Image: Use the file uploader to simulate taking a photo (future versions will integrate live camera feeds).
3. Listen: The app processes the image, displays the description, and auto-plays the Cantonese audio narration.
4. Review: Expand the "文字" (Text) section to read the description if needed.

### Example:

Upload a photo of a busy street.
AEyes-HK might describe: "你面前係一條繁忙嘅街道，有幾架車喺左邊行緊，右邊有個行人路，中間有條斑馬線。小心路面有啲不平坦嘅地方。"

## Project Structure

```text
aeyes-hk/
├── grok_vision_cantonese.py  # Core logic for image processing and audio generation
├── app.py                   # Streamlit frontend (assumed name based on context)
├── requirements.txt         # Python dependencies
├── .env                     # Environment variables (not tracked in git)
├── README.md                # This file
└── temp_files/              # Temporary storage for uploaded images and audio (auto-deleted)
```

## Technical Details

* **Image Analysis**: Uses xAI's grok-2-vision-1212 model to interpret images with a custom Cantonese prompt.
* **Audio Synthesis**: Leverages AWS Polly's Hiujin voice for neural Cantonese narration.
* **Frontend**: Streamlit with custom CSS for an iOS-like, accessible design.
* **Performance**: Processing time is displayed for each image (typically a few seconds).

## Future Enhancements

* **Live Camera Integration**: Replace file uploads with real-time camera input.
* **Multilingual Support**: Add Mandarin, English, or other languages.
* **Mobile App**: Deploy as a native iOS/Android app.
* **Obstacle Detection AI**: Improve hazard identification with machine learning.
* **Offline Mode**: Cache common descriptions for use without internet.

## Contributing

We welcome contributions! Please:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature-name`).
3. Submit a pull request with a clear description of changes.

## License

This project is licensed under the MIT License. See LICENSE for details (to be added).

## Acknowledgments

* xAI: For providing the Grok Vision API.
* AWS: For Polly's text-to-speech capabilities.
* Streamlit: For an easy-to-use web framework.

## Contact

For questions, feedback, or collaboration, reach out at joseph.hohoyin@gmail.com.

---

*Last Updated: February 22, 2025*