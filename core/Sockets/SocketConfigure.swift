//
//  SocketConfigure.swift
//  app
//
//  Created by Admin on 25/08/21.
//

import UIKit
import Foundation
import Alamofire
import SwiftPhoenixClient
import Starscream
protocol SocketConnectionCallBack: AnyObject {
    func initSocket(socket:Socket)
    func initChannel(channel:Channel)
    func onSocketError(message:String)
}

class SocketConfigure: NSObject {
    
    static let shared = SocketConfigure()

    private var webSocketUrl: String = "";
    private var channel: Channel?
    var socket : Socket?
    
    var delegate: SocketConnectionCallBack?
    
    func initialise(webSocketUrl: String) {
        self.webSocketUrl = webSocketUrl
        
    }
    
    public func setUpSocket() {
            let socket = Socket(endPoint: webSocketUrl, transport: { url in return StarscreamTransport(url: url) })
        socket.timeout = 60.0
        socket.heartbeatInterval = 10.0
            socket.onError { error in
                print("socket connection error: ", error)
                self.delegate?.onSocketError(message: "Socket Connection Error")
            }
            socket.onClose {
                print("socket connection closed")
                self.delegate?.onSocketError(message: "Socket Connection Error")
            }
            socket.onOpen {
                print("socket connection: opened")
            }
        
            socket.connect()
        self.delegate?.initSocket(socket: socket)
    }
    func setupChannel(socket:Socket,topic:String,payload: Payload) {
        channel = socket.channel(topic, params: payload)
        if channel != nil {
            self.delegate?.initChannel(channel: channel!)
        }
    }
    
}
