//
//  Extension.swift
//  app
//
//  Created by Admin on 11/09/21.
//

import Foundation
import UIKit

extension UIApplication {
    
    func getTopViewController() -> UIViewController {
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return UIViewController()
    }
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
extension Encodable {

  var dictionary: Any? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 }
  }

}
func currentDate() -> String {
   let dateFormatterGet = DateFormatter()
   dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
   let myString = dateFormatterGet.string(from: Date())
   return myString
}
extension Dictionary {
  func contains(key: Key) -> Bool {
    self.index(forKey: key) != nil
  }
}
func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}
extension UIViewController {
    func showAlert(title: String, message: String?, actionTitle: String , completion:@escaping (_ success: Bool?) -> Void) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: {action in
            completion(true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlert(title: String, message: String?, actionTitle1: String?, actionTitle2: String? , completion:@escaping (_ success: Bool?) -> Void) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle1, style: .destructive, handler: { action in
             completion(true)
         }))
        alertController.addAction(UIAlertAction(title: actionTitle2, style: .default, handler: {_ in }))
      
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlertonNoInternet(title: String = "No Internet Connection.", message: String = "Your data connection appears to be weak or unavailable. Please check that you have a data connection and try again.") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Settings", style: .cancel) { (action:UIAlertAction) in
            print("Go to Settings Page");
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {  return }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        let action2 = UIAlertAction(title: "Close", style: .default) { (action:UIAlertAction) in
            print("You've pressed Cancel");
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    func getSignalStrength()->Int{
            var result : Int = 0
            let libHandle = dlopen ("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_NOW)
            let CTGetSignalStrength2 = dlsym(libHandle, "CTGetSignalStrength")

            typealias CFunction = @convention(c) () -> Int

            if (CTGetSignalStrength2 != nil) {
                let fun = unsafeBitCast(CTGetSignalStrength2!, to: CFunction.self)
                result = fun()
                return result;
            }
         return -1
     }
}
extension String {
    fileprivate func indentingNewlines(by spaceCount: Int = 4) -> String {
        let spaces = String(repeating: " ", count: spaceCount)
        return replacingOccurrences(of: "\n", with: "\n\(spaces)")
    }
    func startcased() -> String {
            components(separatedBy: " ")
                .map { $0.prefix(1).uppercased() + $0.dropFirst() }
                .joined(separator: " ")
        }
    
}
extension Encodable {
    
    //Use this variables to enocde the codable model into JSON type.
    ///(e.g) If you want to send the dictionary or array to the server, If you use codable you can use these to acheive.
    
    var encodeArray: [[String: Any]]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [[String: Any]] }
    }
    
    
    var encodeDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
extension UIApplication {

    func getKeyWindow() -> UIWindow? {
        if #available(iOS 13, *) {
            return windows.first { $0.isKeyWindow }
        } else {
            return keyWindow
        }
    }

    func makeSnapshot() -> UIImage? { return getKeyWindow()?.layer.makeSnapshot() }
}


extension CALayer {
    func makeSnapshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
}

extension UIView {
    func makeSnapshot() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
        } else {
            return layer.makeSnapshot()
        }
    }
}

extension UIImage {
    convenience init?(snapshotOf view: UIView) {
        guard let image = view.makeSnapshot(), let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        return allowed
    }()
}
