//
//  Configurations.swift
//  DriverApp
//
//  Created by ADMIN on 21/09/16.
//  Copyright © 2016 BBCS. All rights reserved.
//

import UIKit

class Configurations: NSObject {
    
    static func isRTLMode() ->Bool {
        
        let languageType = UserDefaults.standard.value(forKey: Utils.LANGUAGE_IS_RTL_KEY)
        
        if(languageType != nil){
            let languageType_str = languageType as! String
            
            if(languageType_str.uppercased() == "RTL"){
                return true
            }
        }
        
        return false
    }
    
    static func getGoogleMapLngCode() -> String{
        let gMapLngCode = UserDefaults.standard.value(forKey: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY)
        
        if(gMapLngCode != nil){
            return ((gMapLngCode as! String).trim() != "" ? (gMapLngCode as! String) : "en")
        }
        return "en"
    }
    
    static func isUserLoggedIn() -> Bool{
        if(GeneralFunctions.getValue(key: Utils.isUserLogIn) == nil || GeneralFunctions.getMemberd() == ""){
            return false
        }
        return true
    }

    static func setAppLocal(){
        let languageCode: String = getGoogleMapLngCode()
        let defaults = UserDefaults.standard
        defaults.set([languageCode], forKey: "AppleLanguages")
        defaults.synchronize()
    }
    
//    static func configureRTLView(uv:UIViewController){
//        let languageType = UserDefaults.standard.value(forKey: Utils.LANGUAGE_IS_RTL_KEY)
//        
//        if(languageType != nil){
//            let languageType_str = languageType as! String
//            
//            if(languageType_str.uppercased() == "RTL"){
//                UIView.appearance().semanticContentAttribute = .forceRightToLeft
//            }else{
//                UIView.appearance().semanticContentAttribute = .forceLeftToRight
//            }
//        }else{
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//        }
//        
//    }
    
    static func getCalendarIdentifire() -> Calendar.Identifier{
        if(Configurations.getGoogleMapLngCode() == "ar"){
            return .islamic
        }else if(Configurations.getGoogleMapLngCode() == "fa"){
            return .persian
        }
        return .gregorian
    }
    
//    static func convertNumToAppLocal(numStr:String) -> String{
//        let formatter = NumberFormatter()
//        formatter.locale = Locale(identifier: Configurations.getGoogleMapLngCode())
//
//        let f = NumberFormatter()
//        f.numberStyle = .decimal
//        let num = f.number(from: numStr)
//        let numStr = numStr.replacingOccurrences(of: String(describing: num), with: formatter.string(from: num!)!)
//        
//        return numStr
//    }
    
    
    static func convertNumToAppLocal(numStr: String)->String{
        //let number = NSNumber(value: Int(num)!)
        
        //find numbers from string
        var final_numStr = ""
        
        for i in numStr.indices[numStr.startIndex..<numStr.endIndex]
        {
            let character = "\(numStr[i])"
            
            if(character.isNumeric()){
                
                let format = NumberFormatter()
                format.locale = Locale(identifier: Configurations.getGoogleMapLngCode())
                let number =   format.number(from: character)
                let faNumber = format.string(from: number!)
//                return faNumber!
                final_numStr = "\(final_numStr)\(faNumber!)"

            }else{
                final_numStr = "\(final_numStr)\(character)"
            }
        }
        return final_numStr
    }
    
    static func convertNumToEnglish(numStr: String)->String{
        
        var final_numStr = ""
        
        for i in numStr.indices[numStr.startIndex..<numStr.endIndex]
        {
            let character = "\(numStr[i])"
            
            let format = NumberFormatter()
            format.locale = Locale(identifier: "en")
            
            
            let number = format.number(from: character)
            
            if(number != nil){
                
                let faNumber = format.string(from: number!)
                //                return faNumber!
                final_numStr = "\(final_numStr)\(faNumber!)"
                
            }else{
                final_numStr = "\(final_numStr)\(character)"
            }
        }
        return final_numStr
        
//        let format = NumberFormatter()
//        format.locale = Locale(identifier: "en")
//        let number =   format.number(from: numStr)
//        let faNumber = format.string(from: number!)
//        return faNumber!
    }
    
    static func getInfoPlistValue(key:String) -> String{
        if(Bundle.main.path(forResource: "Info", ofType: "plist") == nil){
            return ""
        }
        
        let dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)
        
        return dict!.get(key)
    }
    
    
    static func getPlistValue(key:String, fileName:String) -> String{
        if(Bundle.main.path(forResource: fileName, ofType: "plist") == nil){
            return ""
        }
        
        let dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: fileName, ofType: "plist")!)
        
        return dict!.get(key)
    }
    
    static func getAppLocale() -> Locale{
    
      return  Locale(identifier: Configurations.getGoogleMapLngCode() )
    
    }
    
    
    static func isIponeXDevice() -> Bool{
        
        if(UIDevice().type == .iPhoneX || UIDevice().type == .iPhoneXR || UIDevice().type == .iPhoneXSmax || UIDevice().type == .iPhoneXS || (UIDevice().type == .simulator && (Application.screenSize.height == 812 || Application.screenSize.height == 896))){
            return true
        }
        
        return false
    }
    
    static func setAppThemeNavBar(){
        UINavigationBar.appearance().backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        UINavigationBar.appearance().barTintColor = UIColor.UCAColor.AppThemeColor
        UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.UCAColor.AppThemeTxtColor, NSAttributedString.Key.font: UIFont(name: Fonts().light, size: 20)!]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    static func setDefaultStatusBar(){
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    static func setLightStatusBar(){
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    static func clearSDMemory(){
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        //        SDImageCache.shared().cleanDisk()
    }
    
    static func getGoogleServerKey() -> String{
        let GOOGLE_SERVER_KEY = GeneralFunctions.getValue(key: Utils.GOOGLE_SERVER_IOS_DRIVER_APP_KEY)
        return GOOGLE_SERVER_KEY == nil ? "" : GOOGLE_SERVER_KEY as! String
    }
    
    static func getGoogleIOSKey() -> String{
        let GOOGLE_IOS_APP_KEY = GeneralFunctions.getValue(key: Utils.GOOGLE_IOS_DRIVER_APP_GEO_KEY)
        return GOOGLE_IOS_APP_KEY == nil ? "" : (GOOGLE_IOS_APP_KEY as! String)
    }
    
    static func isDevelopmentMode() -> Bool {
        #if IOS_SIMULATOR
            return true
        #else
            #if IS_DEBUG
                return true
            #else
                // there will be no provisioning profile in AppStore Apps
                guard let fileName = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") else {
                    return false
                }
        
                let fileURL = URL(fileURLWithPath: fileName)
                // the documentation says this file is in UTF-8, but that failed
                // on my machine. ASCII encoding worked ¯\_(ツ)_/¯
                guard let data = try? String(contentsOf: fileURL, encoding: .ascii) else {
                    return false
                }
        
                let cleared: String = data.components(separatedBy: .whitespacesAndNewlines).joined()
                return cleared.contains("<key>get-task-allow</key><true/>")
            #endif
        
        #endif
    }
}
