import UIKit
import Foundation

class ImageAnalysisService {
    private let apiURL = URL(string: "https://api.x.ai/v1/chat/completions")!
    private var apiKey: String {
        return APIKeys.xAIAPIKey
    }
    
    func analyzeImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let base64Image = image.jpegData(compressionQuality: 0.7)?.base64EncodedString() else {
            completion(.failure(AppError.imageConversionFailed))
            return
        }
        
        // Create the request body
        let requestBody: [String: Any] = [
            "model": "grok-2-vision-1212",
            "messages": [
                [
                    "role": "system",
                    "content": """
                    你係一個專為視障人士設計嘅智能視覺輔助工具。請用繁體中文（廣東話風格）詳細描述圖片內容，重點關注以下幾點：
                    1. 圖中有咩主要物件？包括它們嘅形狀、大小、顏色同位置。
                    2. 有無任何潛在危險或障礙（例如尖銳嘅東西、地面嘅不平坦、或者阻擋路徑嘅物件）？
                    3. 如果有文字，請讀出並解釋其意思。
                    4. 提供一個清晰嘅空間關係描述，幫用家想像周圍嘅布局。
                    5. 如果係交通站，如巴士站，可以講下目的地、巴士號碼等。
                    請用精簡、自然、易明嘅廣東話語氣，確保描述夠精簡同實用，方便視障人士安全行動同理解環境。
                    """
                ],
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": "請描述呢張圖嘅內容。"
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 2000
        ]
        
        // Create request
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(AppError.noDataReceived))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content))
                } else {
                    // Try to get error message if available
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let error = json["error"] as? [String: Any],
                       let message = error["message"] as? String {
                        completion(.failure(AppError.apiError(message)))
                    } else {
                        completion(.failure(AppError.responseParsing))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}