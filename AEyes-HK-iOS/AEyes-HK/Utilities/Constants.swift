import UIKit

struct Constants {
    
    struct Colors {
        static let primaryBlue = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        static let backgroundGray = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        static let textDarkGray = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        static let successGreen = UIColor.systemGreen
        static let errorRed = UIColor.systemRed
    }
    
    struct Text {
        static let appTitle = "AEyes-HK : Accessibility Platform for the Visually Impaired"
        static let appSubtitle = "用相機描述周圍環境 - 為視障人士設計"
        static let takePicture = "影相"
        static let processingPhoto = "處理緊相片，請稍等..."
        static let processingTime = "處理時間: %.2f 秒"
        static let textDescription = "文字"
        static let descriptionLabel = "描述"
        static let audioPlayed = "語音描述已播放 🎙️"
        static let audioError = "無法生成語音"
        static let footerText = "由 xAI 同 AWS 提供技術支援"
        
        // Alert messages
        static let errorTitle = "錯誤"
        static let cameraErrorTitle = "相機錯誤"
        static let cameraAccessError = "無法存取相機"
        static let photoProcessingError = "無法處理相片"
        static let photoCapturingError = "拍照時發生錯誤"
    }
    
    struct Accessibility {
        static let cameraViewLabel = "相機畫面"
        static let cameraViewHint = "顯示相機畫面的視圖"
        static let captureButtonLabel = "拍攝照片"
        static let captureButtonHint = "點擊拍攝照片以獲取描述"
        static let descriptionContainerLabel = "描述詳情"
        static let descriptionContainerHint = "展示照片的詳細描述"
        static let audioStatusLabel = "語音描述狀態"
        static let audioStatusHint = "顯示語音描述的播放狀態"
    }
    
    struct Animation {
        static let standardDuration: TimeInterval = 0.3
        static let buttonPressScale: CGFloat = 0.95
    }
    
    struct API {
        static let xAIBaseURL = "https://api.x.ai/v1"
        static let awsRegion = "us-east-1"
    }
}