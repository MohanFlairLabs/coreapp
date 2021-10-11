//
//  UserDefaultsExtension.swift
//  app
//
//  Created by Admin on 07/10/21.
//

import Foundation

extension UserDefaults {
    class var roomId: String? {
        get {
            return standard.string(forKey: "room_id")
        }
        set {
            standard.set(newValue, forKey: "room_id")
            standard.synchronize()
        }
    }
    class var hostUrl: String? {
        get {
            return standard.string(forKey: "host_ip")
        }
        set {
            standard.set(newValue, forKey: "host_ip")
            standard.synchronize()
        }
    }
    class var streamReferenceId: String? {
        get {
            return standard.string(forKey: "stream_ref_id")
        }
        set {
            standard.set(newValue, forKey: "stream_ref_id")
            standard.synchronize()
        }
    }
}
