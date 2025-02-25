# Camera Integration Guide for AEyes-HK iOS App

This guide explains how to set up and test the camera functionality in the AEyes-HK iOS app, which is critical for the application's core purpose.

## Camera Permission Configuration

### 1. Verify Info.plist Settings

The app requires camera access to function properly. Ensure these entries exist in your Info.plist file:

```xml
<key>NSCameraUsageDescription</key>
<string>AEyes-HK needs to access your camera to capture photos and provide visual descriptions.</string>

<key>NSMicrophoneUsageDescription</key>
<string>AEyes-HK needs microphone access to support audio recording features.</string>
```

### 2. Check Privacy Settings on Test Device

If testing on a physical device, verify camera permissions:
1. Go to Settings → Privacy → Camera
2. Ensure AEyes-HK has camera access enabled

## Camera Implementation Details

The camera functionality is implemented across several files:

1. **MainViewController.swift** - Contains camera session setup and photo capture logic
2. **MainView.swift** - Provides the UI component that displays the camera preview
3. **AVCaptureDevice Extension** - Handles permission requests

### Key Code Sections

#### Camera Setup in MainViewController.swift

The camera setup is initialized in the `setupCamera()` method:

```swift
private func setupCamera() {
    captureSession = AVCaptureSession()
    captureSession?.sessionPreset = .high
    
    guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
          let input = try? AVCaptureDeviceInput(device: backCamera) else {
        showAlert(title: "Camera Error", message: "無法存取相機")
        return
    }
    
    if captureSession?.canAddInput(input) == true {
        captureSession?.addInput(input)
    }
    
    photoOutput = AVCapturePhotoOutput()
    if captureSession?.canAddOutput(photoOutput!) == true {
        captureSession?.addOutput(photoOutput!)
    }
    
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
    videoPreviewLayer?.videoGravity = .resizeAspectFill
    videoPreviewLayer?.frame = mainView.cameraView.bounds
    
    if let videoPreviewLayer = videoPreviewLayer {
        mainView.configureVideoPreviewLayer(videoPreviewLayer)
    }
}
```

#### Camera Permissions Request

The app uses this extension method to request camera access:

```swift
// Extension in Extensions.swift
extension AVCaptureDevice {
    /// Request camera access with completion handler
    static func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}
```

## Troubleshooting Camera Issues

### Common Issues and Solutions

1. **Black Camera Preview**
   - Issue: Camera preview appears black but no error is displayed
   - Solution: 
     - Ensure camera permissions are granted
     - Make sure the AVCaptureSession is started on a background thread
     - Check that the preview layer is properly added to the view hierarchy

2. **Permission Denied**
   - Issue: User denied camera permission
   - Solution:
     - Direct user to the Settings app to manually enable permissions
     - Implement a helpful message explaining why camera access is needed

3. **Camera Not Available**
   - Issue: Device camera hardware is not available
   - Solution:
     - Check if running in simulator (camera not available)
     - Verify the device has a camera
     - Ensure no other app is currently using the camera

### Simulator vs Physical Device

- The camera functionality **will not work** in the iOS Simulator
- Always test camera features on a physical iOS device
- For investor demonstrations, ensure you have a physical device ready

## Testing Camera Functionality

Follow these steps to test the camera functionality:

1. Build and run the app on a physical iOS device
2. Grant camera permission when prompted
3. You should see the camera preview in the main view
4. Tap the "影相" (Take Photo) button to capture an image
5. Verify that image processing begins (loading indicator appears)
6. Check that the description and audio are generated

## Optimizing Camera Performance

For best camera performance, especially for investors demonstrations:

1. **Lighting Conditions**
   - Ensure adequate lighting for clear image capture
   - Avoid extreme lighting conditions (very dark or bright)

2. **Focus and Stability**
   - Hold the device steady when capturing images
   - Allow auto-focus to complete before capturing

3. **Subject Selection**
   - Choose subjects with clear features and good contrast
   - Include text elements to demonstrate text recognition capabilities
   - Include diverse elements to showcase comprehensive descriptions

## Accessibility Considerations

The camera interface is designed to be accessible for visually impaired users:

1. **VoiceOver Support**
   - All camera controls have appropriate accessibility labels
   - Camera status is announced through VoiceOver

2. **Audio Feedback**
   - Audio cues indicate when a photo is taken
   - Clear verbal instructions guide the user

3. **Simple Interface**
   - Large, high-contrast buttons
   - Minimal UI elements to avoid confusion