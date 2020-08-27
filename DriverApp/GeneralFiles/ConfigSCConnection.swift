//
//  ConfigSCConnection.swift
//  DriverApp
//
//  Created by Admin on 23/07/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation
/**
 * This class maintain connection to server (SocketCluster) and declared all useful methods.
 */
class ConfigSCConnection: NSObject, OnLocationUpdateDelegate, OnTaskRunCalledDelegate {
    
    static let removeSCInst_key = "REMOVE_SC_PUBSUB_INST"
    
    typealias CompletionHandler = (_ response:String) -> Void
    
    /**
     * Variable declaration of singleton instance.
     */
    static var configScConn:ConfigSCConnection!
    
    /**
     * client is object of sockect cluster. With the help of this object, we can perform any required operations of socket cluster. Socket cluster is running on particular port and mentioned port must be open for all connection (Public port).
     */
    var client = ScClient(url: GeneralFunctions.getValue(key: Utils.SC_CONNECT_URL_KEY) as! String)
    
    /**
     * Variable used to check user is successfully authenticated or not.
     */
    var isUserAuthenticated = false
    
    /**
     * This list maintains list of subscribed channels list.
     */
    var listOfSubscribedList = [String]()
    
    /**
     * This list maintains list of channels list, which are not subscribed.
     */
    var listOfNotSubscribedList = [String]()
    
    /**
     * Variable used to check driver is subscribed to cab request channel or not. This variable should be maintain when subscribing/unsubscribing cab request channel.
     */
    var isSubsToCabReq = false
    
    /**
     * This task will will perform connection between app to server.
     */
    var reConnectionFreqTask:UpdateFreqTask!
    
    /**
     * This variable check weather a subscribing to one channel is in process or not.
     */
    var isChannelSubscribing = false
    
    var getLocation:GetLocation!
    
    var FETCH_TRIP_STATUS_TIME_INTERVAL_INT = 15
    var updateTripStatusFreqTask:UpdateFreqTask!
    
    var generalFunc = GeneralFunctions()
    
    var latitude = 0.0
    var longitude = 0.0
    
    var checkTripStatus:ExeServerUrl!
    
    var listOfPendingPublishMsg = NSMutableDictionary()
    
    var isKilled = false
    
    /**
     * Creating Singleton instance. By using this method will create only one instance of this class.
     */
    static func getInstance() -> ConfigSCConnection{
        
        if(configScConn == nil){
            configScConn = ConfigSCConnection()
        }
        
        return configScConn
    }
    
    static func retrieveInstance() -> ConfigSCConnection?{
        return configScConn
    }
    
    /**
     * This function will create a socket connection with the help of socket cluster with mentioned server. Don't call this function every time. This must be called once on each session of app.
     */
    func buildConnection(){
        if(self.client.isConnected()){
            return
        }
        
        Utils.printLog(msgData: "SC_CONNECT_URL::\(GeneralFunctions.getValue(key: Utils.SC_CONNECT_URL_KEY) as! String)")
        
        getLocation = GetLocation(uv: Application.window!.rootViewController!, isContinuous: true)
        getLocation.buildLocManager(locationUpdateDelegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.forceDestroy), name: NSNotification.Name(rawValue: ConfigSCConnection.removeSCInst_key), object: nil)
        
        
        let FETCH_TRIP_STATUS_TIME_INTERVAL = GeneralFunctions.getValue(key: Utils.FETCH_TRIP_STATUS_TIME_INTERVAL_KEY) != nil ? (GeneralFunctions.getValue(key: Utils.FETCH_TRIP_STATUS_TIME_INTERVAL_KEY) as! String) : "15"
        
        FETCH_TRIP_STATUS_TIME_INTERVAL_INT = GeneralFunctions.parseInt(origValue: 15, data: FETCH_TRIP_STATUS_TIME_INTERVAL)
        
