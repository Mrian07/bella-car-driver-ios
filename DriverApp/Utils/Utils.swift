//
//  Utils.swift
//  DriverApp
//
//  Created by ADMIN on 03/12/16.
//  Copyright © 2016 BBCS. All rights reserved.
//

import UIKit
import GoogleMaps

class Utils: NSObject {
    
    /* **************************************************************************************** */
    /* fontFName Is Required, You can get Actual Font Family Name which is installed in Project by this method
     print(UIFont.familyNames) */
    
    static let fontFname = "Roboto"   //* REQUIRED *//   /* Print(UIFont.familyNames) */
    
    /* **************************************************************************************** */
    
    
    static let deviceType = "Ios"
    
    static var cabGeneralType_Ride = "Ride"
    static var cabGeneralType_Deliver = "Deliver"
    static var cabGeneralType_Ride_Deliver = "Ride-Delivery"
    static var cabGeneralType_UberX = "UberX"
    static var cabGeneralType_Ride_Delivery_UberX = "Ride-Delivery-UberX"

    static let vTripStatusParams_1 = "NONE"
    static let vTripStatusParams_2 = "Requesting"
    static let vTripStatusParams_3 = "Active"
    static let vTripStatusParams_4 = "On Going Trip"
    static let vTripStatusParams_5 = "Not Active"
    
    static let apnIDNotificationKey = "in.ubClone.ApnId"
    static let driverCallBackNotificationKey = "in.ubClone.DriverCallBack"
    static let appKilledNotificationKey = "in.ubClone.appKilled"
    static let appBGNotificationKey = "in.ubClone.appBG"
    static let appFGNotificationKey = "in.ubClone.appFG"
    
    static let PUBNUB_UPDATE_LOC_CHANNEL_PREFIX_DRIVER = "ONLINE_DRIVER_LOC_"
    
    static let TRIP_STATUS_MSG_PRFIX = "TRIP_STATUS_MSG_"
    
//    static let rtlLangTypeKey = "isRTL"
    static let googleMapLangCodeKey = "GOOGLE_MAP_LNG_CODE"
    static let deviceTokenKey = "DEVICE_TOKEN"
    
    static let APP_GCM_SENDER_ID_KEY = "GCM_SENDER_ID"
    
    static let PUBSUB_TECHNIQUE_KEY = "PUBSUB_TECHNIQUE"
    
    static let isUserLogIn = "IsUserLoggedIn"
    static let iMemberId_KEY = "iDriverId"
    
    static let action_str = "Action"
    static let message_str = "message"
    static let appUserType = "Driver"
    
    static let dailyRideCategoryType = "DAILYRIDES"
    static let rentalCategoryType = "RENTAL"
    
    static let passengerAppType = "Passenger"
    
    static let orderPickedupStatus = "OrderPickedup"
    static let orderDeliveredStatus = "OrderDelivered"
    static let appName = "Driver App"
    
    static let defaultZoomLevel:Float = 16.5
    
    static let SESSION_OUT_VIEW_TAG = 91 // should not be -1
    static let SESSION_OUT_COVER_VIEW_TAG = 92 // should not be -1
    
    
    static let DATABASE_RTL_STR = "rtl";
    
    static let dateFormateInHeaderBar = "EEE, MMM d, yyyy"
    static let dateFormateInList = "dd-MMM-yyyy"
    static let dateFormateTimeOnly = "h:mm a"
    static let dateFormateWithTime = "EEE, MMM dd, yyyy' \(GeneralFunctions().getLanguageLabel(origValue: "at", key: "LBL_AT_TXT")) 'h:mm a"
    
    static let languageLabelsKey = "LanguageLabel"
    static let FACEBOOK_APPID_KEY = "FACEBOOK_APPID"
    static let LINK_FORGET_PASS_KEY = "LINK_FORGET_PASS_PAGE_DRIVER"
    static let MOBILE_VERIFICATION_ENABLE_KEY = "MOBILE_VERIFICATION_ENABLE"
    static let LANGUAGE_LIST_KEY = "LANGUAGELIST"
    static let CURRENCY_LIST_KEY = "CURRENCYLIST"
    static let DEFAULT_LANGUAGE_TITLE_KEY = "DEFAULT_LANG_TITLE"
    static let DEFAULT_CURRENCY_TITLE_KEY = "DEFAULT_CURRENCY_TITLE"
    
