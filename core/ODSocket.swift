//
//  ODSocket.swift
//  app
//
//  Created by Admin on 02/09/21.
//

import UIKit
import Foundation
import Alamofire
import SwiftPhoenixClient
import Starscream

class ODSocket: NSObject, SocketConnectionCallBack {
    
    
    
    private var odChannel: Channel?
    var odSocket: Socket?
    static let shared = ODSocket()
    
    private var socketConfigure: SocketConfigure {
        SocketConfigure.shared
    }
    private var dalCapture: DALCapture {
        DALCapture.shared
    }
    private var msSocket: MSSocket {
        MSSocket.shared
    }
    
    var artifact_key: String = "";
    
    func createSession(token: String, publicId: String, sessionToken: String) {
        
        let url: String = "wss://capture.kyc.idfystaging.com/video-kyc-backend/socket/task/websocket?" +
            "t=" + token +
            "&public_id=" + publicId +
            "&session_token=" + sessionToken;
        print(url)
        socketConfigure.delegate = self
        socketConfigure.initialise(webSocketUrl: url)
        socketConfigure.setUpSocket()
    }
    func initSocket(socket: Socket) {
        odSocket = socket
        socketConfigure.setupChannel(socket: socket, topic: "session:" + dalCapture.session_token, payload:[:])
    }
    
    func initChannel(channel: Channel) {
        odChannel = channel
        if odChannel != nil {
            joinChannel()
        }
    }
    
    func onSocketError(message: String) {
        
    }
    func joinChannel() {
        let obj: [String:String] = ["user_agent":"Abhi", "capture_session_id":dalCapture.sessionId]
        do {
            self.odChannel = odSocket?.channel("session:" + dalCapture.public_id,  params:obj)
            odChannel?.join()
                .receive("error") {message in
                    print("Channel error: ",message)
                    print("Payload: \(message.payload)")
                    
                }
                .receive("ok") {message in
                    print("socket channel joined: ",message.payload)
                }
            odChannel?.on("fetch_task_data") { message in
                print("socket channel fetch_task_data: ",message.payload)
                self.sendTaskDataPayload()
                
            }
            odChannel?.on("waiting_status") { message in
                print("check")
                print("socket channel waiting_status: ",message.payload)
                let agents_available = message.payload["agents_available"] as! Int;
//                let people_in_queue = message.payload["people_in_queue"];
                if agents_available == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        NotificationCenter.default.post(name: DALCapture.didOpenDisconnectViewRequest , object: link)
                    }
                }
            }
            
            odChannel?.on("connected") { message in
                print("socket channel connected: ",message.payload)
                
                let room_id = message.payload["room_sid"];
                let participant_id = message.payload["user_sid"];
                
                print(room_id as? String ?? "")
                print(participant_id as? String ?? "")
                
                self.msSocket.initialise(participantID: participant_id as! String, roomID: room_id as! String)
                self.msSocket.setupSocket()
            }
            odChannel?.on("_disconnect") { message in
                print("check")
                print("socket agent call disconnect: ",message.payload)
                let agentStatus = message.payload["code"];
                if agentStatus as! String == "agent_not_available" {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        NotificationCenter.default.post(name: DALCapture.didOpenDisconnectViewRequest, object: link)
                    }
                }
               
            }
            odChannel?.on("screenshot") { message in
                print("socket channel connected: ",message.payload)

                self.artifact_key = message.payload["artifact_key"] as! String;
                var link:String = message.payload["link"] as! String;

                print(self.artifact_key)
                print(link)

                if !self.artifact_key.isEmpty {

                    link = link+"&t="+self.dalCapture.token+"%2F"+self.dalCapture.sessionId+"&auth_service=pg&type=session";
                    print("New upload Link: \(link)")
                    self.sendScreenShotStatus(status:"screenshot_initiated")
                    self.sendScreenShotStatus(status:"screenshot_captured")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        NotificationCenter.default.post(name: DALCapture.didSendScreenShotRequest , object: link)
                    }

                }
            }
            
        }
    }
    func sendTaskDataPayload() {
//        guard let location = LocationManager.sharedInstance.currentLocation else {return}
//        let dataArr:Payload =  ["timestamp":"\(currentDate())","speed":"\(location.speed)","longitude":"\(location.coordinate.longitude)","latitude":"\(location.coordinate.latitude)","accuracy":"\(location.speedAccuracy)","heading":"","altitude":"\(location.altitude)","altitudeAccuracy":"\(location.horizontalAccuracy)"]
        let dataArr:Payload = ["timestamp":"2021-08-19T12:07:41.444Z","speed":"","longitude":"73.0897722","latitude":"19.025340099999998","accuracy":"77","heading":"","altitude":"","altitudeAccuracy":""]

        let payload:NSObject = ["attr":"location","data" : dataArr as NSObject] as NSObject
        
        print("\nSending task_data, payload : \([payload])")
        
        self.odChannel?.push("task_data", payload: ["payload":[payload]], timeout: 30)
            
            .receive("ok") { payload in print("channel push resp: ", payload.payload) }
            
            .receive("error") { payload in print("channel push failed", payload.payload) }
            
            .receive("timeout") { payload in print("channel push timeout", payload.payload) }
        
    }
    func sendScreenShotStatus(status:String) {
        
//        odChannel?.push(status, payload: ["event":self.artifact_key], timeout: 30)
        
//        odChannel?.push(status, payload: ["event":self.artifact_key], timeout: 30)
        
        odChannel?.push(status, payload: ["event":self.artifact_key], timeout: 30)
            
            .receive("ok") { payload in print("channel push resp: ", payload.payload) }
            
            .receive("error") { payload in print("channel push failed", payload.payload) }
            
            .receive("timeout") { payload in print("channel push timeout", payload.payload) }
    }
    func sendNoAudio_Video(message:String) {
        
        odChannel?.push("chat", payload: ["message":message], timeout: 30)
            
            .receive("ok") { payload in print("Chat message push ok:", payload.payload) }
            
            .receive("error") { payload in print("Chat message push failed", payload.payload) }
            
            .receive("timeout") { payload in print("Chat message push timeout", payload.payload) }
    }
    func sendCallDisconnectionStatus() {
        
        odChannel?.push("end_call", payload: ["code":"user_ended_call","reason":"user ended call","manual":"true"], timeout: 30)
            
            .receive("ok") { payload in print("End call push ok:", payload.payload) }
            
            .receive("error") { payload in print("End call push failed", payload.payload) }
            
            .receive("timeout") { payload in print("End call push timeout", payload.payload) }
    }
}