        updateTripStatusFreqTask = UpdateFreqTask(interval: GeneralFunctions.parseDouble(origValue: 15, data: FETCH_TRIP_STATUS_TIME_INTERVAL))
        updateTripStatusFreqTask.onTaskRunCalled = self
        updateTripStatusFreqTask.currInst = updateTripStatusFreqTask
        updateTripStatusFreqTask.startRepeatingTask()
        
        
        /**
         * This is a basic connection listener. This listener will be called when connection related event occurred.
         */
        client.setBasicListener(onConnect: { (scClient) in
            // Called when socket connection is established
            print("ConnectedToSocket")
            self.stopReConnectScheduleTask()
            
            let subscribeTask = UpdateFreqTask(interval: 4)
            subscribeTask.currInst = subscribeTask
            subscribeTask.setTaskRunHandler { (currentInst) in
                self.continueChannelSubscribe()
                
                subscribeTask.stopRepeatingTask()
            }
            subscribeTask.startRepeatingTask()
            
        }, onConnectError: { (scClient, error) in
            // Called when error occurred in socket connection
            self.reConnectClient()
        }, onDisconnect: { (scClient, error) in
            // Called when socket connection is disconnected
            print("SocketDisconnect::\(String(describing: error))")
            self.reConnectClient()
        })
        
        /**
         * This is a authentication listner. This listner will be called when user is successfully authenticated by server OR user needs to be authenticated.
         */
        client.setAuthenticationListener(onSetAuthentication: { (scClient, authToken) in
            // Called when authentication is successful and authentication token is set by server. Server will set authentication code when user login is verified.
            print("AuthenticatedUser::\(String(describing: authToken))")
            
        }, onAuthentication: { (scClient, isAuthenticated) in
            // By Using this listner we can check user needs to be authenticated OR not.
            
            if(isAuthenticated != nil && isAuthenticated! == true){
                // Server Authentication Successful (Authentication is not needed)
                print("AuthenticatedUser")
                //                self.continueChannelSubscribe()
            }else{
                // Do Server Authentication (Authentication is needed)
                //                self.authenticateUser(client: scClient)
                
                //                self.continueChannelSubscribe()
            }
        })
        