    static let DRIVER_PHONE_VERIFICATION_KEY = "DRIVER_PHONE_VERIFICATION"
    
    static let LANGUAGE_CODE_KEY = "LANG_CODE"
    static let LANGUAGE_IS_RTL_KEY = "LANG_IS_RTL"
    static let GOOGLE_MAP_LANGUAGE_CODE_KEY = "GOOGLE_MAP_LANG_CODE"
    static let REFERRAL_SCHEME_ENABLE = "REFERRAL_SCHEME_ENABLE"
    static let SITE_TYPE_KEY = "SITE_TYPE"
    
    static let APPSTORE_MODE_IOS_KEY = "APPSTORE_MODE_IOS"
    
    static let OPEN_SETTINGS_URL_SCHEMA_KEY = "OPEN_SETTINGS_URL_SCHEMA"
    static let OPEN_LOCATION_SETTINGS_URL_SCHEMA_KEY = "OPEN_LOCATION_SETTINGS_URL_SCHEMA"
    
    static let FACEBOOK_LOGIN_KEY = "FACEBOOK_LOGIN"
    static let GOOGLE_LOGIN_KEY = "GOOGLE_LOGIN"
    static let TWITTER_LOGIN_KEY = "TWITTER_LOGIN"
    static let LINKDIN_LOGIN_KEY = "LINKEDIN_LOGIN"
    
    static let DEFAULT_COUNTRY_KEY = "DEFAULT_COUNTRY"
    static let DEFAULT_COUNTRY_CODE_KEY = "DEFAULT_COUNTRY_CODE"
    static let DEFAULT_PHONE_CODE_KEY = "DEFAULT_PHONE_CODE"
    
    static let GOOGLE_IOS_DRIVER_APP_GEO_KEY = "GOOGLE_IOS_DRIVER_APP_GEO_KEY"
    static let GOOGLE_SERVER_IOS_DRIVER_APP_KEY = "GOOGLE_SERVER_IOS_DRIVER_APP_KEY"
    
    static let SC_CONNECT_URL_KEY = "SC_CONNECT_URL"

    static let ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP_KEY = "ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP"
    static let DRIVER_ARRIVED_MIN_TIME_PER_MINUTE_KEY = "DRIVER_ARRIVED_MIN_TIME_PER_MINUTE"
    static let PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT_KEY = "PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT"
    
    static let PUBNUB_PUB_KEY = "PUBNUB_PUBLISH_KEY";
    static let PUBNUB_SUB_KEY = "PUBNUB_SUBSCRIBE_KEY";
    static let PUBNUB_SEC_KEY = "PUBNUB_SECRET_KEY";
    static let pubNub_Update_Loc_Channel_Prefix = "ONLINE_DRIVER_LOC_";
    static let DEVICE_SESSION_ID_KEY = "DEVICE_SESSION_ID"
    static let SESSION_ID_KEY = "APP_SESSION_ID"
    
    static let IS_WALLET_AMOUNT_UPDATE_KEY = "IS_WALLET_AMOUNT_UPDATE"
    
    static let USER_PROFILE_DICT_KEY = "USER_PROFILE_DICT"
    
    static let FETCH_TRIP_STATUS_TIME_INTERVAL_KEY = "FETCH_TRIP_STATUS_TIME_INTERVAL"
    
    static let RIDER_REQUEST_ACCEPT_TIME_KEY = "RIDER_REQUEST_ACCEPT_TIME"
    
    static let DRIVER_CURRENT_REQ_OPEN_KEY = "DRIVER_REQ_OPEN"
    
    static let passengerRequestArrived = "in.ubClonePartner.CabRequested"
    static let tripRequestCanceled = "in.ubClonePartner.tripCanceled"
    static let tripDestinationAdded = "in.ubClonePartner.tripDestAdded"
    
    static let releaseAllTaskObserverKey = "in.ubcApp.releaseAllTask"
    static let rtlLangTypeKey = "isRTL"
    static let DRIVER_REQ_CODE_PREFIX_KEY = "REQUEST_CODE_"
    
