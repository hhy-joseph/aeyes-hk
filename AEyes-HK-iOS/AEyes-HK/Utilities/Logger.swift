import Foundation
import os.log

/// Custom Logger for AEyes-HK app
class Logger {
    // MARK: - Log Categories
    enum Category: String {
        case general = "General"
        case network = "Network"
        case vision = "Vision"
        case audio = "Audio"
        case camera = "Camera"
        case ui = "UI"
        case error = "Error"
    }
    
    // MARK: - Log Levels
    enum Level: String {
        case debug = "🔍 DEBUG"
        case info = "ℹ️ INFO"
        case warning = "⚠️ WARNING"
        case error = "❌ ERROR"
        case critical = "🚨 CRITICAL"
        
        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .warning:
                return .default
            case .error:
                return .error
            case .critical:
                return .fault
            }
        }
    }
    
    // MARK: - Properties
    private static var isLoggingEnabled = true
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
    
    // OSLog objects for different categories
    private static let generalLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.aeyes.hk", category: Category.general.rawValue)
    private static let networkLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.aeyes.hk", category: Category.network.rawValue)
    private static let visionLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.aeyes.hk", category: Category.vision.rawValue)
    private static let audioLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.aeyes.hk", category: Category.audio.rawValue)
    private static let cameraLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.aeyes.hk", category: Category.camera.rawValue)
    private static let uiLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.aeyes.hk", category: Category.ui.rawValue)
    private static let errorLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.aeyes.hk", category: Category.error.rawValue)
    
    // MARK: - Public Methods
    /// Enable or disable logging
    static func setLoggingEnabled(_ enabled: Bool) {
        isLoggingEnabled = enabled
    }
    
    /// Log a message
    /// - Parameters:
    ///   - message: The message to log
    ///   - level: The severity level of the log
    ///   - category: The category of the log
    ///   - file: The file from which the log was called
    ///   - function: The function from which the log was called
    ///   - line: The line from which the log was called
    static func log(
        _ message: String,
        level: Level = .info,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isLoggingEnabled else { return }
        
        let timestamp = dateFormatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(timestamp)] [\(level.rawValue)] [\(fileName):\(line) \(function)] \(message)"
        
        // Log to console
        print(logMessage)
        
        // Log to OSLog
        let osLog = getOSLog(for: category)
        os_log("%{public}@", log: osLog, type: level.osLogType, message)
    }
    
    // MARK: - Convenience Methods
    static func debug(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, category: category, file: file, function: function, line: line)
    }
    
    static func critical(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .critical, category: category, file: file, function: function, line: line)
    }
    
    // MARK: - Helper Methods
    private static func getOSLog(for category: Category) -> OSLog {
        switch category {
        case .general:
            return generalLog
        case .network:
            return networkLog
        case .vision:
            return visionLog
        case .audio:
            return audioLog
        case .camera:
            return cameraLog
        case .ui:
            return uiLog
        case .error:
            return errorLog
        }
    }
}

// MARK: - Error Extension
extension Error {
    /// Log an error with appropriate category
    func log(category: Logger.Category = .error, file: String = #file, function: String = #function, line: Int = #line) {
        Logger.error(self.localizedDescription, category: category, file: file, function: function, line: line)
    }
}