        /**
         * Called to connect socket cluster.
         */
        client.connect()
        
    }
    
    func onTaskRun(currInst: UpdateFreqTask) {
        if(self.isKilled == true){
            return
        }
        
        if(updateTripStatusFreqTask != nil && currInst == updateTripStatusFreqTask){
            if(self.client.isConnected()){
                getUserTripStatus(completionHandler: { (isTaskCompleted) in
                    
                })
            }
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
    
    
    func getUserTripStatus(completionHandler: @escaping (Bool?) -> Swift.Void){
        if(isKilled == true){
            return
        }
        
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
                        
                        GeneralFunctions.postNotificationSignal(key: ConfigPubNub.removeInst_key, obj: self)
                        GeneralFunctions.postNotificationSignal(key: ConfigSCConnection.removeSCInst_key, obj: self)
                        
                        self.generalFunc.setAlertMessage(uv: nil , title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG, completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                            
                            GeneralFunctions.logOutUser()
                            GeneralFunctions.restartApp(window: Application.window!)
                        })
                    }
                    
                    return
                }
                
                completionHandler(true)
                
                DispatchQueue.main.async {
                    if(dataDict.get("Action") == "1"){
                        
                        CabRequestStatus.removeDriverRequestStatus(reqKeys: extraRequestParams)
                        
                        if(iTripId != nil && (iTripId as! String).trim() != ""){
                            self.dispatchMsg(result: dataDict.get(Utils.message_str), receivedBy: "Script")
                        }else{
                            let msgArr = dataDict.getArrObj(Utils.message_str)
                            
                            for i in 0..<msgArr.count {
                                let msgStr = (msgArr[i] as! String)
                                self.dispatchMsg(result: msgStr, receivedBy: "Script")
                            }
                        }
                    }
                }
                
            }else{
                
                completionHandler(false)
            }
        })
    }
    
    /**
     * Function used to reconnect socket connection if conncetion failure/disconnect.
     */
    func reConnectClient(){
        if(reConnectionFreqTask != nil || self.isKilled == true){
            return
        }
        self.stopReConnectScheduleTask()
        reConnectionFreqTask = UpdateFreqTask(interval: 10)
        reConnectionFreqTask.currInst = reConnectionFreqTask
        reConnectionFreqTask.setTaskRunHandler { (currentInst) in
            self.client.connect()
        }
        reConnectionFreqTask.startRepeatingTask()
    }
    
    /**
     * This will stop reconnection task.
     */
    func stopReConnectScheduleTask(){
        if(reConnectionFreqTask != nil){
            reConnectionFreqTask.stopRepeatingTask()
            reConnectionFreqTask = nil
        }
    }
    
    /**
     * Function used to authenticate user.
     */
    func authenticateUser(client: ScClient){
        
        var params = [String:String]()
        params["iMemberId"] = GeneralFunctions.getMemberd()
        params["tSessionId"] = GeneralFunctions.getSessionId()
        params["UserType"] = Utils.appUserType
        params["deviceHeight"] = "\(Application.screenSize.height)"
        params["deviceWidth"] = "\(Application.screenSize.width)"
        
        /**
         * This code will transfer user's credentials to server to check it is right or not. Based on that credentials server will authenticate user.
         */
        client.emitAck(eventName: "authenticateUser", data: params as AnyObject) { (eventName, error, data) in
            
            if(error != nil && !error!.isKind(of: NSNull.self)){
                // Error in Authentication.
                
                let dataDict = (error! as! String).getJsonDataDict()
                
                if(dataDict.get(Utils.action_str) == "0"){
                    // Authentication unsuccessful. This case should not come normally.
                    
                }else{
                    // Some error occurred in authentication. Do authentication again.
                    self.authenticateUser(client: client)
                }
                
            }else{
                if(data != nil){
                    let dataDict = (data! as! String).getJsonDataDict()
                    
                    if(dataDict.get(Utils.action_str) == "1"){
                        // Authentication Successful. Start initialing all things.
                        
                        
                        self.continueChannelSubscribe()
                        
                    }
                }
                
            }
        }
    }
    
    /**
     * This function is used to subscribe channels, which are not due to not connected to server.
     */
    func continueChannelSubscribe(){
        
        if(self.isKilled == true){
            return
        }
        
        //        self.isUserAuthenticated = true
        
        self.isChannelSubscribing = false
        
        self.releaseAllChannels()
        
        //Subscribing to private channel.
        ConfigSCConnection.getInstance().subscribeToChannels(channelName: "DRIVER_\(GeneralFunctions.getMemberd())")
        
        for i in 0..<self.listOfSubscribedList.count{
            self.subscribeToChannels(channelName: self.listOfSubscribedList[i])
        }
        
        if(listOfPendingPublishMsg.count > 0){
            for (key,value) in listOfPendingPublishMsg{
                if((key as? String) != nil && (value as? String) != nil){
                    self.publishMsg(channelName: key as! String, content: value as! String)
                }
            }
            
            listOfPendingPublishMsg.removeAllObjects()
        }
        
        
    }
    
    
    /**
     * This function is used to subscribe to channels. (Publish-Subscribe module)
     */
    func subscribeToChannels(channelName:String){
        
        print("channelName::\(channelName)")
        
        // Add any new Channels to subscribed channels list. We will use this list to unsubscribe channels.
        if(!self.listOfSubscribedList.contains(channelName)){
            self.listOfSubscribedList += [channelName]
        }
        
        //        if(self.isUserAuthenticated == false){
        //            // If User is not authenticated, then wait for authentication and after authentication we will resubscribe that channels.
        //            return
        //        }
        if(self.client.isConnected() == false){
            return
        }
        
        if(isChannelSubscribing == true){
            self.listOfNotSubscribedList += [channelName]
            return
        }
        
        isChannelSubscribing = true
        
        if(channelName.contains("CAB_REQUEST_DRIVER")){
            self.isSubsToCabReq = true
        }
        
        // Function used to subscribe nerw channels with acknowledgement.
        self.client.subscribeAck(channelName: channelName, ack : {
            (channelName : String, error : AnyObject?, data : AnyObject?) in
            
            self.isChannelSubscribing = false
            
            if (error is NSNull) {
                // If subscribe to particular channel is success then start hearing on that channel
                self.client.onChannel(channelName: channelName, ack: { (channelName : String , data : AnyObject?) in
                    // Handle data when some event notification is arrived.
                    
                    print("DataInChannelReceived::\(String(describing: data))")
                    
                    var result = NSDictionary()
                    
                    if((data! as? NSDictionary) != nil){
                        result = data! as! NSDictionary
                    }else if((data! as? String) != nil){
                        result = (data! as! String).getJsonDataDict()
                    }
                    
                    DispatchQueue.main.async {
                        self.dispatchMsg(result: result.convertToJson(), receivedBy: "PubSub")
                    }
                })
                
                print("Successfully subscribed to channel ", channelName)
                
                
                if(self.listOfNotSubscribedList.count > 0){
                    let newChannel = self.listOfNotSubscribedList[0]
                    self.listOfNotSubscribedList.remove(at: 0)
                    
                    self.subscribeToChannels(channelName: newChannel)
                }
                
                
            } else {
                // If error appears then try to resubscribe to channel. A recursive call will be called after 2 seconds delay.
                Utils.delayWithSeconds(2, completion: {
                    self.subscribeToChannels(channelName: channelName)
                })
                
                print("Got error while subscribing ", String(describing: error))
            }
        })
    }
    
    /**
     * Function used to unsubscribe user from particular channel.
     */
    func unSubscribeFromChannels(channelName:String){
        if(self.listOfSubscribedList.contains(channelName)){
            
            if(channelName.contains("CAB_REQUEST_DRIVER")){
                self.isSubsToCabReq = false
            }
            
            self.client.unsubscribeAck(channelName: channelName, ack: { (channelName, error, data) in
                if (error is NSNull) {
                    if let index = self.listOfSubscribedList.index(of: channelName) {
                        self.listOfSubscribedList.remove(at: index)
                    }
                }else{
                    if(error != nil && error as? NSDictionary != nil){
                        let errorDict = error! as! NSDictionary
                        
                        if(errorDict.get("name") != "BrokerError"){
                            // IF problem appears on unsbscribing channel then retry it. A recursive call will be called after 2 seconds delay.
                            Utils.delayWithSeconds(2, completion: {
                                self.unSubscribeFromChannels(channelName: channelName)
                            })
                        }
                    }
                    
                }
            })
        }
    }
    
    /**
     * Function used to unsubscribe all channels. Generally this will be done when app is going to be terminate.
     */
    func releaseAllChannels(){
        for i in 0..<self.listOfSubscribedList.count{
            self.unSubscribeFromChannels(channelName: self.listOfSubscribedList[i])
        }
    }
    
    /**
     * Function used to destroy current instance. Generally this will be done when app is going to be terminate OR instance of this class is no longer required.
     */
    @objc func forceDestroy(){
        releaseAllChannels()
        if(ConfigSCConnection.retrieveInstance() != nil){
            self.isKilled = true
            ConfigSCConnection.retrieveInstance()!.client.disconnect()
            stopReConnectScheduleTask()
            if(updateTripStatusFreqTask != nil){
                updateTripStatusFreqTask.stopRepeatingTask()
            }
            if(getLocation != nil){
                getLocation.releaseLocationTask()
                getLocation.locationUpdateDelegate = nil
                getLocation = nil
            }
            GeneralFunctions.removeObserver(obj: ConfigSCConnection.retrieveInstance()!)
            
            ConfigSCConnection.configScConn = nil
        }
    }
    
    /**
     * Function used to publish data to particular channel.
     */
    func publishMsg(channelName:String, content:String){
        if(!self.client.isConnected()){
            listOfPendingPublishMsg[channelName] = content
            return
        }
        
        self.client.publishAck(channelName: channelName, data: content as AnyObject) { (channel, error, data) in
            
            if(error is NSNull){
                
            }
        }
    }
    
    /**
     * Function used to dispatch message to user when received some event on particular channel.
     */
    private func dispatchMsg(result:String, receivedBy:String){
        FireTripStatusMessges().fireTripMsg(result, true, receivedBy)
    }
}