    static let ALERT_DIALOG_BG_TAG = 987
    static let ALERT_DIALOG_CONTENT_TAG = 999
    
    static let WINDOW_ALERT_DIALOG_BG_TAG = 988
    static let WINDOW_ALERT_DIALOG_CONTENT_TAG = 990
    
    static let ImageUpload_DESIREDWIDTH:CGFloat = 1024
    static let ImageUpload_DESIREDHEIGHT:CGFloat = 1024
    static let ImageUpload_MINIMUM_WIDTH:CGFloat = 256
    static let ImageUpload_MINIMUM_HEIGHT:CGFloat = 256
    
    static let minPasswordLength = 6
    static let minMobileLength = 3
    
    static var driverMarkersPositionList = [NSDictionary]()
    static var driverMarkerAnimFinished = true
    
    static func applicationVersion() -> String {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
   static func applicationBuild() -> String {
        
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
   static func versionBuild() -> String {
        
        let version = applicationVersion()
        let build = applicationBuild()
        
        return "v\(version)(\(build))"
    }
    
    static func checkText(textField:UITextField) -> Bool{
        if(getText(textField: textField).trim() == ""){
            return false
        }
        
        return true
    }
    
    static func getText(textField:UITextField) -> String{
        return textField.text!
    }
    
    static func setErrorFields(textField:ErrorTextField, error:String) -> Bool{
        textField.detail = error
        textField.isErrorRevealed = true
        return false
    }
    
    static func createRoundedView(view:UIView, borderColor:UIColor, borderWidth:CGFloat){
        view.layer.cornerRadius = view.frame.size.width / 2;
        view.clipsToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
    }
    
    static func createRoundedView(view:UIView, borderColor:UIColor, borderWidth:CGFloat, cornerRadius:CGFloat){
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
    }
    
    static func createBoarderedView(view:UIView, borderColor:UIColor, borderWidth:CGFloat){
        view.clipsToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
    }
    
    static func printNsData(someNSData:Data){
        let theString:NSString = NSString(data: someNSData, encoding: String.Encoding.utf8.rawValue)!
//        print(theString)
        
        Utils.printLog(msgData: theString.description)
    }
    
    static func showSnakeBar(msg:String, uv:UIViewController){
        
        guard let snackbar = uv.snackbarController?.snackbar else {
            return
        }
        
        snackbar.text = msg
        
        snackbar.rightViews = [UIView()]
        _ = uv.snackbarController?.animate(snackbar: .visible, delay: 1)
        _ = uv.snackbarController?.animate(snackbar: .hidden, delay: 4)
    }
    
    static func showSnakeBar(msg:String, uv:UIViewController, btnTitle:String, delayShow:TimeInterval, delayHide:TimeInterval) -> FlatButton{
        
        var actionButton = FlatButton()
        guard let snackbar = uv.snackbarController?.snackbar else {
            return actionButton
        }
        
        snackbar.text = msg
        
        
        if(btnTitle != ""){
            
            actionButton = FlatButton(title: btnTitle, titleColor: Color.yellow.base)
            actionButton.pulseAnimation = .backing
            actionButton.titleLabel?.font = uv.snackbarController?.snackbar.textLabel.font
            
            snackbar.rightViews = [actionButton]
        }
        _ = uv.snackbarController?.animate(snackbar: .visible, delay: delayShow)
        _ = uv.snackbarController?.animate(snackbar: .hidden, delay: delayHide)
        
        return actionButton
    }
    
//    static func updateMarker(marker:GMSMarker,googleMap:GMSMapView, coordinates: CLLocationCoordinate2D, rotationAngle: Double, duration: Double) {
//        // Keep Rotation Short
////        CATransaction.begin()
////        CATransaction.setAnimationDuration(0.5)
////        marker.rotation = rotationAngle
////        CATransaction.commit()
//        
//        // Movement
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(duration)
//        marker.position = coordinates
//        
//        // Center Map View
//        //        let camera = GMSCameraUpdate.setTarget(coordinates)
//        //        googleMap.animate(with: camera)
//        
//        CATransaction.commit()
//    }
    
    static func updateMarker(marker:GMSMarker,googleMap:GMSMapView, coordinates: CLLocationCoordinate2D, rotationAngle: Double, duration: Double) {
        // Keep Rotation Short
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        marker.rotation = rotationAngle
        CATransaction.commit()
        
        // Movement
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        marker.position = coordinates
        
        CATransaction.commit()
    }
    
    static func appLoginImage() -> UIImage
    {
        let imagePath = "\(Bundle.main.resourcePath!)/AppLoginLaunchImage.launchimage"
        let fileManager = FileManager.default
        _ = try! fileManager.contentsOfDirectory(atPath: imagePath)
        
        let allPngImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "AppLoginLaunchImage.launchimage")
        
        
        for imageName in allPngImageNames
        {
            
//            Utils.printLog(msgData: "imageName::\(imageName)")
            guard let image = UIImage(named: imageName) else { continue }
            
//            Utils.printLog(msgData: "ImageScale=\(image.scale)")
//            Utils.printLog(msgData: "ScreenScale=\( UIScreen.main.scale)")
//            Utils.printLog(msgData: "ImageSize:\(image.size.width)::\(image.size.height)")
//            Utils.printLog(msgData: "ScreenSize:\(Application.screenSize.width)::\(Application.screenSize.height)")
            if (image.size.width == (Application.screenSize.width * UIScreen.main.scale) && image.size.height == (Application.screenSize.height * UIScreen.main.scale)){
                return image
            }else if(image.size.width == 1242 && image.size.height == 2208 && Application.screenSize.width == 375  && Application.screenSize.height == 667 ){
                return image
            }
        }
        
        switch UIDevice().type {
        case .iPhone4:
            return UIImage(named: "ic_launch@640x960")!
        case .iPhone4S:
            return UIImage(named: "ic_launch@640x960")!
        case .iPhone5:
            return UIImage(named: "ic_launch@640x1136")!
        case .iPhone5S:
            return UIImage(named: "ic_launch@640x1136")!
        case .iPhone6:
            return UIImage(named: "ic_launch@750x1334")!
        case .iPhone6plus:
            return UIImage(named: "ic_launch@1242x2208")!
        case .iPhone6S:
            return UIImage(named: "ic_launch@750x1334")!
        case .iPhone6Splus:
            return UIImage(named: "ic_launch@1242x2208")!
        case .iPhone7:
            return UIImage(named: "ic_launch@750x1334")!
        case .iPhone7plus:
            return UIImage(named: "ic_launch@1242x2208")!
        case .iPhoneSE:
            return UIImage(named: "ic_launch@640x1136")!
        case .iPhoneX:
            return UIImage(named: "ic_launch@1125x2436")!
        case .iPhoneXR:
            return UIImage(named: "ic_launch@828x1792")!
        case .iPhoneXSmax:
            return UIImage(named: "ic_launch@1242x2688")!
        case .iPhoneXS:
            return UIImage(named: "ic_launch@1125x2436")!
        default:
            return UIImage(named: "ic_launch")!
        }
    }
    
    static func appLaunchImage() -> UIImage
    {
        let allPngImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
        
        for imageName in allPngImageNames
        {
            guard imageName.contains("LaunchImage") else { continue }
            
            guard let image = UIImage(named: imageName) else { continue }
            
            // if the image has the same scale AND dimensions as the current device's screen...
            
            if (image.scale == UIScreen.main.scale) && (image.size.equalTo(UIScreen.main.bounds.size))
            {
                return image
            }else if(image.size.width == 1242 && image.size.height == 2208 && Application.screenSize.width == 375  && Application.screenSize.height == 667 ){
                return image
            }
        }
        
        switch UIDevice().type {
        case .iPhone4:
            return UIImage(named: "ic_launch@640x960")!
        case .iPhone4S:
            return UIImage(named: "ic_launch@640x960")!
        case .iPhone5:
            return UIImage(named: "ic_launch@640x1136")!
        case .iPhone5S:
            return UIImage(named: "ic_launch@640x1136")!
        case .iPhone6:
            return UIImage(named: "ic_launch@750x1334")!
        case .iPhone6plus:
            return UIImage(named: "ic_launch@1242x2208")!
        case .iPhone6S:
            return UIImage(named: "ic_launch@750x1334")!
        case .iPhone6Splus:
            return UIImage(named: "ic_launch@1242x2208")!
        case .iPhone7:
            return UIImage(named: "ic_launch@750x1334")!
        case .iPhone7plus:
            return UIImage(named: "ic_launch@1242x2208")!
        case .iPhoneSE:
            return UIImage(named: "ic_launch@640x1136")!
        case .iPhoneX:
            return UIImage(named: "ic_launch@1125x2436")!
        case .iPhoneXR:
            return UIImage(named: "ic_launch@828x1792")!
        case .iPhoneXSmax:
            return UIImage(named: "ic_launch@1242x2688")!
        case .iPhoneXS:
            return UIImage(named: "ic_launch@1125x2436")!
        default:
            return UIImage(named: "ic_launch")!
        }
    }
    
    static func getCurrentDateInAppLocal(dateFormat:String, timeZone:String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = Calendar(identifier: .gregorian)
        let date = Date()
        formatter.timeZone = TimeZone(identifier: timeZone)
        let dateInGrogrian = formatter.string(from: date)
        
        let appLocalDate = Utils.convertDateGregorianToAppLocale(date: dateInGrogrian, dateFormate: dateFormat)
        
        return appLocalDate
    }
    
    static func convertDateToFormate(date:Date, formate:String) -> String{
        
        let finalFormatter = DateFormatter()
        finalFormatter.dateFormat = formate
        
        let finalDate = finalFormatter.string(from: date)
        
        return finalDate
    }
    
    static func convertStringToDate(dateStr:String, dateFormat:String) -> Date{
        let finalFormatter = DateFormatter()
        finalFormatter.dateFormat = dateFormat
//        finalFormatter.timeZone = TimeZone(abbreviation: "GMT")!
        let finalDate = finalFormatter.date(from: dateStr)
        
        if(finalDate == nil){
            return Date()
        }
        return finalDate!
    }
    
    static func convertDateFormateInAppLocal(date:Date, toDateFormate:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = toDateFormate
        
        formatter.locale = Locale(identifier: Configurations.getGoogleMapLngCode())
        
        return formatter.string(from: date)
    }
    
    static func convertDateGregorianToAppLocale(date:String, dateFormate:String) -> Date{

        if(date == ""){
            return Date()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormate
        formatter.calendar = Calendar(identifier: .gregorian)
        let dateInGrogrian = formatter.date(from: date)
        
        if(dateInGrogrian == nil){
            return Date()
        }
        
        formatter.calendar = Calendar(identifier: Configurations.getCalendarIdentifire())
        
        let dateStr = formatter.string(from: dateInGrogrian!)
        
        return Utils.convertStringToDate(dateStr: dateStr, dateFormat: dateFormate)
    }
    
    static func getCurrentDateInGrogrian(dateFormat:String, timeZone:String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = Calendar(identifier: .gregorian)
        let date = Date()
        
        formatter.timeZone = TimeZone(identifier: timeZone)
        let dateInGrogrian = formatter.string(from: date)
        
        return convertStringToDate(dateStr: dateInGrogrian, dateFormat: dateFormat)
    }
    
    static func printLog(msgData:String){
        print(msgData)
    }
    
    static func currentTimeMillis() -> Int64{
        let nowDouble = Date().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
    static func isMyAppInBackground() -> Bool{
        let state: UIApplication.State = UIApplication.shared.applicationState
        
        if state == UIApplication.State.background {
            return true
        }
        else{
            return false
        }
        //        else if state == UIApplicationState.Active {
        //
        //            return false
        //        }
    }
    
    
    static func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    static func updateMarkerOnTrip(marker:GMSMarker,googleMap:GMSMapView, coordinates: CLLocationCoordinate2D, rotationAngle: Double, duration: Double, iDriverId:String, LocTime:String) {
        
        
        
        // Movement
        CATransaction.begin()
        Utils.driverMarkerAnimFinished = false
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock({
            Utils.driverMarkerAnimFinished = true
            
            Utils.removeBufferedLocation(iDriverId: iDriverId, LocTime: LocTime)
            
            let tempData = getNextBufferedLocationData(marker: marker)
            
            if(tempData != nil){
                let tempData = tempData! as NSDictionary
                let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tempData.get("vLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tempData.get("vLongitude")))
                
//                let newDuration = driverMarkersPositionList.count > 0 ? (duration / Double(driverMarkersPositionList.count * 4)) : duration
                
                Utils.updateMarkerOnTrip(marker: marker, googleMap: googleMap, coordinates: location.coordinate, rotationAngle: GeneralFunctions.parseDouble(origValue: 0.0, data: tempData.get("RotationAngle")), duration: duration, iDriverId: tempData.get("iDriverId"), LocTime: tempData.get("LocTime"))
                
                
            }
            
            
        })
        if(rotationAngle != -1){
            marker.rotation = rotationAngle
        }
        marker.position = coordinates
        
        // Center Map View
        //        let camera = GMSCameraUpdate.setTarget(coordinates)
        //        googleMap.animate(with: camera)
        
        CATransaction.commit()
    }
    
    static func getCurrentMarkerPositionCount(marker:GMSMarker) -> Int{
        
        if(marker.title == nil || marker.title! == ""){
            return 0
        }
        
        var count = 0
        
        for i in 0..<driverMarkersPositionList.count{
            let item = driverMarkersPositionList[i]
            if(item.get("iDriverId") == marker.title!.replace("DriverId", withString: "")){
                count = count + 1
            }
        }
        
        return count
    }
    
    static func removeBufferedLocation(position:String){
        
        let position_final = GeneralFunctions.parseInt(origValue: -1, data: position)
        if(position_final != -1 && driverMarkersPositionList.count > position_final){
            driverMarkersPositionList.remove(at: position_final)
        }
    }
    
    static func removeBufferedLocation(iDriverId:String, LocTime:String){
        
        for i in 0..<driverMarkersPositionList.count{
            let item = driverMarkersPositionList[i]
            if(item.get("iDriverId") == iDriverId && item.get("LocTime") == LocTime){
                Utils.removeBufferedLocation(position: "\(i)")
                break
            }
        }
    }
    
    static func getNextBufferedLocationData(marker:GMSMarker) -> [String:String]?{
        
        for i in 0..<driverMarkersPositionList.count{
            let item = driverMarkersPositionList[i]
            if(item.get("iDriverId") == marker.title!.replace("DriverId", withString: "")){
                var tempItem = item as! [String:String]
                tempItem["Position"] = "\(i)"
                return tempItem
            }
        }
        
        return nil
    }
    
    static func getCurrentMarkerPosition(marker:GMSMarker) -> Int{
        
        if(marker.title == nil || marker.title! == ""){
            return -1
        }
        
        for i in 0..<driverMarkersPositionList.count{
            let item = driverMarkersPositionList[i]
            if(item.get("iDriverId") == marker.title!.replace("DriverId", withString: "")){
                return i
            }
        }
        
        return -1
    }
    
    static func getLastLocationDataOfMarker(marker:GMSMarker) -> NSDictionary{
        if(marker.title == nil || marker.title! == ""){
            return NSDictionary()
        }
        
        let lastIndex = driverMarkersPositionList.count - 1
        
        for i in 0..<driverMarkersPositionList.count{
            let item = driverMarkersPositionList[lastIndex - i]
            if(item.get("iDriverId") == marker.title!.replace("DriverId", withString: "")){
                return item
            }
        }
        
        return NSDictionary()
    }
    
    static func resetAppNotifications(){
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
//    static func convertDateToString(date:Date, dateFormate:String) -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = dateFormate
//        return dateFormatter.string(from: date)
//    }
//    
//    static func convertStringToDate(date:String, dateFormate:String) -> Date{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = dateFormate
//        return dateFormatter.date(from: date)!
//    }
//    
//    static func convertDateToTimeZone(date:String, dateFormate:String, fromTimeZone:String, toTimeZone:String){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = dateFormate
//        dateFormatter.timeZone = TimeZone(abbreviation: fromTimeZone)
//        
//        let date = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone(abbreviation: toTimeZone)
//        dateFormatter.dateFormat = dateFormate
//        
//        print("BeforeStringDate:\(date)")
//        let dt = dateFormatter.string(from: date!)
//        print("AfterStringDate:\(dt)")
//        
//    }
//    static func localToUTC(date:String, dateFormat:String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.calendar = NSCalendar.current
//        dateFormatter.timeZone = TimeZone.current
//        
//        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        return dateFormatter.string(from: dt!)
//    }
//    
//    static func UTCToLocal(date:String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "H:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        
//        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = "h:mm a"
//        
//        return dateFormatter.string(from: dt!)
//    }
    
    static func closeKeyboard(uv:UIViewController?){
        if (Application.window != nil)
        {
            Application.window?.endEditing(true)
        }
        else if(uv != nil)
        {
            uv!.view.endEditing(true)
        }
    }
    
    static func removeAppInactiveStateNotifications(){
        let notificationArr = UIApplication.shared.scheduledLocalNotifications
        
        if(notificationArr != nil){
            for i in 0..<notificationArr!.count{
                let notification = notificationArr![i] as UILocalNotification
                
                if(notification.userInfo != nil && notification.userInfo!["APP_INACTIVE_STATE_NOTIFICATION"] != nil){
                    UIApplication.shared.cancelLocalNotification(notification)
                }
            }
        }
    }
    
    static func addAppInactiveStateNotification(seconds:Int){
        
        var userInfo = [String:String]()
        userInfo["APP_INACTIVE_STATE_NOTIFICATION"] = "Yes"
        LocalNotification.dispatchlocalNotification(with: "", body: (GeneralFunctions()).getLanguageLabel(origValue: "App is inactive. You may no longer to receive any updates.", key: "LBL_APP_INACTIVE_STATE_ALERT_NOTIFICATION"), userInfo: userInfo, at: Date().addedBy(seconds: seconds))
    }
    
    static func deviceInfo() -> String {
        
        let currentDevice = UIDevice.current
        let dictDevice = ["Name" : currentDevice.name,"IOSVersion" : currentDevice.systemVersion,"Model" : currentDevice.type.rawValue, "IdentifierForVendor" : currentDevice.identifierForVendor!.description]
        let strDevice = (dictDevice as NSDictionary).convertToJson()
        
        return strDevice
    }
    
    static func getDeviceCountryCode() -> String{
        if(Locale.current.regionCode != nil){
            return Locale.current.regionCode!
        }
        
        return ""
    }
    
    static func getWidthOfBanner(widthOffset:CGFloat) -> CGFloat{
        return Application.screenSize.width - widthOffset
    }
    
    static func getHeightOfBanner(widthOffset:CGFloat, ratio:String) -> CGFloat{
        if(ratio == "4:3"){
            return (Utils.getWidthOfBanner(widthOffset: widthOffset) / 1.33333333333)
        }
        return (Utils.getWidthOfBanner(widthOffset: widthOffset) / 1.77777778)
    }
    
    static func getValueInPixel(value:CGFloat) -> Int{
        return Int(value * UIScreen.main.scale)
    }
    
    static func getResizeImgURL(imgUrl:String, width:Int, height:Int) -> String{
        let imgURL_final = imgUrl.replace(" ", withString: "%20")
        let resizeUrl = "\(CommonUtils.webServer)resizeImg.php?src=\(imgURL_final)&w=\(width)&h=\(height)"
        return resizeUrl
    }
    
    static func getResizeImgURL(imgUrl:String, width:Int, height:Int, MAX_WIDTH:Int) -> String{
        let imgURL_final = imgUrl.replace(" ", withString: "%20")
        let resizeUrl = "\(CommonUtils.webServer)resizeImg.php?src=\(imgURL_final)&w=\(width)&h=\(height)&IMG_MAX_WIDTH=\(MAX_WIDTH)"
        return resizeUrl
    }
    
    static func getResizeImgURL(imgUrl:String, width:Int, height:Int, MAX_HEIGHT:Int) -> String{
        let imgURL_final = imgUrl.replace(" ", withString: "%20")
        let resizeUrl = "\(CommonUtils.webServer)resizeImg.php?src=\(imgURL_final)&w=\(width)&h=\(height)&IMG_MAX_HEIGHT=\(MAX_HEIGHT)"
        return resizeUrl
    }
    
    static func getResizeImgURL(imgUrl:String, width:Int, height:Int, MAX_WIDTH:Int, MAX_HEIGHT:Int) -> String{
        let imgURL_final = imgUrl.replace(" ", withString: "%20")
        let resizeUrl = "\(CommonUtils.webServer)resizeImg.php?src=\(imgURL_final)&w=\(width)&h=\(height)&IMG_MAX_WIDTH=\(MAX_WIDTH)&IMG_MAX_WIDTH=\(MAX_HEIGHT)"
        return resizeUrl
    }
    
    static func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func formateSecondsToHours(seconds:String) -> String{
        
        let generalFunc = GeneralFunctions()
        
        var secondsValue = Int(GeneralFunctions.parseDouble(origValue: 0, data: seconds))
        
        if(secondsValue < 60){
            secondsValue = 60
        }
        
        let (h,m,_) = Utils.secondsToHoursMinutesSeconds(seconds: secondsValue)
        
        var formattedText = ""
        
        if(h > 0){
            formattedText = "\(h)"
        }
        
        if(m > 0){
            //            let minute = m < 10 ? "0\(m)" : "\(m)"
            let minute = "\(m)"
            formattedText = "\(formattedText)\(h > 0 ? ":\(minute)" : "\(minute)")"
        }
        
        if(h > 0){
            formattedText = "\(formattedText) \(generalFunc.getLanguageLabel(origValue: "", key: h > 1 ? "LBL_HOURS_TXT" : "LBL_HOUR_TXT").lowercased())"
        }else{
            formattedText = "\(formattedText) \(generalFunc.getLanguageLabel(origValue: "", key: m > 1 ? "LBL_MINS_SMALL" : "LBL_MIN_SMALL").lowercased())"
        }
        
        return formattedText
    }
    
    static func getFontWeightList(familyName:String) -> [String]{
        
        var lightDetected = false
        var regularDetected = false
        var mediumDetected = false
        var boldDetected = false
        var lightWeight = 0.0
        var fontFamilyArray = ["Roboto-Light", "Roboto-Regular", "Roboto-Medium", "Roboto-Bold"]
        for fontName in UIFont.fontNames(forFamilyName: familyName){
            let font = UIFont.init(name: fontName, size: 14)
            if(font?.isItalic ?? false){
                continue
            }
            let font2 =  UIFont.systemFont(ofSize: 14, weight: font?.weight ?? UIFont.Weight(rawValue: 0.0))
            
            let fontAttributeKey = UIFontDescriptor.AttributeName.init(rawValue: "NSCTFontUIUsageAttribute")
            if let fontWeight = font2.fontDescriptor.fontAttributes[fontAttributeKey] as? String{
                
                if(fontWeight == "CTFontLightUsage"){
                    var newWeight = 0.0
                    if(lightWeight != 0.0){
                        newWeight = Double((font?.weight)!.rawValue)
                    }
                    if(Double((font?.weight)!.rawValue) < 0.0 && lightWeight == 0.0){
                        lightWeight = Double((font?.weight)!.rawValue)
                    }
                    if(lightWeight > newWeight){
                        continue
                    }
                    fontFamilyArray.remove(at: 0)
                    fontFamilyArray.insert(fontName, at: 0)
                    lightDetected = true
                }else if (fontWeight == "CTFontRegularUsage"){
                    fontFamilyArray.remove(at: 1)
                    fontFamilyArray.insert(fontName, at: 1)
                    regularDetected = true
                }else if (fontWeight == "CTFontMediumUsage" || fontWeight == "CTFontDemiUsage"){
                    fontFamilyArray.remove(at: 2)
                    fontFamilyArray.insert(fontName, at: 2)
                    mediumDetected = true
                }else if (fontWeight == "CTFontBoldUsage"){
                    fontFamilyArray.remove(at: 3)
                    fontFamilyArray.insert(fontName, at: 3)
                    boldDetected = true
                }
            }
        }
        
        if(lightDetected == false && regularDetected == true){
            let regular = fontFamilyArray[1]
            fontFamilyArray.remove(at: 0)
            fontFamilyArray.insert(regular, at: 0)
        }
        if (mediumDetected == false && regularDetected == true){
            let regular = fontFamilyArray[1]
            fontFamilyArray.remove(at: 2)
            fontFamilyArray.insert(regular, at: 2)
        }
        if (boldDetected == false && boldDetected == true){
            let regular = fontFamilyArray[1]
            fontFamilyArray.remove(at: 3)
            fontFamilyArray.insert(regular, at: 3)
        }
        
        return fontFamilyArray
        
    }
}
