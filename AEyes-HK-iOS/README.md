# AEyes-HK: Innovative Vision Assistant for the Visually Impaired

<p align="center">
  <img src="Documentation/app-icon.png" alt="AEyes-HK Logo" width="200" />
</p>

<p align="center">
  <b>Empowering visually impaired individuals through AI-powered visual descriptions</b>
</p>

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#features">Features</a> •
  <a href="#demo">Demo</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#technology">Technology</a> •
  <a href="#market-opportunity">Market Opportunity</a> •
  <a href="#investment-opportunity">Investment Opportunity</a>
</p>

## Overview

AEyes-HK is an innovative iOS application designed to transform the lives of visually impaired individuals by converting real-time visual information into detailed audio descriptions in Cantonese. Using advanced AI vision models (xAI's Grok Vision) and text-to-speech technology (AWS Polly), this app enables users to "see" their surroundings through natural, contextually rich audio narrations.

### Problem Statement

In Hong Kong alone, there are over 174,800 people with visual impairments. Traditional assistive technologies like screen readers only work with digital content, leaving the physical world inaccessible. Human assistance is inconsistent and limits independence, while specialized hardware solutions are prohibitively expensive.

### Our Solution

AEyes-HK provides an affordable, portable solution that helps visually impaired users:
- Navigate environments safely by identifying obstacles and hazards
- Read signs, menus, and other text in the real world
- Gain spatial awareness through detailed environmental descriptions
- Achieve greater independence in daily activities

## Features

<p align="center">
  <img src="Documentation/app-features.png" alt="AEyes-HK Features" width="800" />
</p>

- **Real-Time Image Analysis**: Instantly captures and analyzes the user's surroundings
- **Detailed Cantonese Descriptions**: Provides culturally appropriate, detailed audio descriptions
- **Safety-First Approach**: Proactively identifies potential hazards and obstacles
- **Text Recognition**: Reads and interprets signs, labels, and documents
- **Context-Aware Descriptions**: Focuses on the most relevant information for navigation
- **Accessible Interface**: Designed from the ground up for visually impaired users
- **High Performance**: Fast processing with low latency for real-time use

## Demo

<p align="center">
  <a href="https://youtu.be/demo-link"><img src="Documentation/demo-thumbnail.png" alt="Watch Demo Video" width="600" /></a>
</p>

Click the image above to watch our demo video showcasing AEyes-HK in action.

## Quick Start

### System Requirements

- **Development Environment**: 
  - macOS Ventura 13.0 or later
  - Xcode 14.0 or later
  - iOS 15.0+ deployment target
  - Swift 5.7+
  
- **Required Accounts**:
  - Apple Developer Account
  - xAI API key for Grok Vision
  - AWS account with access to Polly service

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-org/aeyes-hk-ios.git
   cd aeyes-hk-ios
   ```

2. **Install dependencies**:
   ```bash
   pod install
   ```

3. **Open the workspace**:
   ```bash
   open AEyes-HK.xcworkspace
   ```

4. **Configure API Keys**:
   - Create a file named `APIKeys.swift` in the `AEyes-HK/Supporting Files` directory
   - Add your xAI and AWS API keys to this file (template provided below)

   ```swift
   import Foundation

   struct APIKeys {
       static let xAIAPIKey = "YOUR_XAI_API_KEY"
       static let awsAccessKey = "YOUR_AWS_ACCESS_KEY"
       static let awsSecretKey = "YOUR_AWS_SECRET_KEY"
   }
   ```

5. **Build and run the project** in Xcode using the ▶ button

### Testing on a Physical Device

To test the app on an iOS device:

1. Connect your iPhone to your Mac with a USB cable
2. In Xcode, select your device from the device dropdown menu
3. Sign the app with your Apple Developer account:
   - Go to Xcode → Project Settings → Signing & Capabilities
   - Select your Team and let Xcode handle the provisioning profile
4. Click the ▶ button to build and run on your device
5. On first launch, you may need to approve the developer certificate:
   - On your iPhone, go to Settings → General → Device Management
   - Trust the developer certificate associated with your Apple ID

## Technology

<p align="center">
  <img src="Documentation/technology-stack.png" alt="AEyes-HK Technology Stack" width="700" />
</p>

### Key Components

- **iOS Native Development**: Built with Swift and UIKit for optimal performance
- **Advanced Computer Vision**: Powered by xAI's Grok Vision model
- **Neural Text-to-Speech**: AWS Polly with the Cantonese Hiujin voice
- **Camera Integration**: AVFoundation for real-time image capture
- **Accessibility-First Design**: VoiceOver compatible with enhanced accessibility features
- **Network Layer**: Robust handling of API requests with retry logic and offline capability

### Architecture

The app follows a clean architecture approach with these key components:

- **View Layer**: UIKit-based views with programmatic layout
- **Service Layer**: Image analysis and audio synthesis services
- **Model Layer**: Structured data models for descriptions and history
- **Network Layer**: Robust API communication with xAI and AWS
- **Utility Layer**: Reusable components, extensions, and helpers

## Market Opportunity

The global assistive technology market for visually impaired people is projected to reach $7.6 billion by 2027, growing at a CAGR of 7.5%. In Asia-Pacific alone, this market is growing at 9.2% annually, reflecting increasing demand and awareness.

### Target Users

1. **Primary**: 285 million visually impaired individuals worldwide
   - 39 million blind people
   - 246 million with low vision
   - Specific focus on 174,800 visually impaired people in Hong Kong

2. **Secondary**: 
   - Caregivers and family members
   - Elderly with deteriorating vision
   - Educational institutions for the visually impaired
   - Rehabilitation centers

### Competitive Advantage

- **AI Quality**: Uses xAI's state-of-the-art Grok Vision model
- **Regional Focus**: Optimized for Cantonese speakers in Hong Kong
- **Safety-First Approach**: Proactively identifies hazards
- **Affordable**: Fraction of the cost of dedicated hardware solutions
- **Mobile-First**: Leverages existing smartphone hardware

## Investment Opportunity

<p align="center">
  <img src="Documentation/investment-graph.png" alt="Investment Opportunity" width="600" />
</p>

### Funding Requirements

We are seeking $1,500,000 in seed funding to:

1. **Complete Development** ($300,000)
   - Finalize core functionality
   - Extensive accessibility testing with visually impaired users
   - Performance optimization

2. **Launch & Marketing** ($450,000)
   - App Store release
   - Partnerships with vision impairment organizations
   - Targeted digital marketing
   - User acquisition

3. **Team Expansion** ($550,000)
   - Additional iOS developers
   - Accessibility experts
   - AI/ML specialists
   - User support team

4. **R&D for Future Features** ($200,000)
   - Expanded language support
   - Offline functionality
   - Real-time video processing
   - Custom voice models

### Revenue Model

1. **Subscription Tiers**:
   - Basic (HK$38/month): Core functionality
   - Premium (HK$88/month): Advanced features, priority processing
   - Enterprise (HK$388/month): For organizations supporting multiple users

2. **Strategic Partnerships**:
   - White-label solutions for assistive device manufacturers
   - API access for integration with other accessibility tools
   - Custom solutions for rehabilitation centers and educational institutions

### Projected Returns

| Year | Users    | Revenue      | Profit       |
|------|----------|--------------|--------------|
| 1    | 5,000    | $340,000     | -$200,000    |
| 2    | 15,000   | $1,020,000   | $250,000     |
| 3    | 35,000   | $2,380,000   | $950,000     |
| 4    | 75,000   | $5,100,000   | $2,550,000   |
| 5    | 150,000  | $10,200,000  | $5,610,000   |

### Exit Strategy

Multiple potential exits are available:
- Acquisition by major tech companies (Apple, Google, Microsoft) integrating with their accessibility initiatives
- Acquisition by assistive technology companies looking to expand their digital offerings
- Potential IPO after significant market penetration

## Development Roadmap

<p align="center">
  <img src="Documentation/roadmap.png" alt="Development Roadmap" width="700" />
</p>

### Current Status (Q1 2025)

- ✅ Proof of concept completed
- ✅ Core iOS application architecture designed
- ✅ xAI Grok Vision integration functional
- ✅ AWS Polly voice synthesis working
- ✅ Basic UI implemented

### Next Steps

| Timeline | Milestone |
|----------|-----------|
| Q2 2025  | Beta version with core functionality |
| Q3 2025  | Field testing with visually impaired users |
| Q4 2025  | V1.0 App Store release |
| Q1 2026  | International expansion (Mandarin, English) |
| Q2 2026  | V2.0 with advanced features (object recognition) |

## Team

<p align="center">
  <img src="Documentation/team.png" alt="AEyes-HK Team" width="600" />
</p>

Our team combines expertise in AI, accessibility, and mobile development:

- **Joseph Ho (Founder & CEO)**: Computer vision specialist, 10+ years experience
- **Dr. Sarah Chen (CTO)**: PhD in Machine Learning, former Google AI researcher
- **Michael Wong (iOS Lead)**: Senior iOS Developer, ex-Apple, 8+ years experience
- **Lisa Zhang (Accessibility Specialist)**: Certified accessibility consultant, visually impaired
- **David Lau (Business Development)**: 15+ years in assistive technology market

## Get Involved

We welcome partnerships, investment inquiries, and feedback:

- **Email**: joseph.hohoyin@gmail.com
- **Website**: [aeyes-hk.com](https://aeyes-hk.com)
- **LinkedIn**: [AEyes-HK](https://linkedin.com/company/aeyes-hk)

---

<p align="center">
  <i>Helping the visually impaired to see the world through sound</i>
</p>