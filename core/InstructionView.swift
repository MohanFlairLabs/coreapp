//
//  InstructionView.swift
//  app
//
//  Created by Admin on 06/09/21.
//

import UIKit
enum RetryOptions {
    case SessionContinue
    case SessionOverride
}
protocol InstructionActionDelegate {
    func didSetRetryButton(screen: RetryOptions)
}
class InstructionView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var messageHeader: UILabel!
    @IBOutlet weak var messageInfo: UILabel!
    @IBOutlet weak var informationOne: UILabel!
    @IBOutlet weak var informationTwo: UILabel!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var backgroundInfoViewOne: UIView!
    @IBOutlet weak var backgroundInfoViewTwo: UIView!
    @IBOutlet weak var backgroundInfoViewThree: UIView!
    
    var delegate: InstructionActionDelegate?
    
    let kCONTENT_XIB_NAME           =   "InstructionView"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        
    }
    func loadNetworkCheckInfoView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.image = UIImage(named: "network")
        self.imageView.addSubview(imageView)
        self.messageHeader.text = "Please Wait..."
        self.messageInfo.text = "We're checking your network connection. This won't take long."
        self.informationOne.text = "1.Do NOT press back or leave this window"
        self.informationTwo.text = "2.Do Not let your screen sleep Doing so will remove you from the queue"
        btnRetry.isHidden = true
        self.informationOne.isHidden = false
        self.informationTwo.isHidden = false
    }
    func loadConnectingToAgentView() {
        self.imageView.removeSubviews()
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.frame = self.imageView.bounds
        spinner.color = .white
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        self.imageView.addSubview(spinner)
        self.messageHeader.text = "You will be connected to the Representative shortly"
        self.messageInfo.text = "Please wait on this screen while the representative accepts your call"
        self.informationOne.text = "1.Do NOT press back or leave this window"
        self.informationTwo.text = "2.Do Not let your screen sleep Doing so will remove you from the queue"
        self.btnRetry.isHidden = true
        self.informationOne.isHidden = false
        self.informationTwo.isHidden = false
    }
    func loadReconnectingView() {
        self.imageView.removeSubviews()
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.frame = self.imageView.bounds
        spinner.color = .white
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        self.imageView.addSubview(spinner)
        self.messageHeader.text = "Reconnecting..."
        self.messageInfo.text = "Please do not refresh or press the back button"
        self.informationOne.isHidden = true
        self.informationTwo.isHidden = true
        backgroundInfoViewThree.isHidden = true
        self.btnRetry.isHidden = true
    }
    func loadAgentNotAvailableView() {
        contentView.backgroundColor = .black
        contentView.alpha = 1.0
        self.imageView.removeSubviews()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        imageView.image = UIImage(named: "AppLogo")
        self.imageView.addSubview(imageView)
        self.messageHeader.text = "Representative is Currently Unavailable"
        self.messageInfo.text = "Please try again after some time"
        self.informationOne.isHidden = true
        self.informationTwo.isHidden = true
        btnRetry.isHidden = false
        btnRetry.tag = 0
        backgroundInfoViewThree.isHidden = true
        btnRetry.backgroundColor = hexStringToUIColor(hex: "#4a599b")
        
    }
    func loadNetworkDisconnectedStatusView() {
        contentView.backgroundColor = hexStringToUIColor(hex: "#303030") 
        contentView.alpha = 1.0
        self.imageView.removeSubviews()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        if let myImage = UIImage(named: "NetworkDisconnected") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            imageView.image = tintableImage
        }
        imageView.tintColor = .red
        self.imageView.addSubview(imageView)
        self.messageHeader.text = "Network Disconnected"
        self.messageInfo.text = "Please ensure you are connected to a good network, and click RETRY"
        self.informationOne.isHidden = true
        self.informationTwo.isHidden = true
        btnRetry.isHidden = false
        btnRetry.tag = 1
        backgroundInfoViewOne.backgroundColor = .none
        backgroundInfoViewTwo.backgroundColor = .none
        backgroundInfoViewThree.isHidden = true
        btnRetry.backgroundColor = hexStringToUIColor(hex: "#4a599b")
        
    }
    
    func loadKycCompletedStatusView() {
        contentView.backgroundColor = .black
        contentView.alpha = 1.0
        self.imageView.removeSubviews()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        imageView.image = UIImage(named: "AppLogo")
        self.imageView.addSubview(imageView)
        self.messageHeader.text = "Thank You"
        self.messageInfo.text = ""
        self.informationOne.isHidden = true
        self.informationTwo.isHidden = true
        btnRetry.isHidden = true
        backgroundInfoViewThree.isHidden = true
        btnRetry.backgroundColor = hexStringToUIColor(hex: "#4a599b")
        
    }
    @IBAction func didTapButton(_ sender: UIButton) {
        if btnRetry.tag == 0 {
            self.delegate?.didSetRetryButton(screen: .SessionContinue)
        } else {
            self.delegate?.didSetRetryButton(screen: .SessionOverride)
        }
    }
}
