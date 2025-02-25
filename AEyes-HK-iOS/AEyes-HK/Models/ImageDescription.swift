import Foundation

struct ImageDescription: Codable {
    let text: String
    let timestamp: Date
    let processingTimeSeconds: Double
    let metadata: Metadata
    
    struct Metadata: Codable {
        let imageSize: ImageSize
        let containsText: Bool
        let containsPersons: Bool
        let containsObjects: Bool
        let detectedLanguage: String?
        let tags: [String]
        
        struct ImageSize: Codable {
            let width: Int
            let height: Int
            
            var aspectRatio: Double {
                return Double(width) / Double(height)
            }
        }
    }
    
    init(text: String, processingTime: Double, imageWidth: Int, imageHeight: Int) {
        self.text = text
        self.timestamp = Date()
        self.processingTimeSeconds = processingTime
        
        // Default metadata values - in a real app, these would be parsed from the API response
        self.metadata = Metadata(
            imageSize: Metadata.ImageSize(width: imageWidth, height: imageHeight),
            containsText: text.contains("文字") || text.contains("標誌") || text.contains("sign") || text.contains("text"),
            containsPersons: text.contains("人") || text.contains("person") || text.contains("people"),
            containsObjects: true, // Assume objects are detected
            detectedLanguage: "yue-HK", // Cantonese (Hong Kong)
            tags: extractTags(from: text)
        )
    }
    
    /// Extract potential tags from description text
    private static func extractTags(from text: String) -> [String] {
        // Simple tag extraction - in a real app, this would be more sophisticated
        let commonNouns = [
            "建築", "樓", "大廈", "街", "路", "車", "汽車", "巴士", "公車",
            "人", "標誌", "招牌", "店", "商店", "食肆", "餐廳", "椅",
            "桌", "門", "窗", "樹", "植物", "花", "山", "公園", "湖"
        ]
        
        var tags: [String] = []
        
        for noun in commonNouns {
            if text.contains(noun) && !tags.contains(noun) {
                tags.append(noun)
            }
        }
        
        // Limit to 10 tags
        return Array(tags.prefix(10))
    }
}

// MARK: - Description History Manager
class DescriptionHistoryManager {
    // MARK: - Properties
    static let shared = DescriptionHistoryManager()
    private let maxHistoryItems = 50
    private let historyKey = "com.aeyes.hk.descriptionHistory"
    
    private init() {}
    
    // MARK: - Public Methods
    /// Save a description to history
    func saveDescription(_ description: ImageDescription) {
        var history = getHistory()
        
        // Add new description at the beginning
        history.insert(description, at: 0)
        
        // Limit the number of items
        if history.count > maxHistoryItems {
            history = Array(history.prefix(maxHistoryItems))
        }
        
        // Save to UserDefaults
        saveHistory(history)
        
        Logger.info("Saved description to history. Total items: \(history.count)", category: .general)
    }
    
    /// Get all description history
    func getHistory() -> [ImageDescription] {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            return []
        }
        
        do {
            let history = try JSONDecoder().decode([ImageDescription].self, from: data)
            return history
        } catch {
            Logger.error("Failed to decode description history: \(error.localizedDescription)", category: .general)
            return []
        }
    }
    
    /// Clear all history
    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: historyKey)
        Logger.info("Description history cleared", category: .general)
    }
    
    // MARK: - Private Methods
    private func saveHistory(_ history: [ImageDescription]) {
        do {
            let data = try JSONEncoder().encode(history)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            Logger.error("Failed to encode description history: \(error.localizedDescription)", category: .general)
        }
    }
}