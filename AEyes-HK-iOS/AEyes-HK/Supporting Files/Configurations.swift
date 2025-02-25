import Foundation

/// App-wide configuration settings
class Configurations {
    
    // MARK: - Shared Instance
    static let shared = Configurations()
    private init() {
        // Private initialization to enforce singleton pattern
        loadEnvironmentSettings()
    }
    
    // MARK: - Environment
    enum Environment: String {
        case development = "Development"
        case staging = "Staging"
        case production = "Production"
    }
    
    /// Current environment the app is running in
    private(set) var currentEnvironment: Environment = .development
    
    /// Determines if app is running in a debug build
    var isDebugBuild: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - API Configuration
    
    /// Base URL for xAI API
    var xAIBaseURL: String {
        switch currentEnvironment {
        case .development:
            return "https://api.x.ai/v1"
        case .staging:
            return "https://api.x.ai/v1"
        case .production:
            return "https://api.x.ai/v1"
        }
    }
    
    /// xAI model to use for image analysis
    var xAIModel: String {
        return "grok-2-vision-1212"
    }
    
    /// AWS region for Polly service
    var awsRegion: String {
        return "us-east-1"
    }
    
    /// AWS Polly voice ID for Cantonese
    var awsPollyVoiceId: String {
        return "Hiujin"
    }
    
    // MARK: - App Settings
    
    /// Version number from Info.plist
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    /// Build number from Info.plist
    var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    /// Full version string (version + build)
    var fullVersionString: String {
        return "\(appVersion) (\(buildNumber))"
    }
    
    // MARK: - Feature Flags
    
    /// Whether to enable history tracking
    var isHistoryTrackingEnabled: Bool = true
    
    /// Whether to save images with descriptions
    var isSaveImagesEnabled: Bool = false
    
    /// Whether to automatically play audio after processing
    var isAutoPlayAudioEnabled: Bool = true
    
    /// Whether to use high quality audio
    var isHighQualityAudioEnabled: Bool = true
    
    /// Whether to enable offline mode capabilities
    var isOfflineModeEnabled: Bool = false
    
    // MARK: - Performance Settings
    
    /// Maximum image dimension for upload (to reduce bandwidth)
    var maxImageDimension: CGFloat = 1200
    
    /// JPEG compression quality for image upload (0.0-1.0)
    var imageCompressionQuality: CGFloat = 0.7
    
    /// Maximum number of description history items to store
    var maxHistoryItems: Int = 50
    
    /// Timeout for API requests in seconds
    var apiTimeoutSeconds: TimeInterval = 30
    
    /// Maximum tokens to request from xAI
    var maxTokens: Int = 2000
    
    // MARK: - Accessibility Settings
    
    /// Default speech rate for VoiceOver
    var defaultSpeechRate: Float = 0.5 // 0.0-1.0
    
    /// Whether to use high contrast mode by default
    var useHighContrastByDefault: Bool = false
    
    /// Whether to reduce motion effects
    var reduceMotion: Bool = false
    
    // MARK: - Developer Settings
    
    /// Whether to enable detailed logging
    var isVerboseLoggingEnabled: Bool {
        return isDebugBuild || UserDefaults.standard.bool(forKey: "enable_verbose_logging")
    }
    
    /// Whether to show developer menu
    var isDevMenuEnabled: Bool {
        return isDebugBuild || UserDefaults.standard.bool(forKey: "enable_dev_menu")
    }
    
    /// Whether to simulate API responses (for testing)
    var useSimulatedResponses: Bool {
        return UserDefaults.standard.bool(forKey: "use_simulated_responses")
    }
    
    // MARK: - Methods
    
    /// Load environment settings based on build configuration
    private func loadEnvironmentSettings() {
        #if DEBUG
        currentEnvironment = .development
        #else
        // Check if a specific environment is forced via UserDefaults (for testing)
        if let environmentString = UserDefaults.standard.string(forKey: "forced_environment"),
           let environment = Environment(rawValue: environmentString) {
            currentEnvironment = environment
        } else {
            // Use app store configuration
            currentEnvironment = .production
        }
        #endif
        
        // Log the environment
        Logger.info("App running in \(currentEnvironment.rawValue) environment", category: .general)
    }
    
    /// Update feature flag
    func updateFeatureFlag(_ key: String, value: Bool) {
        switch key {
        case "history_tracking":
            isHistoryTrackingEnabled = value
        case "save_images":
            isSaveImagesEnabled = value
        case "auto_play_audio":
            isAutoPlayAudioEnabled = value
        case "high_quality_audio":
            isHighQualityAudioEnabled = value
        case "offline_mode":
            isOfflineModeEnabled = value
        default:
            Logger.warning("Unknown feature flag: \(key)", category: .general)
        }
        
        // Save to UserDefaults for persistence
        UserDefaults.standard.set(value, forKey: "feature_\(key)")
    }
    
    /// Load saved preferences
    func loadSavedPreferences() {
        // Load feature flags from UserDefaults
        isHistoryTrackingEnabled = UserDefaults.standard.bool(forKey: "feature_history_tracking")
        isSaveImagesEnabled = UserDefaults.standard.bool(forKey: "feature_save_images")
        isAutoPlayAudioEnabled = UserDefaults.standard.bool(forKey: "feature_auto_play_audio")
        isHighQualityAudioEnabled = UserDefaults.standard.bool(forKey: "feature_high_quality_audio")
        isOfflineModeEnabled = UserDefaults.standard.bool(forKey: "feature_offline_mode")
        
        // Load accessibility settings
        if UserDefaults.standard.object(forKey: "speech_rate") != nil {
            defaultSpeechRate = UserDefaults.standard.float(forKey: "speech_rate")
        }
        
        if UserDefaults.standard.object(forKey: "high_contrast") != nil {
            useHighContrastByDefault = UserDefaults.standard.bool(forKey: "high_contrast")
        }
        
        if UserDefaults.standard.object(forKey: "reduce_motion") != nil {
            reduceMotion = UserDefaults.standard.bool(forKey: "reduce_motion")
        }
        
        // Load performance settings
        if UserDefaults.standard.object(forKey: "max_image_dimension") != nil {
            maxImageDimension = CGFloat(UserDefaults.standard.float(forKey: "max_image_dimension"))
        }
        
        if UserDefaults.standard.object(forKey: "image_compression_quality") != nil {
            imageCompressionQuality = CGFloat(UserDefaults.standard.float(forKey: "image_compression_quality"))
        }
    }
    
    /// Reset all settings to defaults
    func resetToDefaults() {
        // Clear only app-specific UserDefaults
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        dictionary.keys
            .filter { $0.starts(with: "feature_") || $0 == "speech_rate" || $0 == "high_contrast" || $0 == "reduce_motion" }
            .forEach { UserDefaults.standard.removeObject(forKey: $0) }
        
        // Reset properties to default values
        isHistoryTrackingEnabled = true
        isSaveImagesEnabled = false
        isAutoPlayAudioEnabled = true
        isHighQualityAudioEnabled = true
        isOfflineModeEnabled = false
        defaultSpeechRate = 0.5
        useHighContrastByDefault = false
        reduceMotion = false
        maxImageDimension = 1200
        imageCompressionQuality = 0.7
        
        Logger.info("Reset all settings to defaults", category: .general)
    }
}