//
//  ConfigPubNub.swift
//  DriverApp
//
//  Created by ADMIN on 25/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//
import Foundation
import UserNotifications
import PubNub
import CoreLocation

class ConfigPubNub: NSObject, PNObjectEventListener, OnLocationUpdateDelegate, OnTaskRunCalledDelegate{
    
    static let removeInst_key = "REMOVE_PUBNUB_INST"
    
    public static var instance:ConfigPubNub?
    
    var client: PubNub!
    
    var isRetryKilled = false
    
    var getLocation:GetLocation!
    
    let generalFunc = GeneralFunctions()
    
    var latitude = 0.0
    var longitude = 0.0
    
    var isSubsToCabReq = false
    
    var isKilled = false
    
    var checkTripStatus:ExeServerUrl!
    
    var updateTripStatusFreqTask:UpdateFreqTask!
    var scheduleAppInActiveLocalNotificationTask:UpdateFreqTask!
    
    var FETCH_TRIP_STATUS_TIME_INTERVAL_INT = 15
    var userProfileJson:NSDictionary!
    
    static func getInstance() -> ConfigPubNub{
        if(instance == nil){
            instance = ConfigPubNub()
        }
        
        return instance!
    }
    
    static func getInstance(isCheck:Bool) -> ConfigPubNub?{
        return instance
    }
    
    func buildPubNub(){
        
        releasePubNub()
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        if(userProfileJson.get("PUBSUB_TECHNIQUE").uppercased() == "SOCKETCLUSTER"){
            ConfigSCConnection.getInstance().buildConnection()
            
            scheduleAppInActiveLocalNotificationTask = UpdateFreqTask(interval: 10)
            scheduleAppInActiveLocalNotificationTask.onTaskRunCalled = self
            scheduleAppInActiveLocalNotificationTask.currInst = scheduleAppInActiveLocalNotificationTask
            scheduleAppInActiveLocalNotificationTask.startRepeatingTask()
            
            return
        }else if(userProfileJson.get("PUBSUB_TECHNIQUE").uppercased() == "YALGAAR"){
            
            
            scheduleAppInActiveLocalNotificationTask = UpdateFreqTask(interval: 10)
            scheduleAppInActiveLocalNotificationTask.onTaskRunCalled = self
            scheduleAppInActiveLocalNotificationTask.currInst = scheduleAppInActiveLocalNotificationTask
            scheduleAppInActiveLocalNotificationTask.startRepeatingTask()
            
            return
        }else if(userProfileJson.get("PUBSUB_TECHNIQUE").uppercased() == "PUBNUB"){
            let PUBNUB_PUB_KEY = GeneralFunctions.getValue(key: Utils.PUBNUB_PUB_KEY)
            let PUBNUB_SUB_KEY = GeneralFunctions.getValue(key: Utils.PUBNUB_SUB_KEY)
            
            if(PUBNUB_PUB_KEY != nil && (PUBNUB_PUB_KEY as! String).trim() != "" && PUBNUB_SUB_KEY != nil && (PUBNUB_SUB_KEY as! String).trim() != ""){
                let configuration = PNConfiguration(publishKey: PUBNUB_PUB_KEY as! String, subscribeKey: PUBNUB_SUB_KEY as! String)
                
                configuration.uuid = GeneralFunctions.getValue(key: Utils.DEVICE_SESSION_ID_KEY) == nil ? (UIDevice.current.identifierForVendor != nil ? UIDevice.current.identifierForVendor!.uuidString : GeneralFunctions.getMemberd()) : (GeneralFunctions.getValue(key: Utils.DEVICE_SESSION_ID_KEY) as! String)
                configuration.stripMobilePayload = false
                
                
                self.client = PubNub.clientWithConfiguration(configuration)
                self.client.addListener(self)
                
                self.client.logger.enabled = false
                
                subscribeToPrivateChannel()
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseInstance), name: NSNotification.Name(rawValue: ConfigPubNub.removeInst_key), object: nil)
        
        getLocation = GetLocation(uv: nil, isContinuous: true)
        getLocation.buildLocManager(locationUpdateDelegate: self)
        
        let FETCH_TRIP_STATUS_TIME_INTERVAL = GeneralFunctions.getValue(key: Utils.FETCH_TRIP_STATUS_TIME_INTERVAL_KEY) != nil ? (GeneralFunctions.getValue(key: Utils.FETCH_TRIP_STATUS_TIME_INTERVAL_KEY) as! String) : "15"
        
        FETCH_TRIP_STATUS_TIME_INTERVAL_INT = GeneralFunctions.parseInt(origValue: 15, data: FETCH_TRIP_STATUS_TIME_INTERVAL)
        
        updateTripStatusFreqTask = UpdateFreqTask(interval: GeneralFunctions.parseDouble(origValue: 15.0, data: FETCH_TRIP_STATUS_TIME_INTERVAL))
        updateTripStatusFreqTask.onTaskRunCalled = self
        updateTripStatusFreqTask.currInst = updateTripStatusFreqTask
        updateTripStatusFreqTask.startRepeatingTask()
    }
    
