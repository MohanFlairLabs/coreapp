//
//  MSSocket.swift
//  app
//
//  Created by Admin on 02/09/21.
//

import UIKit
import Foundation
import Alamofire
import SwiftPhoenixClient
import Starscream

class MSSocket: NSObject, SocketConnectionCallBack {
    
    var msChannel: Channel?
    var msSocket: Socket?
    static let shared = MSSocket()
    
    static let startEstablishingConnection = Notification.Name("kStartEstablishingConnection")
    
    private var roomId: String = "";
    
    var participantID: String = "";
    
    private var socketConfigure: SocketConfigure {
        SocketConfigure.shared
    }
    private var dalCapture: DALCapture {
        DALCapture.shared
    }
    func initialise(participantID: String, roomID:String) {
        self.roomId = roomID
        self.participantID = participantID
    }
    func setupSocket() {
        let url: String = "wss://ms.idfystaging.com/controller/socket/websocket?participant_id="+participantID
        print(url)
        socketConfigure.delegate = self
        socketConfigure.initialise(webSocketUrl: url)
        socketConfigure.setUpSocket()
    }
    func initSocket(socket: Socket) {
        msSocket = socket
        socketConfigure.setupChannel(socket: socket, topic: "room:" + self.roomId, payload:[:])
    }
    
    func initChannel(channel: Channel) {
        msChannel = channel
        if msChannel != nil {
            joinChannel()
        }
    }
    
    func onSocketError(message: String) {
        
    }
    func joinChannel() {
        
        do {
            msChannel?.join()
                .receive("error") {message in
                    print("Channel error: ",message)
                    print("Payload: \(message.payload)")
                    
                }
                .receive("ok") {message in
                    print("socket channel joined: ",message.payload)
                }
            msChannel?.on("start") { [self] message in
                print("socket channel start: ",message.payload)
                let jsonMessage = message.payload as NSObject
                let instance = jsonMessage.value(forKey: "instance") as? NSObject
                UserDefaults.hostUrl = instance?.value(forKey: "link") as? String
                let providerName = instance?.value(forKey: "provider_name") as? String
                UserDefaults.roomId = message.payload["ms_room_reference_id"] as? String;
                dalCapture.msRoomId = String(message.payload["ms_room_id"] as! Int);
                let participants = jsonMessage.value(forKey: "participants") as? [NSObject]
                if let element = participants?.first {
                    UserDefaults.streamReferenceId = ""
                    let tempId = element.value(forKey: "participant_id") as? String
                    if self.participantID == tempId {
                        let data = element.value(forKey: "data") as? NSObject
                        UserDefaults.streamReferenceId = data?.value(forKey: "stream_reference_id") as? String
                    }
                }
                
                print("Stream reference Id : \(UserDefaults.streamReferenceId ?? "")")
                print("Janus Link : \(UserDefaults.hostUrl ?? "")")
                print("Janus Room ID: \(UserDefaults.roomId ?? "")")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: MSSocket.startEstablishingConnection , object: providerName)
                }
            }
            msChannel?.on("reconnecting") { message in
                print("MS Channel socket channel reconnecting: ",message.payload)
                let participant_id = message.payload["participant_id"] as? String
                if participant_id == self.participantID {
                    return
                }
                self.participantID = participant_id ?? ""
                self.msSocket?.disconnect()
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: DALCapture.didSendReconnectingRequest , object: nil)
                }
                self.setupSocket()
            }
        }
    }
    
    func sendStatsDataPayload(stats: NSObject) {
        self.msChannel?.push("webrtc_stats", payload: ["data":stats])
        DispatchQueue.main.asyncAfter(deadline: .now()) {
        NotificationCenter.default.post(name: DALCapture.didUpdateStatsUI, object: stats)
        }
    }
    
}
