//
//  SinchCalling.swift
//  DriverApp
//
//  Created by Admin on 10/13/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

protocol SinchCallingProtocol: class {
    func callDidEnd()
    func callDidEstablish()
    func clientDidStart()
}

class SinchCalling: NSObject, SINCallClientDelegate, SINCallDelegate, SINClientDelegate, SINAudioControllerDelegate {
    
    weak var delegate: SinchCallingProtocol? = nil
    
    public static var sinchInstance:SinchCalling?
    
    var sinAudioController: SINAudioController!
    var client: SINClient!
    var callFromSynch:SINCall!
    var callRunnig = false
    
    let generalFunc = GeneralFunctions()
    
    var soundPath = ""
    
    
    static func getInstance() -> SinchCalling{
        if(sinchInstance == nil){
            sinchInstance = SinchCalling()
        }
        
        return sinchInstance!
    }
    
    func localizedString(forKey key: String) -> String {
    
        return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
    }
    
    func initSinchClient(){
        
        if(GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) == nil){
            return
        }
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        if(userProfileJson.get("SINCH_APP_KEY") != "" && userProfileJson.get("SINCH_APP_SECRET_KEY") != "" && userProfileJson.get("SINCH_APP_ENVIRONMENT_HOST") != ""){
            if GeneralFunctions.getMemberd() == "" {
                if client != nil{
                    removeSinchClient()
                }
            }else{
                if client == nil{
                    
                    GeneralFunctions.registerRemoteNotification()
                    
                    
                    
                    //GeneralFunctions.registerRemoteNotification()
                    client = Sinch.client(withApplicationKey: userProfileJson.get("SINCH_APP_KEY"), applicationSecret: userProfileJson.get("SINCH_APP_SECRET_KEY"), environmentHost: userProfileJson.get("SINCH_APP_ENVIRONMENT_HOST"), userId: Utils.appUserType + "_" + GeneralFunctions.getMemberd())
                    client.delegate = self
                    client.call().delegate = self
                    client.setSupportCalling(true)
                    client.setSupportPushNotifications(true)
                    client.setSupportActiveConnectionInBackground(true)
                    client.enableManagedPushNotifications()
                    client.start()
                    client.startListeningOnActiveConnection()
                    
                    sinAudioController = client.audioController()
                    soundPath = Bundle.main.path(forResource: "telephone", ofType: "wav")!
                    //SINAudioController.s
                }
            }
        }
       
    }
    
    func makeACall(IDString:String, assignedData:NSDictionary, selfData:[String:String], withRealNumber:String){
        if callFromSynch == nil && client != nil{
           
            if client.isStarted(){
                
                if (withRealNumber != ""){
                    callFromSynch = client.call().callPhoneNumber(withRealNumber)
                }else{
                    callFromSynch = client.call().callUser(withId: IDString, headers: selfData)
                }
              
                callFromSynch.delegate = self
                client.setPushNotificationDisplayName(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INCOMING_CALL"))
                
                let sinchCallingUV = GeneralFunctions.instantiateViewController(pageName: "SinchCallingUV") as! SinchCallingUV
                
                sinchCallingUV.assignedData = assignedData
                sinchCallingUV.modalPresentationStyle = .overCurrentContext
                let visibleViewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                if(visibleViewController != nil){
                    visibleViewController!.pushToNavController(uv: sinchCallingUV, isDirect: true)
                }else{
                    Application.window!.rootViewController?.pushToNavController(uv: sinchCallingUV, isDirect: true)
                }
                
                return
            }else{
                
                if(client.isStarted() == false){
                    self.initSinchClient()
                    return
                }
                callFromSynch.hangup()
                
            }
            
        }else{
            
            if(client == nil){
                self.initSinchClient()
                return
            }
            callFromSynch.hangup()
            
            return
        }
    }
    
    func removeSinchClient(){
        sinAudioController.stopPlayingSoundFile()
        client.unregisterPushNotificationDeviceToken()
        self.client.stop()
        self.client = nil
        if(callFromSynch != nil){
            callFromSynch = nil
        }
       
    }
    
    /* SINCH DELEGATE METHODS.*/
    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        sinAudioController.startPlayingSoundFile(soundPath, loop: true)
        call.delegate = self
        callFromSynch = call
        
        let sinchCallingUV = GeneralFunctions.instantiateViewController(pageName: "SinchCallingUV") as! SinchCallingUV
        sinchCallingUV.assignedData = call.headers! as NSDictionary
        sinchCallingUV.isCallReceiving = true
        sinchCallingUV.modalPresentationStyle = .overCurrentContext
        let visibleViewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
        if(visibleViewController != nil){
            visibleViewController!.pushToNavController(uv: sinchCallingUV, isDirect: true)
        }else{
            Application.window!.rootViewController?.pushToNavController(uv: sinchCallingUV, isDirect: true)
        }
        //callFromSynch.answer()
    }
    
    func callDidEnd(_ call: SINCall!) {
       
        //client.setPushNotificationDisplayName(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_ENDED"))
        sinAudioController.stopPlayingSoundFile()
        callRunnig = false
        callFromSynch = nil
        delegate?.callDidEnd()
        print("<<<<<<<<CALL ENDED>>>>>>>")
    }
    
    func callDidEstablish(_ call: SINCall!) {
        sinAudioController.stopPlayingSoundFile()
        callRunnig = true
        delegate?.callDidEstablish()
        print("<<<<<<<<CALL ESTABLISH>>>>>>>")
        
    }
    
    func callDidProgress(_ call: SINCall!) {
        print("<<<<<<<<CALL PROGRESS>>>>>>>")
    }
    
    func clientDidStart(_ client: SINClient!) {
        
        print("<<<<<<<<CLIENT DID START>>>>>>>")
    }
    
    func clientDidStop(_ client: SINClient!) {
        
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        
        sinAudioController.stopPlayingSoundFile()
        self.client = nil
        //self.initSinchClient()
        print(">>>>>>>CLIENT Did FAIL>>>>>>>")
    }
}
