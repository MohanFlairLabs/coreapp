//
//  EventLogController.swift
//  app
//
//  Created by Admin on 03/09/21.
//

import Foundation

class EventLogController: NSObject {
    
    /// Appends the given string to the stream.
    @objc class func write(_ string: String) {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath = documentsDirectory.appendingPathComponent("App_Logs")
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: Date())
            //Remove old logs from the app
            
            let deletingFiles = Date.getDates(forLastNDays: 7, withCurrent: false, forDelete: true)
            
            for file in deletingFiles {
                self.delete(fileName: file)
            }
            //iOS_Date_logs.txt
            let log = dataPath.appendingPathComponent("iOS_\(dateString)_logs.txt")
            do {
                let _ = try String(contentsOf: log, encoding: .utf8)
            }
            catch(let err) {
                print(err)
            }
            writeLogToFile(log, "[Current: [\(Date().currentTimeZoneDate())], UTC: [\(Date().dateInUTCTimeZone(timeZoneIdentifier: "UTC", dateFormat: "yyyy-MM-dd HH:mm:ss"))]]  \(string)")
            print("EVENT_TRACKER = [Current: [\(Date().currentTimeZoneDate())], UTC: [\(Date().dateInUTCTimeZone(timeZoneIdentifier: "UTC", dateFormat: "yyyy-MM-dd HH:mm:ss"))]] \(string)")
        }
        catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }
    
    @objc class func getDeviceDetails() -> String {
        
        let deviceDetails = "\n ***** \ndeviceModel = \(ApplicationController.deviceModel)\nosVersion = \(ApplicationController.osVersion)\nappVersion = \(ApplicationController.appVersion)\nfreeRamSpace = \(ApplicationController.freeRamSpace)\nfreeDiskSpace = \(ApplicationController.freeDiskSpace)\n******\n"
        return deviceDetails
    }
    
    fileprivate static func writeLogToFile(_ log: URL, _ string: String) {
        do {
            let handle = try FileHandle(forWritingTo: log)
            // print(handle)
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } catch {
            do {
                try string.data(using: .utf8)?.write(to: log)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private class func delete(fileName : String) {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let folderPath = docDir.appendingPathComponent("Callproof_Logs")
        let filePath = folderPath.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: filePath)
            print("File deleted")
        }
        catch {
            // print("Error")
        }
    }
}



extension Date {
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func currentTimeZoneDate() -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dtf.string(from: self)
    }
    
    func dateInUTCTimeZone(timeZoneIdentifier: String, dateFormat: String) -> String  {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone(identifier: timeZoneIdentifier)
        dtf.dateFormat = dateFormat
        
        return dtf.string(from: self)
    }
    
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    static func getDates(forLastNDays nDays: Int, withCurrent: Bool, forDelete: Bool) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        if forDelete {
            date = cal.date(byAdding: .day, value: -2, to: date)!
        }
        else {
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        
        var arrDates = [String]()
        
        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: .day, value: -1, to: date)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            arrDates.append("iOS_\(dateString)_logs.txt")
        }
        return arrDates
    }
}

