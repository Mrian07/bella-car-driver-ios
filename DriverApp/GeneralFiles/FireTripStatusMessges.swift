//
//  FireTripStatusMessges.swift
//  DriverApp
//
//  Created by Admin on 25/08/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import Foundation

class FireTripStatusMessges: NSObject {
    
    var isFromPubSub = false
    let generalFunc = GeneralFunctions()
    
    func fireTripMsg(_ messageStr:String, _ isFromPubSub:Bool, _ receivedBy:String){
        
        self.isFromPubSub = isFromPubSub
        let result = messageStr.getJsonDataDict()
        
        if(result.count != 0){
            if(result.get("tSessionId") != "" && result.get("tSessionId") != GeneralFunctions.getSessionId()){
                return
            }
            
            if(result.get("Message") == "CabRequested"){
                CabRequestStatus.updateDriverRequestStatus(PassengerId: result.get("PassengerId"), UpdatedStatus: "Received", ReceiverByscriptName: receivedBy, repeatCount: 1, vMsgCode: result.get("MsgCode"))
            }
            
            let isMsgExist = GeneralFunctions.isTripStatusMsgExist(msgDataDict: result, isFromPubSub: isFromPubSub)
            
            if(isMsgExist == true){
                return
            }
            
            let msg_str = result.get("Message")
            let msgType_str = result.get("MsgType")
            
            if(msgType_str != "" && msgType_str == "CHAT"){
                if(Application.window != nil && Application.window?.rootViewController != nil){
                    
                    if(GeneralFunctions.getVisibleViewController(Application.window!.rootViewController) != nil && GeneralFunctions.getVisibleViewController(GeneralFunctions.getVisibleViewController(nil, isCheckAll: true), isCheckAll: true)?.className != "ChatUV"){
                        
                        let receiverName = result.get("FromMemberName")
                        let receiverId = result.get("iFromMemberId")
                        let tripId = result.get("iTripId")
                        let fromMemberImageName = result.get("FromMemberImageName")
                        
                        GeneralFunctions.saveValue(key: "ChatAssignedtripId", value:tripId as AnyObject)
                        let chatUv = GeneralFunctions.instantiateViewController(pageName: "ChatUV") as! ChatUV
                        chatUv.receiverId = receiverId
                        chatUv.receiverDisplayName = receiverName
                        chatUv.assignedtripId = tripId
                        chatUv.pPicName = fromMemberImageName
                        
                        let viewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                        if viewController != nil{
                            viewController?.pushToNavController(uv: chatUv, isDirect: true)
                        }else{
                            Application.window!.rootViewController?.pushToNavController(uv: chatUv, isDirect: true)
                        }
                        return
                    }else if(GeneralFunctions.getVisibleViewController(GeneralFunctions.getVisibleViewController(nil, isCheckAll: true), isCheckAll: true)?.className == "ChatUV"){
                        if GeneralFunctions.getValue(key: "ChatAssignedtripId") as! String != result.get("iTripId"){
                            GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)?.dismiss(animated: false, completion: {
                                let receiverName = result.get("FromMemberName")
                                let receiverId = result.get("iFromMemberId")
                                let tripId = result.get("iTripId")
                                let fromMemberImageName = result.get("FromMemberImageName")
                                
                                GeneralFunctions.saveValue(key: "ChatAssignedtripId", value:tripId as AnyObject)
                                let chatUv = GeneralFunctions.instantiateViewController(pageName: "ChatUV") as! ChatUV
                                chatUv.receiverId = receiverId
                                chatUv.receiverDisplayName = receiverName
                                chatUv.assignedtripId = tripId
                                chatUv.pPicName = fromMemberImageName
                                
                                let viewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                                if viewController != nil{
                                    viewController?.pushToNavController(uv: chatUv, isDirect: true)
                                }else{
                                    Application.window!.rootViewController?.pushToNavController(uv: chatUv, isDirect: true)
                                }
                            })
                            return
                        }
                    }
                }
                return
            }
            
            if(msg_str != "" && msg_str == "TripCancelled"){
                
                var viewController = Application.window != nil ? (Application.window!.rootViewController != nil ? (Application.window!.rootViewController!) : nil) : nil
                
                if(viewController != nil){
                    let chkViewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                    if(chkViewController?.navigationController != nil && chkViewController?.navigationController!.viewControllers.count == 1){
                        viewController = chkViewController!.navigationController!
                    }
                }
                
                self.generalFunc.setAlertMessage(uv: viewController, title: "", content: result.get("vTitle") == "" ? (msg_str == "TripCancelled" ? generalFunc.getLanguageLabel(origValue: "", key: "LBL_PASSENGER_CANCEL_TRIP_TXT") : generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ADD_BY_PASSENGER")) : result.get("vTitle"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    let window = Application.window!
                    
                    let getUserData = GetUserData(uv: viewController == nil ? UIViewController() : viewController!, window: window)
                    getUserData.getdata()
                    
                })
                
            }else if(msg_str != "" && msg_str == "DestinationAdded"){
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.tripDestinationAdded), object: self, userInfo: ["body":result.convertToJson()])
            }else if(msg_str == "OrderCancelByAdmin" || msg_str == "OrderDeclineByRestaurant"){ // For Deliver All
                
                if result.get("vTitle") != ""
                {
                    if(Application.window != nil && Application.window?.rootViewController != nil && GeneralFunctions.getMemberd() != ""){
                        //(GeneralFunctions()).setError(uv: nil, title: "", content: result.get("vTitle"))
                        
                        self.generalFunc.setAlertMessage(uv: nil, title: "", content: result.get("vTitle"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            let window = Application.window
                            GeneralFunctions.restartApp(window: window!)
                        })
                        
                    }
                }
                
            }else if(msg_str != ""){
                let msgCode = result.get("MsgCode")
                
                if(msgCode != ""){
                    let codeValue = GeneralFunctions.getValue(key: Utils.DRIVER_REQ_CODE_PREFIX_KEY + msgCode)
                    
                    if(codeValue == nil){
                        
                        /* FOR POOL */
                        if (UserDefaults.standard.object(forKey: "STOP_POOL_REQUEST") != nil && GeneralFunctions.getValue(key: "STOP_POOL_REQUEST") as! Bool == true){
                            return
                        }
                        /* FOR POOL */
                        
                        let codeValue = GeneralFunctions.getValue(key: Utils.DRIVER_REQ_CODE_PREFIX_KEY + msgCode)
                        let viewController = GeneralFunctions.getVisibleViewController(nil, isCheckAll: true)
                        if(codeValue == nil){
                            GeneralFunctions.saveValue(key: Utils.DRIVER_REQ_CODE_PREFIX_KEY + msgCode, value: "\(Utils.currentTimeMillis())" as AnyObject)
                            
                            if(viewController != nil){
                                
                                if result.get("eSystem") == "DeliverAll"
                                {
                                    
                                }else
                                {
                                    let cabRequestedUV = GeneralFunctions.instantiateViewController(pageName: "CabRequestedUV") as! CabRequestedUV
                                    cabRequestedUV.passengerJsonDetail_dict = result
                                    cabRequestedUV.initializedMiliSeconds = Utils.currentTimeMillis()
                                    
                                    viewController!.closeDrawerMenu()
                                    
                                    GeneralFunctions.removeAllAlertViewFromNavBar(uv: viewController!)
                                    
                                    viewController!.pushToNavController(uv: cabRequestedUV)
                                }
                                
                            }
                        }
                        
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.passengerRequestArrived), object: self, userInfo: ["body":result.convertToJson()])
                    }
                }
                
            }
        }else if(messageStr.trim() != ""){
            if(Application.window != nil && Application.window?.rootViewController != nil){
//                && Utils.isMyAppInBackground() == false
                (GeneralFunctions()).setError(uv: Application.window!.rootViewController!, title: "", content: messageStr)
            }
        }
    }

}
