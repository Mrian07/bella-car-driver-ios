//
//  OpenLinkedinLogin.swift
//  PassengerApp
//
//  Created by Apple on 29/12/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OpenLinkedinLogin: NSObject, UIWebViewDelegate {

    typealias CompletionHandler = (_ response:String) -> Void
    
    var uv:UIViewController!
    var window:UIWindow!
    var currLinkedinInst:OpenLinkedinLogin!
    var activityIndicator:UIActivityIndicatorView!
    var webView:UIWebView!
    var contentView:UIView!
    var closeImgView:UIImageView!
   
    let generalFunc = GeneralFunctions()
    
    init(uv:UIViewController, window:UIWindow) {
        self.uv = uv
        self.window = window
        
        super.init()
    }
    
    func processData(currLinkedinInst: OpenLinkedinLogin){
        self.currLinkedinInst = currLinkedinInst
        
        if(InternetConnection.isConnectedToNetwork() == false){
            self.generalFunc.setError(uv: self.uv)
            return
        }
    
        contentView = UIView.init(frame:CGRect(x: 0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height))
        contentView.backgroundColor = UIColor.lightGray
        Application.window?.addSubview(contentView)
        
        activityIndicator = UIActivityIndicatorView.init(frame: CGRect(x: (Application.screenSize.width/2) - 15, y: (Application.screenSize.height/2) - 15, width: 30, height: 30))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        if #available(iOS 11.0, *) {
            webView = UIWebView.init(frame: CGRect(x: 15, y: (Configurations.isIponeXDevice() == true ? self.uv.view.safeAreaInsets.top + 20 : 20) + 25, width: Application.screenSize.width - 30, height: Application.screenSize.height - 20 - 60))
        } else {
            webView = UIWebView.init(frame: CGRect(x: 15, y: 20 + 25, width: Application.screenSize.width - 30, height: Application.screenSize.height - 20 - 60))
        }
        
        self.webView.scrollView.bounces = false
        self.webView.delegate = self
        self.webView.backgroundColor = UIColor.white
        
        contentView.addSubview(self.webView)
        contentView.addSubview(activityIndicator)
        
        self.clearWebViewCache()
        self.webView.loadRequest(URLRequest(url: URL(string: CommonUtils.linkedin_url)!))
        
        
        if (Configurations.isRTLMode() == true){
            if #available(iOS 11.0, *) {
                closeImgView = UIImageView.init(frame: CGRect(x: 5, y: (Configurations.isIponeXDevice() == true ? self.uv.view.safeAreaInsets.top + 20: 20) + 15, width: 30, height: 30))
            } else {
                closeImgView = UIImageView.init(frame: CGRect(x: 5, y: 20 + 15, width: 30, height: 30))
            }
        }else{
            if #available(iOS 11.0, *) {
                closeImgView = UIImageView.init(frame: CGRect(x: Application.screenSize.width - 35, y: (Configurations.isIponeXDevice() == true ? self.uv.view.safeAreaInsets.top + 20 : 20) + 12, width: 30, height: 30))
            } else {
                closeImgView = UIImageView.init(frame: CGRect(x: Application.screenSize.width - 35, y: 20 + 12, width: 30, height: 30))
            }
        }
        
        closeImgView.image = UIImage(named:"ic_linkdin_cancel")?.addImagePadding(x: 30, y: 30)
        contentView.addSubview(closeImgView)
        
        let cancelTapGue = UITapGestureRecognizer()
        cancelTapGue.addTarget(self, action: #selector(self.cancelViewTapped))
        closeImgView.isUserInteractionEnabled = true
        closeImgView.addGestureRecognizer(cancelTapGue)
        
    }
    
    func clearWebViewCache(){
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        webView.stringByEvaluatingJavaScript(from: "localStorage.clear();")
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
        UserDefaults.standard.synchronize()
    }
    
    @objc func cancelViewTapped(){
        
        self.contentView.removeFromSuperview()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let url : URL? = request.url
        
        
        DispatchQueue.main.async {
            self.webView.isUserInteractionEnabled = false
            self.activityIndicator.startAnimating()
        }
        let urlString : String = url!.absoluteString
        print(urlString)
        
        if (urlString.contains(find: "status=1")){
            DispatchQueue.main.async {
                self.webView.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
            }
            
            let dataStr = urlString.replace("\(CommonUtils.linkedin_url)?status=1&data=", withString: "")
            
            let dataStrJson = dataStr.decodeUrl()
            
            let dataDict = dataStrJson.getJsonDataDict()
            print("data::::\(dataStr.decodeUrl())")
            
            
            //                    Utils.printLog(msgData: "profileImageURL::\(profileImageURL)")
            self.executeProcess(vEmail: dataDict.get("emailAddress"), vFirstName: dataDict.get("firstName"), vLastName: dataDict.get("lastName"), vFbId: dataDict.get("id"), vImageURL: dataDict.get("pictureUrl"), jsonDataStr: dataStr)
            
        }else if (urlString.contains(find: "status=2")){
            DispatchQueue.main.async {
                self.webView.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
            }
            self.cancelViewTapped()
        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.webView.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func executeProcess(vEmail:String, vFirstName:String, vLastName:String, vFbId:String, vImageURL:String, jsonDataStr: String){
        
        let userSelectedCurrency = GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String
        let userSelectedLanguage = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
        
        let parameters = ["type":"LoginWithFB","vEmail": vEmail, "vFirstName": vFirstName,"vLastName": vLastName, "iFBId": vFbId, "vDeviceType": Utils.deviceType, "eLoginType": "LinkedIn", "UserType": Utils.appUserType, "vCurrency": userSelectedCurrency, "vLang": userSelectedLanguage, "vImageURL": vImageURL, "socialData": "\(jsonDataStr)"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.uv.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    _ = SetUserData(uv: self.uv, userProfileJson: dataDict, isStoreUserId: true)
                    
                    let window = UIApplication.shared.delegate!.window!
                    _ = OpenMainProfile(uv: self.uv, userProfileJson: response, window: window!)
                    
                }else{
                    if(dataDict.get(Utils.message_str) == "DO_REGISTER"){
                        
                        self.registerUser(vEmail: vEmail, vFirstName: vFirstName, vLastName: vLastName, vFbId: vFbId, vImageURL: vImageURL, jsonDataStr:jsonDataStr)
                        
                    }else{
                        self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                }
                
            }else{
                self.generalFunc.setError(uv: self.uv)
            }
        })
        
    }
    
    func registerUser(vEmail:String, vFirstName:String, vLastName:String, vFbId:String, vImageURL:String, jsonDataStr: String){
        
        let userSelectedCurrency = GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String
        let userSelectedLanguage = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
        
        let parameters = ["type":"signup","vFirstName": vFirstName, "vLastName": vLastName, "vEmail": vEmail, "vFbId": vFbId, "vDeviceType": Utils.deviceType, "vCurrency": userSelectedCurrency, "vLang": userSelectedLanguage, "eSignUpType": "LinkedIn", "UserType": Utils.appUserType, "vImageURL": vImageURL, "socialData":"\(jsonDataStr)"]
        
        //        , "vPhone": "", "vPassword": "", "PhoneCode": "", "CountryCode": "", "vInviteCode": ""
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.uv.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    _ = SetUserData(uv: self.uv, userProfileJson: dataDict, isStoreUserId: true)
                    
                    let window = UIApplication.shared.delegate!.window!
                    _ = OpenMainProfile(uv: self.uv, userProfileJson: response, window: window!)
                    
                }else{
                    self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self.uv)
            }
        })
    }
}
