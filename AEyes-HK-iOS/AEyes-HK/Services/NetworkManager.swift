import Foundation
import Network

/// Network manager for handling API requests and monitoring connectivity
class NetworkManager {
    // MARK: - Singleton
    static let shared = NetworkManager()
    private init() {
        setupNetworkMonitoring()
    }
    
    // MARK: - Properties
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private(set) var isConnected = true
    private(set) var connectionType: ConnectionType = .unknown
    
    /// Network connection types
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    // MARK: - Network Requests
    func performRequest<T: Decodable>(
        urlRequest: URLRequest,
        responseType: T.Type,
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) {
        Logger.info("Making network request to: \(urlRequest.url?.absoluteString ?? "Unknown URL")", category: .network)
        
        guard isConnected else {
            let error = NSError(domain: "com.aeyes.hk", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
            Logger.error("Network request failed - No connection", category: .network)
            completionHandler(.failure(error))
            return
        }
        
        let startTime = Date()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            let requestDuration = Date().timeIntervalSince(startTime)
            
            if let error = error {
                Logger.error("Network request failed: \(error.localizedDescription)", category: .network)
                completionHandler(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "com.aeyes.hk", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                Logger.error("Network request failed - Invalid response", category: .network)
                completionHandler(.failure(error))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard (200...299).contains(statusCode) else {
                let error = self.handleHTTPError(data: data, statusCode: statusCode)
                Logger.error("Network request failed with status code: \(statusCode)", category: .network)
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.aeyes.hk", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                Logger.error("Network request failed - No data received", category: .network)
                completionHandler(.failure(error))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                Logger.info("Network request succeeded in \(String(format: "%.2f", requestDuration))s", category: .network)
                completionHandler(.success(decodedResponse))
            } catch {
                Logger.error("Failed to decode response: \(error.localizedDescription)", category: .network)
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func uploadImage(
        url: URL,
        imageData: Data,
        parameters: [String: Any],
        headers: [String: String],
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Add headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let httpBody = NSMutableData()
        
        // Add parameters
        for (key, value) in parameters {
            httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
            httpBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            httpBody.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Add image data
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        httpBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        httpBody.append(imageData)
        httpBody.append("\r\n".data(using: .utf8)!)
        
        // End boundary
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = httpBody as Data
        
        Logger.info("Uploading image to: \(url.absoluteString)", category: .network)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                Logger.error("Image upload failed: \(error.localizedDescription)", category: .network)
                completionHandler(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "com.aeyes.hk", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                Logger.error("Image upload failed - Invalid response", category: .network)
                completionHandler(.failure(error))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard (200...299).contains(statusCode) else {
                let error = self.handleHTTPError(data: data, statusCode: statusCode)
                Logger.error("Image upload failed with status code: \(statusCode)", category: .network)
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.aeyes.hk", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                Logger.error("Image upload failed - No data received", category: .network)
                completionHandler(.failure(error))
                return
            }
            
            Logger.info("Image upload succeeded", category: .network)
            completionHandler(.success(data))
        }
        
        task.resume()
    }
    
    // MARK: - Network Monitoring
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                
                if self.isConnected {
                    self.determineConnectionType(path)
                    Logger.info("Network connected: \(self.connectionType)", category: .network)
                } else {
                    self.connectionType = .unknown
                    Logger.warning("Network disconnected", category: .network)
                    
                    // Post notification for network disconnection
                    NotificationCenter.default.post(name: .networkStatusChanged, object: nil, userInfo: ["connected": false])
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
    private func determineConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
        
        // Post notification for connection type change
        NotificationCenter.default.post(
            name: .networkStatusChanged,
            object: nil,
            userInfo: [
                "connected": true,
                "connectionType": connectionType
            ]
        )
    }
    
    // MARK: - Error Handling
    private func handleHTTPError(data: Data?, statusCode: Int) -> Error {
        // Try to extract error message from response
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            // Check for error message in different formats
            if let errorMessage = json["error"] as? String {
                return NSError(domain: "com.aeyes.hk", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            } else if let errorDict = json["error"] as? [String: Any], let message = errorDict["message"] as? String {
                return NSError(domain: "com.aeyes.hk", code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
            } else if let message = json["message"] as? String {
                return NSError(domain: "com.aeyes.hk", code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
            }
        }
        
        // Default error message based on status code
        let message: String
        switch statusCode {
        case 400:
            message = "Bad request"
        case 401:
            message = "Unauthorized"
        case 403:
            message = "Forbidden"
        case 404:
            message = "Not found"
        case 500...599:
            message = "Server error"
        default:
            message = "HTTP Error: \(statusCode)"
        }
        
        return NSError(domain: "com.aeyes.hk", code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

// MARK: - Notification.Name Extension
extension Notification.Name {
    static let networkStatusChanged = Notification.Name("NetworkStatusChanged")
}