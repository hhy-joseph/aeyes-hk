import UIKit
import AVFoundation

// MARK: - UIView Extensions
extension UIView {
    /// Add rounded corners to view
    func roundCorners(radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    /// Add shadow to view
    func addShadow(
        color: UIColor = .black,
        offset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 4,
        opacity: Float = 0.1
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
    
    /// Add button press animation
    func addPressAnimation() {
        UIView.animate(withDuration: Constants.Animation.standardDuration, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: Constants.Animation.buttonPressScale, y: Constants.Animation.buttonPressScale)
        }) { _ in
            UIView.animate(withDuration: Constants.Animation.standardDuration) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
    
    /// Add accessibility traits for vision-impaired users
    func configureForAccessibility(label: String, hint: String, traits: UIAccessibilityTraits = .none) {
        self.isAccessibilityElement = true
        self.accessibilityLabel = label
        self.accessibilityHint = hint
        self.accessibilityTraits = traits
    }
}

// MARK: - UIImage Extensions
extension UIImage {
    /// Resize image while maintaining aspect ratio
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    /// Compress image to target size in KB
    func compressed(quality: CGFloat = 0.7) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }
}

// MARK: - String Extensions
extension String {
    /// Check if string contains Cantonese characters
    var containsCantonese: Bool {
        // Check for traditional Chinese character range (primarily used in Hong Kong)
        let pattern = "[\u{4E00}-\u{9FFF}\u{3400}-\u{4DBF}]"
        return self.range(of: pattern, options: .regularExpression) != nil
    }
    
    /// Localized string convenience method
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

// MARK: - UIViewController Extensions
extension UIViewController {
    /// Show loading indicator
    func showLoading(message: String? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        
        alertController.view.addSubview(loadingIndicator)
        present(alertController, animated: true, completion: nil)
    }
    
    /// Hide loading indicator
    func hideLoading() {
        if let alertController = self.presentedViewController as? UIAlertController {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    /// Present error alert
    func presentError(_ error: Error, title: String = "錯誤", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - AVCaptureDevice Extensions
extension AVCaptureDevice {
    /// Request camera access with completion handler
    static func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}

// MARK: - Date Extensions
extension Date {
    /// Format date as string
    func formatted(with format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}