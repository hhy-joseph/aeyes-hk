import Foundation
import AWSCore
import AWSPolly

class AudioSynthesisService {
    private let pollyClient: AWSPolly
    
    init() {
        // Configure AWS Credentials
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: APIKeys.awsAccessKey, secretKey: APIKeys.awsSecretKey)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // Initialize Polly client
        pollyClient = AWSPolly.default()
    }
    
    func generateAudio(from text: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let input = AWSPollyVoiceRequest()
        input.text = text
        input.outputFormat = .mp3
        input.voiceId = .hiujin
        input.engine = .neural
        input.languageCode = AWSPollyLanguageCode.cmn_CN // Cantonese is actually yue_CN but using cmn_CN since Hiujin supports it
        
        pollyClient.synthesizeSpeech(input) { (task) in
            task.continue({ (task) -> AnyObject? in
                if let error = task.error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return nil
                }
                
                guard let result = task.result as? AWSPollySynthesizeSpeechOutput,
                      let audioData = result.audioStream else {
                    DispatchQueue.main.async {
                        completion(.failure(AppError.audioGenerationFailed))
                    }
                    return nil
                }
                
                DispatchQueue.main.async {
                    completion(.success(audioData))
                }
                
                return nil
            })
        }
    }
}