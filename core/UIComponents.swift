//
//  UIComponents.swift
//  app
//
//  Created by Admin on 27/08/21.
//

import Foundation
import UIKit

class UIComponents: NSObject {
    
    func getTextView(text:String,model:TextViewModel) -> UIView {
        let textField = UITextField()
        textField.text = text
        textField.backgroundColor = model.backgroundColor
        textField.textColor = model.textColor
        textField.borderStyle = .line
        let view = UIView()
        view.addSubview(textField)
        return view
        
    }
    
    func getImageView(image:UIImage) -> UIImageView {
        var bgImage = UIImageView()
        let images: UIImage = image
        bgImage = UIImageView(image: images)
        return bgImage
    }
    
    
}
public func generateConstraintsLogo(imageView: UIImageView, view: UIView) -> [NSLayoutConstraint] {
    let constraintTop = NSLayoutConstraint(item: imageView,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: view,
                                           attribute: .top,
                                           multiplier: 1.0,
                                           constant: 28.0)
    let constraintX = NSLayoutConstraint(item: imageView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: imageView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0.0)
    let constraintWidth = NSLayoutConstraint(item: imageView,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: 40)
    let constraintLeft = NSLayoutConstraint(item: imageView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: 10.0)
    let constraintHeight = NSLayoutConstraint(item: imageView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 40)
    
    return [constraintTop, constraintX, constraintWidth, constraintHeight, constraintLeft]
}
public func generateConstraintsTitle(label: UILabel, view: UIImageView, mainView: UIView) -> [NSLayoutConstraint] {
    
    let constraintY = NSLayoutConstraint(item: label,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: mainView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0.0)
    let constraintRight = NSLayoutConstraint(item: label,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: mainView,
                                             attribute: .trailing,
                                             multiplier: 1.0,
                                             constant: -20.0)
    let constraintLeft = NSLayoutConstraint(item: label,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .trailing,
                                            multiplier: 1.0,
                                            constant: 20.0)
    let constraintHeight = NSLayoutConstraint(item: label,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 60)
    
    return [constraintY, constraintHeight, constraintRight, constraintLeft]
}
public func generateConstraintsCardView(cardView: UIView, mainView: UIView) -> [NSLayoutConstraint] {
    let constraintTop = NSLayoutConstraint(item: cardView,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: mainView,
                                           attribute: .top,
                                           multiplier: 1.0,
                                           constant: 80)
    let constraintRight = NSLayoutConstraint(item: cardView,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: mainView,
                                             attribute: .trailing,
                                             multiplier: 1.0,
                                             constant: -20.0)
    let constraintLeft = NSLayoutConstraint(item: cardView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: mainView,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: 20.0)
    let constraintHeight = NSLayoutConstraint(item: cardView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 150)
    
    return [constraintTop, constraintHeight, constraintRight, constraintLeft]
}
public func generateConstraintsInviteButton(buttonView:UIButton, mainView: UIView) -> [NSLayoutConstraint] {
    
    let constraintRight = NSLayoutConstraint(item: buttonView,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: mainView,
                                             attribute: .trailing,
                                             multiplier: 1.0,
                                             constant: -40.0)
    let constraintLeft = NSLayoutConstraint(item: buttonView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: mainView,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: 40.0)
    let constraintHeight = NSLayoutConstraint(item: buttonView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 40)
    let constraintBottom = NSLayoutConstraint(item: buttonView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: mainView,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: -80)
    
    return [constraintHeight, constraintRight, constraintLeft, constraintBottom]
}
public func generateConstraintsCardButton(buttonView:UIButton, mainView: UIView) -> [NSLayoutConstraint] {
    
    let constraintRight = NSLayoutConstraint(item: buttonView,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: mainView,
                                             attribute: .trailing,
                                             multiplier: 1.0,
                                             constant: -40.0)
    let constraintLeft = NSLayoutConstraint(item: buttonView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: mainView,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: 40.0)
    let constraintHeight = NSLayoutConstraint(item: buttonView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 40)
    let constraintBottom = NSLayoutConstraint(item: buttonView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: mainView,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: -30)
    
    return [constraintHeight, constraintRight, constraintLeft, constraintBottom]
}
public func generateConstraintsCardViewLabel(labelView:UILabel, mainView: UIView) -> [NSLayoutConstraint] {
    
    let constraintRight = NSLayoutConstraint(item: labelView,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: mainView,
                                             attribute: .trailing,
                                             multiplier: 1.0,
                                             constant: -40.0)
    let constraintLeft = NSLayoutConstraint(item: labelView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: mainView,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: 40.0)
    let constraintHeight = NSLayoutConstraint(item: labelView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 40)
    let constraintBottom = NSLayoutConstraint(item: labelView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: mainView,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: 30)
    
    return [constraintHeight, constraintRight, constraintLeft, constraintBottom]
}

