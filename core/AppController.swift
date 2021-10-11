//
//  AppController.swift
//  app
//
//  Created by Admin on 18/08/21.
//

import Foundation
import UIKit
import Alamofire

class MainController {
    
    static var baseURL: String {
        
        return "https://capture.kyc.idfystaging.com/"
        
    }
    
    class func getSessionTokenRequest(controller: UIViewController, taskId:String, token: String,completion:@escaping(_ success: NSObject) -> Void) {
        if !Connectivity.isConnectedToInternet() { controller.showAlertonNoInternet(); return }
        let url = "\(self.baseURL)video-kyc-backend/token?task_id=\(taskId)&t=\(token)"
        let header: HTTPHeaders?  = [
            "Authorization" : "",
            "Content-Type": "",
            
        ]
        APIHandler.getRequest(url: url, header: header) { datObject  in
            if let data = datObject {
                completion(data)
            }
        }
    }
    class func getCaptureSocketInfo(controller: UIViewController, id:String, completion:@escaping(_ success:NSObject) -> Void) {
        if !Connectivity.isConnectedToInternet() { controller.showAlertonNoInternet(); return }
        let url = "\(self.baseURL)backend/captures/status?t=\(id)"
        let header: HTTPHeaders?  = [
                "Authorization" : "",
                "Content-Type": "application/x-www-form-urlencoded",
                "override_session": "true"

            ]
        let headers: HTTPHeaders?  = [
                "Authorization" : "",
                "Content-Type": "application/x-www-form-urlencoded",

            ]
        APIHandler.getRequest(url: url, header: headers) { data  in
            if let value = data?.value(forKey: "body") as? NSObject {
                print(value)
                completion(data!)
            } else {
                guard let topViewController = UIApplication.topViewController() else { return }
                topViewController.showAlert(title: "Multiple Sessions Available", message: "You have more than one active sessions. Do you wish to close all other active sessions?", actionTitle1: "Yes", actionTitle2: "No") { success in
                    if success == true {
                        APIHandler.getRequest(url: url, header: header) { data in
                            completion(data!)
                        }
                    } else {
                        
                    }
                }
            }
        }

    }
    class func getHealthCheckStatus(controller: UIViewController,token:String, info:Data, completion:@escaping(NSObject?,String) -> ()) {
        if !Connectivity.isConnectedToInternet() { controller.showAlertonNoInternet(); return }
        
        let url = "\(self.baseURL)ms-connection-check/initiate_check?t=\(token)"
        let header: HTTPHeaders?  = [
            "Content-Type": "application/json"
        ]
        var urlRequest = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.headers = header ?? []
        
        urlRequest.httpBody = info
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSObject {
                    print("Response: \(json)")
                    completion(json,"")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
            }
            
        }
        task.resume()
    }
    class func submitHealthCheck(controller: UIViewController,token:String, info:Data, completion:@escaping(NSObject?,String) -> ()) {
        if !Connectivity.isConnectedToInternet() { controller.showAlertonNoInternet(); return }
        let url = "\(self.baseURL)ms-connection-check/submit_connection_stats?t=\(token)"
        let header: HTTPHeaders?  = [
            "Content-Type": "application/json"
        ]
        print(url)
        var urlRequest = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.headers = header ?? []
        
        urlRequest.httpBody = info
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSObject {
                    print("Response: \(json)")
                    completion(json,"")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
            }
            
        }
        task.resume()
    }
    class func uploadImage(url: String, fileName: String, image: UIImage?,controller:UIViewController, completion:@escaping(_ status: Bool, _ error: String) -> Void) {
        if !Connectivity.isConnectedToInternet() { controller.showAlertonNoInternet(); return }
        
        guard let imageData = image?.jpegData(compressionQuality: 1) else { return }
        print(imageData)
        print("Screenshot URL: \(url)")
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = imageData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            completion(true,"")
        }
        task.resume()
    }
}
