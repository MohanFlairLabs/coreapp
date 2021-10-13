//
//  SreverCommunicationHandler.swift
//  app
//
//  Created by Admin on 18/08/21.
//

import Foundation
import Alamofire

class APIHandler {

    class func getRequest(url:String,header: HTTPHeaders?, completionHandler: @escaping (NSObject?) -> ())  {
        Session.customSession.request(URL(string: url)! , method: .get, headers: header).responseString { (response)  in
            
            if let headerFields = response.response?.allHeaderFields as? [String: String], let URL = response.request?.url {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                print(cookies)
            }
            switch response.result {
            
            case .success(_):
                
                print("Server Request = \(String(describing: response.request)) and Server Response = \(String(describing: String(data: response.data ?? Data(), encoding: .utf8)))")
                
                guard let responseData = response.data else {  return   }
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseData, options: .fragmentsAllowed) as! NSObject
                    completionHandler(dictionary)
                    
                } catch {
                    completionHandler(error as NSObject)
                }
                break
            case .failure(_):
                break
                
            }
        }
    }
}
extension Session {
    
    public static let customSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1000
        return Session(configuration: configuration)
    }()
}