public func generateConstraintsStatePageTitle(label: UILabel,mainView: UIView) -> [NSLayoutConstraint] {
    let constraintTop = NSLayoutConstraint(item: label,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: mainView,
                                           attribute: .top,
                                           multiplier: 1.0,
                                           constant: 100)
    let constraintRight = NSLayoutConstraint(item: label,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: mainView,
                                             attribute: .trailing,
                                             multiplier: 1.0,
                                             constant: -20.0)
    let constraintLeft = NSLayoutConstraint(item: label,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: mainView,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: 20.0)
    let constraintHeight = NSLayoutConstraint(item: label,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 60)
    
    return [constraintTop, constraintHeight, constraintRight, constraintLeft]
}
public func generateConstraintsStatePageSubTitle(label: UILabel,mainView: UIView) -> [NSLayoutConstraint] {
    let constraintTop = NSLayoutConstraint(item: label,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: mainView,
                                           attribute: .top,
                                           multiplier: 1.0,
                                           constant: 140.0)
    let constraintRight = NSLayoutConstraint(item: label,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: mainView,
                                             attribute: .trailing,
                                             multiplier: 1.0,
                                             constant: -20.0)
    let constraintLeft = NSLayoutConstraint(item: label,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: mainView,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: 20.0)
    let constraintHeight = NSLayoutConstraint(item: label,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 60)
    
    return [constraintTop, constraintHeight, constraintRight, constraintLeft]
}
public func generateConstraintsTableView(label: UITableView,mainView: UIView) -> [NSLayoutConstraint] {
    let constraintTop = NSLayoutConstraint(item: label,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: mainView,
                                           attribute: .top,
                                           multiplier: 1.0,
                                           constant: 190.0)
    let constraintRight = NSLayoutConstraint(item: label,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: mainView,
                                             attribute: .trailing,
                                             multiplier: 1.0,
                                             constant: -20.0)
    let constraintLeft = NSLayoutConstraint(item: label,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: mainView,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: 20.0)
    let constraintHeight = NSLayoutConstraint(item: label,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 500)
    
    return [constraintTop, constraintHeight, constraintRight, constraintLeft]
}
public func generateConstraintsCardViewforNetworkCheck(cardView: UIView, mainView: UIView) -> [NSLayoutConstraint] {
    let constraintTop = NSLayoutConstraint(item: cardView,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: mainView,
                                           attribute: .top,
                                           multiplier: 1.0,
                                           constant: 190.0)
    let constraintX = NSLayoutConstraint(item: cardView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: mainView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0.0)
    
    let constraintRight = NSLayoutConstraint(item: cardView,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: mainView,
                                             attribute: .trailing,
                                             multiplier: 1.0,
                                             constant: -20.0)
    let constraintLeft = NSLayoutConstraint(item: cardView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: mainView,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: 20.0)
    let constraintHeight = NSLayoutConstraint(item: cardView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 150)
    //    let constraintTop = NSLayoutConstraint(item: cardView,
    //                                             attribute: .top,
    //                                             relatedBy: .equal,
    //                                             toItem: mainView,
    //                                             attribute: .bottom,
    //                                             multiplier: 1.0,
    //                                             constant: (mainView.frame.size.height / 5) + 20)
    
    return [constraintTop, constraintX, constraintHeight, constraintRight, constraintLeft]
}
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
extension UIView {
    open func setCornerBorder(color: UIColor? = nil, cornerRadius: CGFloat = 15.0, borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color != nil ? color!.cgColor : UIColor.clear.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    open func setAsShadow(bounds: CGRect, cornerRadius: CGFloat = 0.0, shadowRadius: CGFloat = 1) {
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
    }
    public func removeSubviews() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
extension UIImageView {
    
    class ImageStore: NSObject {
        static let imageCache = NSCache<NSString, UIImage>()
    }
    func SetLogoImage(_ url: String?) {
        DispatchQueue.global().async { [weak self] in
            guard let stringURL = url, let url = URL(string: stringURL) else { return }
            func setImage(image:UIImage?) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
            let companyLogo = url.absoluteString as NSString
            if let cachedImage = ImageStore.imageCache.object(forKey: companyLogo) {
                setImage(image: cachedImage)
            } else if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageStore.imageCache.setObject(image, forKey: companyLogo)
                    setImage(image: image)
                }
            } else {
                setImage(image: nil)
            }
        }
    }
}
struct TextViewModel {
    var backgroundColor: UIColor
    var textColor: UIColor
    var borderColor: UIColor
}
struct CardViewModel {
    var backgroundColor: UIColor
    var shadowColor: UIColor
    var borderColor: UIColor
    var cornerRadius: Int
    var shadowOffset: UIColor
}
