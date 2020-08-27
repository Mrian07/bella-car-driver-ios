//
//  OpenCancelBookingView.swift
//  DriverApp
//
//  Created by Admin on 27/09/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OpenCancelBooking: NSObject {
    
    typealias CompletionHandler = (_ iCancelReasonId:String, _ reason:String) -> Void
    
    var uv:UIViewController!
    
    let generalFunc = GeneralFunctions()
    
    var bgView:UIView!
    var cancelBookingView:UIView!
        
    var cancelReasonsDataDict:NSDictionary!
    
    var superView:UIView!
    
    init(uv:UIViewController){
        self.uv = uv
        super.init()
    }
    
    func cancelTrip(eTripType:String, PAGE_TYPE:String, iTripId:String, iCabBookingId:String, handler: @escaping CompletionHandler){
        
        if(self.uv.navigationController != nil){
            superView = self.uv.navigationController!.view
        }else{
            superView = self.uv.view
        }
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.4
        bgView.frame = superView.frame
        
        bgView.center = CGPoint(x: superView.bounds.midX, y: superView.bounds.midY)
        
        let cancelBookingView = CancelBookingView(frame: CGRect(x: superView.frame.width / 2, y: superView.frame.height / 2, width: (Application.screenSize.width > 390 ? 375 : (Application.screenSize.width - 50)), height: 165))
        cancelBookingView.center = CGPoint(x: superView.bounds.midX, y: superView.bounds.midY)
        cancelBookingView.setViewHandler { (isViewClose, view, isPositiveBtnClicked, reason) in
            
            bgView.removeFromSuperview()
            cancelBookingView.removeFromSuperview()
            
            if(isPositiveBtnClicked){
                handler(cancelBookingView.tag != -1 ? "\(cancelBookingView.tag)" : "", reason)
            }
        }
        
        if(self.uv.navigationController != nil){
//        cancelBookingView.tag = Utils.ALERT_DIALOG_CONTENT_TAG
//        bgView.tag = Utils.ALERT_DIALOG_BG_TAG
        }
        
        cancelBookingView.tag = 0
        cancelBookingView.positiveLbl.isEnabled = false
        cancelBookingView.positiveLbl.isUserInteractionEnabled = false
        
        cancelBookingView.optionLbl.text = "-- \(self.generalFunc.getLanguageLabel(origValue: "Select Reason", key: "LBL_SELECT_CANCEL_REASON")) --"
        
        cancelBookingView.cancelBookingHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: eTripType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_CANCEL_DELIVERY" : (eTripType.uppercased() == Utils.cabGeneralType_UberX.uppercased() ? (PAGE_TYPE == "PENDING" ? "LBL_DECLINE_JOB" : "LBL_CANCEL_JOB") : "LBL_CANCEL_TRIP"))
        
        
        cancelBookingView.arrowImgView.transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
        GeneralFunctions.setImgTintColor(imgView: cancelBookingView.arrowImgView, color: .black)
        
        cancelBookingView.setOptionClickHandler { (view) in
            self.getCancelReasons(cancelBookingView, iTripId: iTripId, iCabBookingId: iCabBookingId)
        }
        Utils.createRoundedView(view: cancelBookingView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        cancelBookingView.enterReason.isHidden = true
        
        cancelBookingView.layer.shadowOpacity = 0.5
        cancelBookingView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cancelBookingView.layer.shadowColor = UIColor.black.cgColor
        
        superView.addSubview(bgView)
        superView.addSubview(cancelBookingView)
        
    }
    
    func getCancelReasons(_ cancelBookingView: CancelBookingView, iTripId:String, iCabBookingId:String){
        if(cancelReasonsDataDict == nil){
            let parameters = ["type": "GetCancelReasons", "iTripId": iTripId, "iCabBookingId": iCabBookingId, "iMemberId": GeneralFunctions.getMemberd(), "eUserType": Utils.appUserType]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.superView, isOpenLoader: true)
            exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
            exeWebServerUrl.currInstance = exeWebServerUrl
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.cancelReasonsDataDict = dataDict
                        
                        self.openCancelReansList(cancelBookingView)
                    }else{
                        self.generalFunc.setError(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                }else{
                    self.generalFunc.setError(uv: self.uv)
                }
            })
        }else{
            openCancelReansList(cancelBookingView)
        }
    }
    
    func openCancelReansList(_ cancelBookingView: CancelBookingView){
        var reasonList = [String]()
        var reasonIdList = [String]()
        
        reasonList.append("-- \(self.generalFunc.getLanguageLabel(origValue: "Select Reason", key: "LBL_SELECT_CANCEL_REASON")) --")
        reasonIdList.append("")
        
        let reasonData = cancelReasonsDataDict.getArrObj("message")
        for reason in reasonData{
            let reason_obj = reason as! NSDictionary
            reasonList.append(reason_obj.get("vTitle"))
            reasonIdList.append(reason_obj.get("iCancelReasonId"))
        }
        
        reasonList.append(self.generalFunc.getLanguageLabel(origValue: "Other", key: "LBL_OTHER_TXT"))
        reasonIdList.append("")
        
        let openListView = OpenListView(uv: self.uv, containerView: self.superView)
        
        openListView.show(listObjects: reasonList, title: self.generalFunc.getLanguageLabel(origValue: "Select Reason", key: "LBL_SELECT_CANCEL_REASON"), currentInst: openListView, handler: { (selectedItemId) in
            if(selectedItemId == 0){
                if(cancelBookingView.enterReason.isHidden == false){
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                        cancelBookingView.frame.size.height = cancelBookingView.frame.size.height - 60
                    })
                }
                cancelBookingView.enterReason.isHidden = true
                cancelBookingView.positiveLbl.isEnabled = false
                cancelBookingView.positiveLbl.isUserInteractionEnabled = false
                
                cancelBookingView.tag = 0
            }else if(selectedItemId == (reasonList.count - 1)){
                cancelBookingView.enterReason.isHidden = false
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    cancelBookingView.frame.size.height = 226
                })
                
                cancelBookingView.positiveLbl.isEnabled = true
                cancelBookingView.positiveLbl.isUserInteractionEnabled = true
                cancelBookingView.tag = -1
            }else{
                if(cancelBookingView.enterReason.isHidden == false){
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                        cancelBookingView.frame.size.height = cancelBookingView.frame.size.height - 60
                    })
                }
                
                cancelBookingView.positiveLbl.isEnabled = true
                cancelBookingView.positiveLbl.isUserInteractionEnabled = true
                cancelBookingView.enterReason.isHidden = true
                
                cancelBookingView.tag = GeneralFunctions.parseInt(origValue: 0, data: reasonIdList[selectedItemId])
                
            }
            cancelBookingView.optionLbl.text = reasonList[selectedItemId]
        })
    }
}
