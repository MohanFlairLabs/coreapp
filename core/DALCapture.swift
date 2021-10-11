//
//  DALCapture.swift
//  app
//
//  Created by Admin on 24/08/21.
//

import UIKit
import Foundation
import Alamofire
import SwiftPhoenixClient
import Starscream
protocol SessionCallBack: AnyObject {
    func onSessionSuccess(object:NSObject?)
    func intermediateCallback(object:NSObject)
    func failureCallback(message:String)
}
protocol SessionTokenDelegate {
    func sessionTokenOnSuccess()
}
protocol CaptureComponentCallBack {
    func renderToolBar()
    func getPageData()
    func renderSecondaryUI(fontColor:UIColor,status:String)
}
enum Status: String {
    case Status_Capture_Pending = "capture_pending"
    case Status_Recapture_Pending = "recapture_pending"
    case Status_Review = "review"
    case Status_Failed = "failed"
    case Status_Initiated = "initiated"
    case Status_In_Progress = "in_progress"
    case Status_Review_Required = "review_required"
    case Status_Rejected = "rejected"
    case Status_Approved = "approved"
    case Status_Cancelled = "cancelled"
    case Status_Processed = "processed"
    case Status_Capture_Expired = "capture_expired"
}
enum StatusType: String {
    case Status_Success = "success"
    case Status_Failed = "failed"
    case Status_Pending = "pending"
}
class DALCapture: NSObject, SocketConnectionCallBack {
    
    var token: String = "";
    var captureId: String = "";
    var sessionId: String = "";
    var public_id: String = "";
    var session_token: String = "";
    var networkCheckId: String = "";
    var participantId: String = "";
    var requestId:String = "";
    var roomId: String = "";
    var msRoomId:String = "";
    var listPageSeq = [PageSequence]()
    var pageIndex:Int = 0;
    
    var primaryMainColor: String = "";
    var primaryContrastColor: String = "";
    var secondaryMainColor: String = "";
    var secondaryContrastColor: String = "";
    var masterBackgroundColor: UIColor?
    var backgroundColor: String? = "";
    var applicationLogo: String = "";
    var applicationColor: String = "";
    var headerTitle:String? = "";
    
    var isRoomJoinNeeded:Bool = false;
    private var captureChannel: Channel?
    var captureSocket: Socket?
    
    static let shared = DALCapture()
    
    private var socketConfigure: SocketConfigure {
        SocketConfigure.shared
    }
    var isHealthChecked: Bool = false
    
    var statsViewList:[StatsViewData] = []
    
    var delegate:SessionCallBack?
    
    var delegateRender:CaptureComponentCallBack?
    
