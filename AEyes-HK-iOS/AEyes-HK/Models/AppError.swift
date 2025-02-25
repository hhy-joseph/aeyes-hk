import Foundation

enum AppError: Error {
    case imageConversionFailed
    case noDataReceived
    case responseParsing
    case apiError(String)
    case audioGenerationFailed
    case apiKeyNotFound
    case networkError
    
    var localizedDescription: String {
        switch self {
        case .imageConversionFailed:
            return "Failed to convert image to base64"
        case .noDataReceived:
            return "No data received from the server"
        case .responseParsing:
            return "Failed to parse the response from the server"
        case .apiError(let message):
            return "API Error: \(message)"
        case .audioGenerationFailed:
            return "Failed to generate audio from text"
        case .apiKeyNotFound:
            return "API key not found in configuration"
        case .networkError:
            return "Network connection error"
        }
    }
}