    func onTaskRun(currInst: UpdateFreqTask) {
        if(updateTripStatusFreqTask != nil && currInst == updateTripStatusFreqTask){
            getUserTripStatus()
        }
        scheduleAppInactiveNotifition()
    }
    
    func scheduleAppInactiveNotifition(){
        
        Utils.removeAppInactiveStateNotifications()
        
        let iTripId = GeneralFunctions.getValue(key: "iTripId")
        if(iTripId != nil && (iTripId as! String).trim() != ""){
            Utils.addAppInactiveStateNotification(seconds: FETCH_TRIP_STATUS_TIME_INTERVAL_INT + 5)
        }else{
            if let IS_DRIVER_ONLINE = GeneralFunctions.getValue(key: "IS_DRIVER_ONLINE") as? String{
                if(IS_DRIVER_ONLINE == "true"){
                    Utils.addAppInactiveStateNotification(seconds: FETCH_TRIP_STATUS_TIME_INTERVAL_INT + 5)
                }
            }
        }
    }
    
    func onLocationUpdate(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    
    func getUserTripStatus(){
        let iTripId = GeneralFunctions.getValue(key: "iTripId")
        
        var parameters = ["type": "configDriverTripStatus", "iTripId": iTripId != nil ? (iTripId as! String) : "", "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "isSubsToCabReq": "\(isSubsToCabReq)"]
        if(latitude != 0.0 && longitude != 0.0){
            parameters["vLatitude"] = "\(latitude)"
            parameters["vLongitude"] = "\(longitude)"
        }
        
        let extraRequestParams = CabRequestStatus.getAllStatusParam()
        for key in extraRequestParams.allKeys {
            parameters[key as! String] = extraRequestParams.get(key as! String)
        }
        
        if(checkTripStatus != nil){
            checkTripStatus.cancel()
            checkTripStatus = nil
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: UIView(), isOpenLoader: false)
        checkTripStatus = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                    Utils.printLog(msgData: "SESSION_OUT_CALLED")
                    if(GeneralFunctions.isAlertViewPresentOnScreenWindow(viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG) == false){
                        
                        self.generalFunc.setAlertMessage(uv: nil , title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG, completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                            GeneralFunctions.postNotificationSignal(key: ConfigPubNub.removeInst_key, obj: self)
                            GeneralFunctions.postNotificationSignal(key: ConfigSCConnection.removeSCInst_key, obj: self)
                            
                            GeneralFunctions.logOutUser()
                            GeneralFunctions.restartApp(window: Application.window!)
                        })
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    if(dataDict.get("Action") == "1"){
                        
                        CabRequestStatus.removeDriverRequestStatus(reqKeys: extraRequestParams)
                        
                        if(self.isKilled == false){
                            if(iTripId != nil && (iTripId as! String).trim() != ""){
                                //                            self.dispatchMsg(result: dataDict.get(Utils.message_str).getJsonDataDict())
                                
                                self.dispatchMsg(result: dataDict.get(Utils.message_str), receivedBy: "Script")
                                
                            }else{
                                let msgArr = dataDict.getArrObj(Utils.message_str)
                                
                                for i in 0..<msgArr.count {
                                    let msgStr = (msgArr[i] as! String)                                    
                                    
//                                    let dict_temp = msgStr.getJsonDataDict()

                                    self.dispatchMsg(result: msgStr, receivedBy: "Script")
                                }
                            }
                            
                        }
                        
                    }
                }
                
            }
        })
    }
    
    @objc func releaseInstance(){
        releasePubNub()
        if(ConfigPubNub.getInstance(isCheck: true) != nil){
            ConfigPubNub.instance = nil
        }
    }
    
    func releasePubNub(){
//        isKilled = true
//        unSubscribeToPrivateChannel()
        
        if(self.client != nil){
            self.client.unsubscribeFromAll()
            self.client.removeListener(self)
        }
        
        GeneralFunctions.removeObserver(obj: self)
        
        if(ConfigSCConnection.retrieveInstance() != nil){
            ConfigSCConnection.getInstance().forceDestroy()
        }
        
        
        
        if(self.getLocation != nil){
            self.getLocation!.locationUpdateDelegate = nil
            self.getLocation!.releaseLocationTask()
            self.getLocation = nil
        }
        
        if(updateTripStatusFreqTask != nil){
            updateTripStatusFreqTask.stopRepeatingTask()
            updateTripStatusFreqTask = nil
        }
    }
    
    func subscribeToPrivateChannel() {
        if(self.client != nil){
            self.client.subscribeToChannels(["DRIVER_\(GeneralFunctions.getMemberd())"], withPresence: true)
        }
        if(ConfigSCConnection.retrieveInstance() != nil){
            ConfigSCConnection.getInstance().subscribeToChannels(channelName: "DRIVER_\(GeneralFunctions.getMemberd())")
        }
        
       
    }
    
    func unSubscribeToPrivateChannel() {
        if(self.client != nil){
            self.client.unsubscribeFromChannels(["DRIVERS_\(GeneralFunctions.getMemberd())"], withPresence: true)
        }
        
        if(ConfigSCConnection.retrieveInstance() != nil){
            ConfigSCConnection.getInstance().unSubscribeFromChannels(channelName: "DRIVER_\(GeneralFunctions.getMemberd())")
        }
        
        
    }
    
    func subscribeToChannels(channels:[String]){
        if(self.client != nil){
            self.client.subscribeToChannels(channels, withPresence: false)
        }
        if(ConfigSCConnection.retrieveInstance() != nil){
            for i in 0..<channels.count{
                ConfigSCConnection.getInstance().subscribeToChannels(channelName: channels[i])
            }
        }
        
        
    }
    
    func unSubscribeToChannels(channels:[String]){
        if(self.client != nil){
            self.client.unsubscribeFromChannels(channels, withPresence: false)
        }
        
        if(ConfigSCConnection.retrieveInstance() != nil){
            for i in 0..<channels.count{
                ConfigSCConnection.getInstance().unSubscribeFromChannels(channelName: channels[i])
            }
        }
        
        
    }
    
    func subscribeToCabReqChannel(){
        isSubsToCabReq = true
        if(self.client != nil){
            self.client.subscribeToChannels(["CAB_REQUEST_DRIVER_\(GeneralFunctions.getMemberd())"], withPresence: true)
        }
        if(ConfigSCConnection.retrieveInstance() != nil){
            ConfigSCConnection.getInstance().subscribeToChannels(channelName: "CAB_REQUEST_DRIVER_\(GeneralFunctions.getMemberd())")
        }
        
       
    }
    
    func unSubscribeToCabReqChannel(){
        isSubsToCabReq = false
        if(self.client != nil){
            self.client.unsubscribeFromChannels(["CAB_REQUEST_DRIVER_\(GeneralFunctions.getMemberd())"], withPresence: true)
        }
        if(ConfigSCConnection.retrieveInstance() != nil){
            ConfigSCConnection.getInstance().unSubscribeFromChannels(channelName: "CAB_REQUEST_DRIVER_\(GeneralFunctions.getMemberd())")
        }
        
        
    }
    
    
    func publishMsg(channelName:String, content:String){
        if(self.client != nil){
            self.client.publish(content, toChannel: channelName,
                                compressed: false, withCompletion: { (status) in
                                    
                                    if !status.isError {
                                        
                                        // Message successfully published to specified channel.
                                        //                                    print("Message is published:\(channelName)")
                                    }
                                    else{
                                        
                                        /**
                                         Handle message publish error. Check 'category' property to find
                                         out possible reason because of which request did fail.
                                         Review 'errorData' property (which has PNErrorData data type) of status
                                         object to get additional information about issue.
                                         
                                         Request can be resent using: status.retry()
                                         */
                                        
                                        //                                    print("Error in published:\(status.errorData)::\(channelName)")
                                        //                                    print("Error in published:\(status)")
                                    }
            })
        }
        
        if(ConfigSCConnection.retrieveInstance() != nil){
            ConfigSCConnection.getInstance().publishMsg(channelName: channelName, content: content)
        }
        
       
    }
    
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        let msg = message.data.message! as! String
        _ = msg.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        Utils.printLog(msgData: "PubNubReceived:\(msg)")
        dispatchMsg(result: msg, receivedBy: "PubSub")
    }
    
    private func dispatchMsg(result:String, receivedBy:String){
        
        if(self.isKilled == true){
            return
        }
        
        FireTripStatusMessges().fireTripMsg(result, true, receivedBy)
    }
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        
        if status.operation == .subscribeOperation {
            
            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                
                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    
                }
                else {
                    
                    /**
                     This usually occurs if subscribe temporarily fails but reconnects. This means there was
                     an error but there is no longer any issue.
                     */
                }
                
                //                print("PubNub connected")
            }
            else if status.category == .PNUnexpectedDisconnectCategory {
                
                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
                
                isRetryKilled = false
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    status.retry()
                })
                
                //                print("PubNub disconnected")
            }
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
            else {
                
                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                if errorStatus.category == .PNAccessDeniedCategory {
                    
                    /**
                     This means that PAM does allow this client to subscribe to this channel and channel group
                     configuration. This is another explicit error.
                     */
                }
                else {
                    
                    /**
                     More errors can be directly specified by creating explicit cases for other error categories
                     of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                     `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                     or `PNNetworkIssuesCategory`
                     */
                    isRetryKilled = false
                }
            }
        }
    }
}