    var sessionTokenDelegate: SessionTokenDelegate?
    
    
    func getCaptureStatusDetails() {
        
        MainController.getCaptureSocketInfo(controller: UIViewController(), id: token) { [self] data  in
            
            guard let _ = data.value(forKey: "body") as? NSObject else { return ProgressHUD.dismiss() }
            
            if let value = data.value(forKey: "body") as? NSObject {
                captureId = value.value(forKey: "capture_id") as! String
                sessionId = value.value(forKey: "session_id") as! String
                let status = value.value(forKey: "status") as? String
                let headerObject = data.value(forKey: "header") as! NSObject
                headerTitle = headerObject.value(forKey: "title") as? String
                let themeObject = headerObject.value(forKey: "theme_config") as! NSObject
                parseThemeConfig(themeObject: themeObject)
                applicationLogo = headerObject.value(forKey: "logo") as? String ?? ""
                let customHeader = themeObject.value(forKey: "custom_header") as! NSObject
                backgroundColor = customHeader.value(forKey: "backgroundColor") as? String
                applicationColor = customHeader.value(forKey: "color") as? String ?? ""
                delegateRender?.renderToolBar()
                let status_string = Status(rawValue: status ?? "")
                switch status_string {
                case .Status_Approved:
                    statusViewAssign(type: .Status_Success, status: status_string?.rawValue ?? "")
                    break
                case .Status_Cancelled:
                    statusViewAssign(type: .Status_Failed, status: status_string?.rawValue ?? "")
                    break
                case .Status_Capture_Expired:
                    statusViewAssign(type: .Status_Failed, status: status_string?.rawValue ?? "")
                    break
                case .Status_Capture_Pending:
                    delegateRender?.getPageData()
                    break
                case .Status_Failed:
                    statusViewAssign(type: .Status_Failed, status: status_string?.rawValue ?? "")
                    break
                case .Status_Initiated:
                    statusViewAssign(type: .Status_Pending, status: status_string?.rawValue ?? "")
                    break
                case .Status_In_Progress:
                    statusViewAssign(type: .Status_Pending, status: status_string?.rawValue ?? "")
                    break
                case .Status_Processed:
                    statusViewAssign(type: .Status_Success, status: status_string?.rawValue ?? "")
                    break
                case .Status_Recapture_Pending:
                    statusViewAssign(type: .Status_Failed, status: status_string?.rawValue ?? "")
                    break
                case .Status_Rejected:
                    statusViewAssign(type: .Status_Failed, status: status_string?.rawValue ?? "")
                    break
                case .Status_Review:
                    statusViewAssign(type: .Status_Pending, status: status_string?.rawValue ?? "")
                    break
                case .Status_Review_Required:
                    statusViewAssign(type: .Status_Pending, status: status_string?.rawValue ?? "")
                    break
                default:
                    statusViewAssign(type: .Status_Failed, status: status_string?.rawValue ?? "")
                    break
                }
            }
        }
    }
    func statusViewAssign(type:StatusType,status:String) {
        switch type {
        case .Status_Failed:
            delegateRender?.renderSecondaryUI(fontColor: .red, status: status)
            break
        case .Status_Pending:
            delegateRender?.renderSecondaryUI(fontColor: .orange, status: status)
            break
        case .Status_Success:
            delegateRender?.renderSecondaryUI(fontColor: .green, status: status)
            break
        }
    }
    func parseThemeConfig(themeObject: NSObject?) {
        if themeObject != nil {
            let footerObject = themeObject?.value(forKey: "custom_footer") as? NSObject
            var isDisplayFooter:Bool = false
            if footerObject != nil {
                isDisplayFooter = footerObject?.value(forKey: "display") as! Bool
            }
            if isDisplayFooter {
                //                footer_title.isHidden = false
            }
            let paletteObject = themeObject?.value(forKey: "palette") as? NSObject
            if paletteObject != nil {
                let primaryObject = paletteObject?.value(forKey: "secondary") as? NSObject
                if primaryObject != nil {
                    secondaryMainColor = primaryObject?.value(forKey: "main") as? String ?? ""
                    secondaryContrastColor = primaryObject?.value(forKey: "contrastText") as? String ?? ""
                }
                let primaryPaletteObject = paletteObject?.value(forKey: "primary") as? NSObject
                if primaryPaletteObject != nil {
                    primaryMainColor = primaryObject?.value(forKey: "dark") as? String ?? ""
                    secondaryContrastColor = primaryObject?.value(forKey: "contrastText") as? String ?? ""
                }
            }
        }
    }
    func createSession() {
        
        let url: String = "wss://capture.kyc.idfystaging.com/backend/socket/capture/websocket?" +
            "t=" + token + "&capture_id=" + captureId + "&session_token=" + sessionId;
        print(url)
        socketConfigure.delegate = self
        socketConfigure.initialise(webSocketUrl: url)
        socketConfigure.setUpSocket()
    }
    func sessionTokenRequest(requestId:String) {
        self.public_id = requestId
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            MainController.getSessionTokenRequest(controller: UIViewController(), taskId: requestId, token: self.token) { model in
                if let sessionToken = model.value(forKey: "session_token") as? String {
                    self.session_token = sessionToken
                    if self.session_token != "" {
                        self.sessionTokenDelegate?.sessionTokenOnSuccess()
                    }
                } else {
                    print("Error response")
                }
            }
        }
    }
    func fetchPageConfig(event:String, jsonObject: NSObject, completion:@escaping(_ onSessionSuccess: NSObject?,_ intermediateCallBack: NSObject,_ _onSessionFailure: String  ) -> Void) {
        do {
            captureChannel?.push(event, payload: jsonObject as! Payload).receive("ok", callback: { message in
                completion(message.payload as NSObject,message.payload as NSObject,"")
            })
        }
    }
    func initSocket(socket: Socket) {
        captureSocket = socket
        socketConfigure.setupChannel(socket: socket, topic: "session:" + captureId, payload:[:])
    }
    
    func initChannel(channel: Channel) {
        captureChannel = channel
        if captureChannel != nil {
            joinChannel()
        }
    }
    
    func onSocketError(message: String) {
        print("On Session Failure")
    }
    func joinChannel() {
        
        do {
            captureChannel?.join()
                .receive("error") {message in
                    print("Channel error: ",message)
                    print("Payload: \(message.payload)")
                    self.delegate?.failureCallback(message: "Channel Error")
                }
                .receive("ok") {message in
                    print("socket channel joined: ",message.payload)
                    let result = message.payload["response"] as! NSDictionary
                    let jsonObject = result as NSObject
                    self.delegate?.onSessionSuccess(object: jsonObject as NSObject)
                }
            captureChannel?.on("_disconnect") { message in
                print("socket channel Disconnected: ",message.payload)
                let result = message.payload["code"] as! String
                if result == "SESSION_OVERRIDE" {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        NotificationCenter.default.post(name: DALCapture.didOpenNetworkDisconnectRequest, object: link)
                    }
                }
            }
        }
    }
}
extension DALCapture {
    static let didSendScreenShotRequest = Notification.Name("kDidSendScreenShotRequest")
    static let didOpenDisconnectViewRequest = Notification.Name("kdidOpenDisconnectViewRequest")
    static let didSendReconnectingRequest = Notification.Name("kDidSendReconnectingRequest")
    static let didUpdateStatsUI = Notification.Name("kdidUpdateStatsUI")
    static let didOpenNetworkDisconnectRequest = Notification.Name("kdidOpenNetworkDisconnectRequest")
}
