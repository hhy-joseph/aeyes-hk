import UIKit
import AVFoundation

class MainView: UIView {
    
    // MARK: - UI Components
    lazy var cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.configureForAccessibility(
            label: Constants.Accessibility.cameraViewLabel,
            hint: Constants.Accessibility.cameraViewHint
        )
        return view
    }()
    
    lazy var captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Text.takePicture, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = Constants.Colors.primaryBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addShadow()
        button.configureForAccessibility(
            label: Constants.Accessibility.captureButtonLabel,
            hint: Constants.Accessibility.captureButtonHint,
            traits: .button
        )
        return button
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var processingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Constants.Colors.textDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorners()
        view.addShadow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.configureForAccessibility(
            label: Constants.Accessibility.descriptionContainerLabel,
            hint: Constants.Accessibility.descriptionContainerHint
        )
        return view
    }()
    
    lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.textDescription
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = Constants.Colors.textDarkGray
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.isAccessibilityElement = true
        return textView
    }()
    
    lazy var audioStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Constants.Colors.successGreen
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.configureForAccessibility(
            label: Constants.Accessibility.audioStatusLabel,
            hint: Constants.Accessibility.audioStatusHint
        )
        return label
    }()
    
    lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.footerText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.appTitle
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.appSubtitle
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = Constants.Colors.backgroundGray
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(cameraView)
        addSubview(captureButton)
        addSubview(processingTimeLabel)
        addSubview(descriptionContainerView)
        addSubview(footerLabel)
        addSubview(audioStatusLabel)
        
        // Add camera loading indicator
        cameraView.addSubview(loadingIndicator)
        
        // Add description components
        descriptionContainerView.addSubview(descriptionTitleLabel)
        descriptionContainerView.addSubview(descriptionTextView)
        
        // Configure constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Camera view
            cameraView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            cameraView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cameraView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cameraView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35),
            
            // Loading indicator centered in camera view
            loadingIndicator.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            
            // Capture button
            captureButton.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 20),
            captureButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 200),
            captureButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Processing time label
            processingTimeLabel.topAnchor.constraint(equalTo: captureButton.bottomAnchor, constant: 10),
            processingTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            processingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Description container
            descriptionContainerView.topAnchor.constraint(equalTo: processingTimeLabel.bottomAnchor, constant: 15),
            descriptionContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            descriptionContainerView.bottomAnchor.constraint(equalTo: audioStatusLabel.topAnchor, constant: -15),
            
            // Description title
            descriptionTitleLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: 15),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: 15),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -15),
            
            // Description text view
            descriptionTextView.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: 15),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -15),
            descriptionTextView.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: -15),
            
            // Audio status label
            audioStatusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            audioStatusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            audioStatusLabel.bottomAnchor.constraint(equalTo: footerLabel.topAnchor, constant: -15),
            audioStatusLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // Footer label
            footerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            footerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            footerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Public Methods
    
    /// Configure the preview layer for the camera
    func configureVideoPreviewLayer(_ previewLayer: AVCaptureVideoPreviewLayer) {
        previewLayer.frame = cameraView.bounds
        
        // Handle orientation
        previewLayer.connection?.videoOrientation = .portrait
        
        // Add to camera view
        if let existingLayer = cameraView.layer.sublayers?.first(where: { $0 is AVCaptureVideoPreviewLayer }) {
            existingLayer.removeFromSuperlayer()
        }
        
        cameraView.layer.insertSublayer(previewLayer, at: 0)
    }
    
    /// Update UI for loading state
    func showLoadingState() {
        loadingIndicator.startAnimating()
        captureButton.isEnabled = false
        audioStatusLabel.isHidden = true
        descriptionContainerView.isHidden = true
        processingTimeLabel.isHidden = true
    }
    
    /// Update UI after processing is complete
    func showResultState(description: String, processingTime: Double) {
        loadingIndicator.stopAnimating()
        captureButton.isEnabled = true
        
        // Display processing time
        processingTimeLabel.text = String(format: Constants.Text.processingTime, processingTime)
        processingTimeLabel.isHidden = false
        
        // Display description
        descriptionTextView.text = description
        descriptionContainerView.isHidden = false
    }
    
    /// Update audio status after playback
    func updateAudioStatus(success: Bool) {
        audioStatusLabel.text = success ? Constants.Text.audioPlayed : Constants.Text.audioError
        audioStatusLabel.textColor = success ? Constants.Colors.successGreen : Constants.Colors.errorRed
        audioStatusLabel.isHidden = false
    }
    
    /// Layout update for orientation changes
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update camera preview layer frame
        if let previewLayer = cameraView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = cameraView.bounds
        }
    }
}