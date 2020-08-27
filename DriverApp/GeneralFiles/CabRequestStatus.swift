//
//  CabRequestStatus.swift
//  DriverApp
//
//  Created by Admin on 17/12/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class CabRequestStatus: NSObject {
    static let DRIVER_REQUEST_STATUS_KEY = "DRIVER_REQUEST_STATUS_"

    static func updateDriverRequestStatus(PassengerId:String, UpdatedStatus: String,ReceiverByscriptName : String, repeatCount:Int, vMsgCode:String){
        GeneralFunctions.saveValue(key: DRIVER_REQUEST_STATUS_KEY + vMsgCode + "_\(Utils.currentTimeMillis())_\(PassengerId)_\(UpdatedStatus)_\(ReceiverByscriptName)", value: "Yes" as AnyObject)
        
        if (repeatCount > 3) {
            return
        }
        
        let parameters = ["type":"updateDriverRequestStatus", "iDriverId": GeneralFunctions.getMemberd(), "PassengerId":PassengerId, "UpdatedStatus":UpdatedStatus, "ReceiverByscriptName": ReceiverByscriptName, "vMsgCode":vMsgCode]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: UIView(), isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                
            }else{
                let repCount = repeatCount + 1
                CabRequestStatus.updateDriverRequestStatus(PassengerId: PassengerId, UpdatedStatus: UpdatedStatus, ReceiverByscriptName: ReceiverByscriptName, repeatCount: repCount, vMsgCode: vMsgCode)
            }
            
        })
    }
    
    static func removeDriverRequestStatus(reqKeys:NSDictionary){
        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
            if key.hasPrefix(DRIVER_REQUEST_STATUS_KEY) {
                if(reqKeys.get(key) != ""){
                    GeneralFunctions.removeValue(key: key)
                }
            }
        }
    }
    
    static func getAllStatusParam() -> NSDictionary {
        let reqKeys = NSMutableDictionary()
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            if key.hasPrefix(DRIVER_REQUEST_STATUS_KEY) {
                reqKeys[key] = (value as? String) == nil ? "" : (value as! String)
//                reqKeys.append(key)
            }
        }
        
        return reqKeys
    }
    
}
