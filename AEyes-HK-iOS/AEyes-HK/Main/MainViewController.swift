import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("影相", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var processingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var descriptionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "文字"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .darkGray
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    private lazy var audioStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.text = "由 xAI 同 AWS 提供技術支援"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Camera Properties
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var photoOutput: AVCapturePhotoOutput?
    
    // MARK: - Service Properties
    private let imageAnalysisService = ImageAnalysisService()
    private let audioSynthesisService = AudioSynthesisService()
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCaptureSession()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        // Add subviews
        view.addSubview(cameraView)
        view.addSubview(captureButton)
        view.addSubview(processingTimeLabel)
        view.addSubview(descriptionContainerView)
        view.addSubview(footerLabel)
        view.addSubview(loadingIndicator)
        view.addSubview(audioStatusLabel)
        
        descriptionContainerView.addSubview(descriptionTitleLabel)
        descriptionContainerView.addSubview(descriptionTextView)
        
        // Configure constraints
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cameraView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            captureButton.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 20),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 200),
            captureButton.heightAnchor.constraint(equalToConstant: 60),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            
            processingTimeLabel.topAnchor.constraint(equalTo: captureButton.bottomAnchor, constant: 10),
            processingTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionContainerView.topAnchor.constraint(equalTo: processingTimeLabel.bottomAnchor, constant: 20),
            descriptionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionContainerView.bottomAnchor.constraint(equalTo: audioStatusLabel.topAnchor, constant: -20),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: 15),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: 15),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -15),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: 15),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -15),
            descriptionTextView.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: -15),
            
            audioStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            audioStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            audioStatusLabel.bottomAnchor.constraint(equalTo: footerLabel.topAnchor, constant: -20),
            audioStatusLabel.heightAnchor.constraint(equalToConstant: 30),
            
            footerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            footerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            footerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
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
        videoPreviewLayer?.frame = cameraView.bounds
        
        if let videoPreviewLayer = videoPreviewLayer {
            cameraView.layer.addSublayer(videoPreviewLayer)
        }
    }
    
    private func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    private func stopCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.stopRunning()
        }
    }
    
    // MARK: - Action Methods
    @objc private func captureButtonTapped() {
        capturePhoto()
    }
    
    private func capturePhoto() {
        guard let photoOutput = photoOutput else { return }
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .auto
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
        
        // UI changes for processing state
        loadingIndicator.startAnimating()
        captureButton.isEnabled = false
        audioStatusLabel.isHidden = true
        descriptionContainerView.isHidden = true
        processingTimeLabel.isHidden = true
    }
    
    private func processImage(_ image: UIImage) {
        let startTime = Date()
        
        // First, analyze the image
        imageAnalysisService.analyzeImage(image) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let description):
                // Calculate processing time
                let processingTime = Date().timeIntervalSince(startTime)
                
                // Then, generate audio from the description
                self.audioSynthesisService.generateAudio(from: description) { audioResult in
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        self.captureButton.isEnabled = true
                        
                        // Display processing time
                        self.processingTimeLabel.text = String(format: "處理時間: %.2f 秒", processingTime)
                        self.processingTimeLabel.isHidden = false
                        
                        // Display description
                        self.descriptionTextView.text = description
                        self.descriptionContainerView.isHidden = false
                        
                        // Handle audio playback
                        switch audioResult {
                        case .success(let audioData):
                            self.playAudio(audioData)
                            self.audioStatusLabel.text = "語音描述已播放 🎙️"
                            self.audioStatusLabel.textColor = .systemGreen
                            self.audioStatusLabel.isHidden = false
                        case .failure(let error):
                            self.audioStatusLabel.text = "無法生成語音"
                            self.audioStatusLabel.textColor = .systemRed
                            self.audioStatusLabel.isHidden = false
                            print("Audio generation error: \(error)")
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.captureButton.isEnabled = true
                    self.showAlert(title: "錯誤", message: "無法分析相片: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func playAudio(_ audioData: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension MainViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.captureButton.isEnabled = true
                self.showAlert(title: "錯誤", message: "拍照時發生錯誤")
            }
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.captureButton.isEnabled = true
                self.showAlert(title: "錯誤", message: "無法處理相片")
            }
            return
        }
        
        processImage(image)
    }
}