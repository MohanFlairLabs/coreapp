//
//  CodableModels.swift
//  app
//
//  Created by Admin on 05/10/21.
//

import Foundation

// MARK: - PheonixODScoket
struct PheonixODModel: Codable {
    var payload: [PheonixODScokets]
}
// MARK: - Payload
struct PheonixODScokets: Codable {
    var attr: String
    var data: PayloadData
}

// MARK: - DataClass
struct PayloadData: Codable {
    var latitude, longitude: Double
    var altitude: String
    var accuracy: Int
    var altitudeAccuracy, heading, speed: String
    var timestamp: String
}
struct PageSequence {
    var page:String?
    var validations: NSObject
}
// MARK: - HealthCheckModel
struct HealthCheckModel: Codable {
    var referenceID, networkCheckID: String
    var statistics: Statistics

    enum CodingKeys: String, CodingKey {
        case referenceID = "reference_id"
        case networkCheckID = "network_check_id"
        case statistics
    }
}

// MARK: - Statistics
struct Statistics: Codable {
    var roomJoin, publish: Bool
    var iceConnectionState: String
    var webrtcStats: WebrtcStats
    var errors: [ErrorMessage]

    enum CodingKeys: String, CodingKey {
        case roomJoin = "room_join"
        case publish
        case iceConnectionState = "ice_connection_state"
        case webrtcStats = "webrtc_stats"
        case errors
    }
}
struct WebrtcStats: Codable {
}
struct ErrorMessage: Codable {
}
struct StatsViewData: Codable {
    var typeName: String?
    var localUserData: String?
    var remoteUserData: String?
}
class ReadObjectFromFileModal {
    
    static func readSampleTaskDataFromFile() -> PheonixODModel? {
        let path = Bundle.main.path(forResource: "taskData", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let sportsData = try? Data(contentsOf: url)
        guard
            let data = sportsData
        else { return nil  }
        do {
            let result = try JSONDecoder().decode(PheonixODModel.self, from: data)
//            print(result)
            return result
        } catch let error {
            print("Failed to Decode Object", error)
            return nil
        }
    }
}
