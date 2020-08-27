//
//  OpenMainProfile.swift
//  DriverApp
//
//  Created by ADMIN on 11/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces

class OpenMainProfile: NSObject {
    
    var window :UIWindow!
    var viewControlller:UIViewController!
    var userProfileJson:String!
    let generalFunc = GeneralFunctions()
    
    init(uv: UIViewController, userProfileJson:String, window :UIWindow) {
        self.viewControlller = uv
        self.userProfileJson = userProfileJson
        self.window = window
        super.init()
        
        openProfile()
    }
    
    func openProfile(){
//        changeRootViewController
        
        saveData()
        
        GeneralFunctions.removeAllAlertViewFromNavBar(uv: self.viewControlller)
        
        GeneralFunctions.removeAlertViewFromWindow(viewTag: Utils.WINDOW_ALERT_DIALOG_CONTENT_TAG, coverViewTag: Utils.WINDOW_ALERT_DIALOG_BG_TAG)
        
        Configurations.setAppLocal()
        
        let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "HomeScreenContainerUV") as! HomeScreenContainerUV
        
        
//        if(window.rootViewController != nil && window.rootViewController!.navigationController != nil){
//            window.rootViewController!.navigationController?.popToRootViewController(animated: false)
//            window.rootViewController!.navigationController?.dismiss(animated: false, completion: nil)
//        }else if(window.rootViewController != nil){
//            window.rootViewController?.dismiss(animated: false, completion: nil)
//        }
        
        
//        let windowSubViews = self.window.subviews
//        
//        for i in 0..<windowSubViews.count{
//            let subView = windowSubViews[i]
//            subView.removeFromSuperview()
//        }
        
        
//        let userData = NSKeyedArchiver.archivedData(withRootObject: GeneralFunctions.removeNullsFromDictionary(origin: userProfileJson as! [String : AnyObject]) )
        
        GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: userProfileJson as AnyObject)
        
        let userProfileJsonDict = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        /* SINCH VOIP CALLING.*/
        if userProfileJsonDict.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
            SinchCalling.getInstance().initSinchClient()
            if UserDefaults.standard.object(forKey: "SINCHCALLING") != nil &&  GeneralFunctions.getValue(key: "SINCHCALLING") as! Bool == true{
                return
            }
        }
        
        if(userProfileJsonDict.get("vEmail") == "" || userProfileJsonDict.get("vPhone") == ""){
            let accountInfoUV = GeneralFunctions.instantiateViewController(pageName: "AccountInfoUV") as! AccountInfoUV
            let navigationController = UINavigationController(rootViewController: accountInfoUV)
            navigationController.navigationBar.isTranslucent = false
            
            UIView.transition(with: self.window,
                              duration: 0.25,
                              options: .showHideTransitionViews,
                              animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                
            } ,
                              completion: nil)
            

            return
        }
        
        
        let vTripStatus = userProfileJsonDict.get("vTripStatus")
        var lastTripExist = false
        
        var ratings_From_Driver = ""
        if userProfileJsonDict.get("eSystem") == "DeliverAll"
        {
            ratings_From_Driver = userProfileJsonDict.get("Ratings_From_Driver")
            
            
            if(ratings_From_Driver != "Done" && ratings_From_Driver != ""){
                lastTripExist = true
            }
            
        }else
        {
            if(vTripStatus == "Not Active"){
                ratings_From_Driver = userProfileJsonDict.get("Ratings_From_Driver")
                
                if(ratings_From_Driver != "Done"){
                    lastTripExist = true
                }
            }
        }
      
        if (vTripStatus != "" && vTripStatus != "NONE"  && vTripStatus != "Cancelled"
            && (vTripStatus == "Active" || vTripStatus == "On Going Trip"
                || vTripStatus == "Arrived" || lastTripExist == true)) {
        
            let last_trip_data = userProfileJsonDict.getObj("TripDetails")
            let passenger_data = userProfileJsonDict.getObj("PassengerDetails")
            
           
            let dataParams = ["Message":"CabRequested", "sourceLatitude": last_trip_data.get("tStartLat"), "sourceLongitude": last_trip_data.get("tStartLong"), "PassengerId": last_trip_data.get("iUserId"), "PName": "\(passenger_data.get("vName"))", "PPicName": "\(passenger_data.get("vImgName"))", "PFId": "\(passenger_data.get("vFbId"))", "PRating": "\(passenger_data.get("vAvgRating"))", "PPhone": "\(passenger_data.get("vPhone"))", "PPhoneC": "\(passenger_data.get("vPhoneCode"))", "PAppVersion": "\(passenger_data.get("iAppVersion"))", "TripId": "\(last_trip_data.get("iTripId"))", "DestLocLatitude": "\(last_trip_data.get("tEndLat"))", "DestLocLongitude": "\(last_trip_data.get("tEndLong"))", "DestLocAddress": "\(last_trip_data.get("tDaddress"))", "REQUEST_TYPE": "\(last_trip_data.get("eType"))", "vDeliveryConfirmCode": "\(last_trip_data.get("vDeliveryConfirmCode"))", "SITE_TYPE": "\(userProfileJsonDict.get("SITE_TYPE"))", "eTollSkipped": "\(last_trip_data.get("eTollSkipped"))", "eHailTrip": "\(last_trip_data.get("eHailTrip"))", "eFareType": "\(last_trip_data.get("eFareType"))", "TimeState": "\(userProfileJsonDict.get("TimeState"))", "TotalSeconds": "\(userProfileJsonDict.get("TotalSeconds"))", "iTripTimeId": "\(userProfileJsonDict.get("iTripTimeId"))", "tUserComment": "\(last_trip_data.get("tUserComment"))", "eBeforeUpload": "\(last_trip_data.get("eBeforeUpload"))", "eAfterUpload": "\(last_trip_data.get("eAfterUpload"))", "tSaddress": "\(last_trip_data.get("tSaddress"))", "tDaddress": "\(last_trip_data.get("tDaddress"))", "eType": "\(last_trip_data.get("eType"))","vReceiverMobile":last_trip_data.get("vReceiverMobile"),"vReceiverName":last_trip_data.get("vReceiverName"),"Running_Delivery_Txt":last_trip_data.get("Running_Delivery_Txt"),"iTripDeliveryLocationId":last_trip_data.get("iTripDeliveryLocationId"),"PaymentPerson":last_trip_data.get("PaymentPerson"), "ePaymentByReceiverForDelivery":last_trip_data.get("ePaymentByReceiverForDelivery"), "eIconType" : "\(last_trip_data.get("eIconType"))", "iOrderId": "\(last_trip_data.get("iOrderId"))" , "LastOrderUserName" : "\(userProfileJsonDict.get("LastOrderUserName"))" , "LastOrderNo" : "\(userProfileJsonDict.get("LastOrderNo"))" , "LastOrderAmount" : "\(userProfileJsonDict.get("LastOrderAmount"))", "vLastName": "\(passenger_data.get("vLastName"))", "ePoolRide":last_trip_data.get("ePoolRide"), "iPersonSize":last_trip_data.get("iPersonSize"),"eBookingFrom":"\(last_trip_data.get("eBookingFrom"))", "eRental":last_trip_data.get("eRental"), "eTransit":last_trip_data.get("eTransit"), "moreServices":last_trip_data.get("moreServices"), "eServiceLocation":last_trip_data.get("eServiceLocation"), "vTripPaymentMode":(last_trip_data.get("vTripPaymentMode")), "ePayWallet":(last_trip_data.get("ePayWallet")), "iStopId":(last_trip_data.get("iStopId")), "totalStopOverPoint":(last_trip_data.get("totalStopOverPoint")), "currentStopOverPoint":(last_trip_data.get("currentStopOverPoint"))] /* PAYMENT FLOW CHANGES " , "vTripPaymentMode":(last_trip_data.get("vTripPaymentMode")), "ePayWallet":(last_trip_data.get("ePayWallet"))"*/
            

            
            if last_trip_data.get("eType") == "Multi-Delivery"
            {
                if ((last_trip_data.get("IS_OPEN_SIGN_VERIFY") == "Yes" && last_trip_data.get("IS_OPEN_FOR_SENDER") == "Yes") || (last_trip_data.get("IS_OPEN_SIGN_VERIFY") == "Yes" && last_trip_data.get("IS_OPEN_FOR_SENDER") == "No"))
                {
                    return
                    
                }
            }
            
            
            if userProfileJsonDict.get("eSystem") == "DeliverAll" ? (ratings_From_Driver != "Done" && ratings_From_Driver != "" && lastTripExist == true) : (vTripStatus == "Not Active" && lastTripExist == true){
        
                
                let ePaymentCollect = last_trip_data.get("ePaymentCollect")
                
                if(userProfileJsonDict.get("eSystem") != "DeliverAll" && ePaymentCollect == "No"){
                    // CollectPayment
                    let collectPaymentUv = GeneralFunctions.instantiateViewController(pageName: "CollectPaymentUV") as! CollectPaymentUV
                    collectPaymentUv.tripData = dataParams as NSDictionary
                    let navigationController = UINavigationController(rootViewController: collectPaymentUv)
                    navigationController.navigationBar.isTranslucent = false
                    
                    UIView.transition(with: self.window,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                        
                    } ,
                                      completion: nil)
                    
                    
                    return
                }else{
                    // Trip Rating
                    
                    if userProfileJsonDict.get("eSystem") == "DeliverAll"
                    {
                        return
                    }else
                    {
                        if(last_trip_data.get("eBookingFrom").uppercased() != "KIOSK"){
                            let ratingUv = GeneralFunctions.instantiateViewController(pageName: "RatingUV") as! RatingUV
                            ratingUv.tripData = dataParams as NSDictionary
                            let navigationController = UINavigationController(rootViewController: ratingUv)
                            navigationController.navigationBar.isTranslucent = false
                            
                            UIView.transition(with: self.window,
                                              duration: 0.3,
                                              options: .transitionCrossDissolve,
                                              animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                                
                            } ,
                                              completion: nil)
                            
                            return
                        }
                      
                    }
                    
                }
            
            }else{
                
                if userProfileJsonDict.get("eSystem") == "DeliverAll"
                {
                    return
                    
                }else{
                    
                    if (vTripStatus == "Arrived") {
                        // Open active trip page
                        //                    map.put("vTripStatus", "Arrived");
                        //                     bn.putSerializable("TRIP_DATA", map);
                        
                        //                    new StartActProcess(mContext).startActWithData(ActiveTripActivity.class, bn);
                        
                        let activeTripUV = GeneralFunctions.instantiateViewController(pageName: "ActiveTripUV") as! ActiveTripUV
                        activeTripUV.tripData = dataParams as NSDictionary
                        activeTripUV.isTripStarted = false
                        
                        let navigationController = UINavigationController(rootViewController: activeTripUV)
                        navigationController.navigationBar.isTranslucent = false
                        
                        UIView.transition(with: self.window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                            
                        } ,
                                          completion: nil)
                        
                        
                        return
                    } else if (vTripStatus != "Arrived" && vTripStatus == "On Going Trip") {
                        // Open active trip page
                        //                    map.put("vTripStatus", "EN_ROUTE");
                        //                    bn.putSerializable("TRIP_DATA", map);
                        //
                        //                    new StartActProcess(mContext).startActWithData(ActiveTripActivity.class, bn);
                        
                        let activeTripUV = GeneralFunctions.instantiateViewController(pageName: "ActiveTripUV") as! ActiveTripUV
                        activeTripUV.tripData = dataParams as NSDictionary
                        activeTripUV.isTripStarted = true
                        
                        var navigationController = UINavigationController(rootViewController: activeTripUV)
                        
                        if(last_trip_data.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() && last_trip_data.get("eServiceEnd").uppercased() == "YES" && last_trip_data.get("eFareGenerated").uppercased() == "NO"){
                        }
                        
                        navigationController.navigationBar.isTranslucent = false
                        
                        UIView.transition(with: self.window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                            
                        } ,
                                          completion: nil)
                        
                        
                        return
                    } else if (vTripStatus != "Arrived" && vTripStatus == "Active") {
                        // Open driver arrived page
                        let driverArrivedUv = GeneralFunctions.instantiateViewController(pageName: "DriverArrivedUV") as! DriverArrivedUV
                        driverArrivedUv.tripData = dataParams as NSDictionary
                        let navigationController = UINavigationController(rootViewController: driverArrivedUv)
                        navigationController.navigationBar.isTranslucent = false
                        
                        UIView.transition(with: self.window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                            
                        } ,
                                          completion: nil)
                        
                        
                        return
                    }
                }
                
            
            }
        }
        
        let menuUV = GeneralFunctions.instantiateViewController(pageName: "MenuScreenUV") as! MenuScreenUV
//        menuUV.mainScreenUv = mainScreenUv
        
//        mainScreenUv.menuScreenUv = menuUV
        
        let navigationController = UINavigationController(rootViewController: mainScreenUv)
        navigationController.navigationBar.isTranslucent = false
        if(Configurations.isRTLMode()){
            let navController = NavigationDrawerController(rootViewController: navigationController, leftViewController: nil, rightViewController: menuUV)
            navController.isRightPanGestureEnabled = false
            UIView.transition(with: self.window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navController)
                                
            } ,
                              completion: nil)
            
        }else{
            let navController = NavigationDrawerController(rootViewController: navigationController, leftViewController: menuUV, rightViewController: nil)
            navController.isLeftPanGestureEnabled = false
            
            UIView.transition(with: self.window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navController)
                                
            } ,
                              completion: nil)
            
        }
        
//        if(oldViewController != nil){
//            oldViewController.dismiss(animated: false, completion: nil)
//        }
    }
    
    func saveData(){
        let userProfileJson = self.userProfileJson.getJsonDataDict().getObj(Utils.message_str)
        
        GeneralFunctions.saveValue(key: Utils.PUBNUB_PUB_KEY, value: userProfileJson.get("PUBNUB_PUBLISH_KEY") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.PUBNUB_SUB_KEY, value: userProfileJson.get("PUBNUB_SUBSCRIBE_KEY") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.PUBNUB_SEC_KEY, value: userProfileJson.get("PUBNUB_SECRET_KEY") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.SITE_TYPE_KEY, value: userProfileJson.get("SITE_TYPE") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.APPSTORE_MODE_IOS_KEY, value: userProfileJson.get("APPSTORE_MODE_IOS") as AnyObject)
        
        GeneralFunctions.saveValue(key: Utils.MOBILE_VERIFICATION_ENABLE_KEY, value: userProfileJson.get("MOBILE_VERIFICATION_ENABLE") as AnyObject)
        GeneralFunctions.saveValue(key: "LOCATION_ACCURACY_METERS", value: userProfileJson.get("LOCATION_ACCURACY_METERS") as AnyObject)
        GeneralFunctions.saveValue(key: "DRIVER_LOC_UPDATE_TIME_INTERVAL", value: userProfileJson.get("DRIVER_LOC_UPDATE_TIME_INTERVAL") as AnyObject)
        GeneralFunctions.saveValue(key: "PHOTO_UPLOAD_SERVICE_ENABLE", value: userProfileJson.get("PHOTO_UPLOAD_SERVICE_ENABLE") as AnyObject)
        GeneralFunctions.saveValue(key: "DESTINATION_UPDATE_TIME_INTERVAL", value: userProfileJson.get("DESTINATION_UPDATE_TIME_INTERVAL") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.FETCH_TRIP_STATUS_TIME_INTERVAL_KEY, value: userProfileJson.get("FETCH_TRIP_STATUS_TIME_INTERVAL") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.RIDER_REQUEST_ACCEPT_TIME_KEY, value: userProfileJson.get("RIDER_REQUEST_ACCEPT_TIME") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.APP_GCM_SENDER_ID_KEY, value: userProfileJson.get("GOOGLE_SENDER_ID") as AnyObject)
        
        GeneralFunctions.saveValue(key: Utils.PUBSUB_TECHNIQUE_KEY, value: userProfileJson.get("PUBSUB_TECHNIQUE") as AnyObject)
        
        GeneralFunctions.saveValue(key: Utils.REFERRAL_SCHEME_ENABLE, value: userProfileJson.get("REFERRAL_SCHEME_ENABLE") as AnyObject)
        
        GeneralFunctions.saveValue(key: Utils.DEVICE_SESSION_ID_KEY, value: userProfileJson.get("tDeviceSessionId") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.SESSION_ID_KEY, value: userProfileJson.get("tSessionId") as AnyObject)
        
        GeneralFunctions.saveValue(key: Utils.DEFAULT_COUNTRY_KEY, value: userProfileJson.get("vDefaultCountry") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY, value: userProfileJson.get("vDefaultCountryCode") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.DEFAULT_PHONE_CODE_KEY, value: userProfileJson.get("vDefaultPhoneCode") as AnyObject)
        
        GeneralFunctions.saveValue(key: Utils.GOOGLE_SERVER_IOS_DRIVER_APP_KEY, value: userProfileJson.get("GOOGLE_SERVER_IOS_DRIVER_APP_KEY") as AnyObject)
        GeneralFunctions.saveValue(key: Utils.GOOGLE_IOS_DRIVER_APP_GEO_KEY, value: userProfileJson.get("GOOGLE_IOS_DRIVER_APP_GEO_KEY") as AnyObject)
        
        GeneralFunctions.saveValue(key: Utils.SC_CONNECT_URL_KEY, value: userProfileJson.get("SC_CONNECT_URL") as AnyObject)
        
        GeneralFunctions.saveValue(key: Utils.ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP_KEY, value: userProfileJson.get("ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP") as AnyObject)
        
        GeneralFunctions.saveValue(key: Utils.DRIVER_ARRIVED_MIN_TIME_PER_MINUTE_KEY, value: userProfileJson.get("DRIVER_ARRIVED_MIN_TIME_PER_MINUTE") as AnyObject)
        
        GeneralFunctions.saveValue(key: Utils.PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT_KEY, value: userProfileJson.get("PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT") as AnyObject)
        
//        GMSServices.provideAPIKey(Configurations.getGoogleServerKey())
        GMSServices.provideAPIKey(Configurations.getGoogleIOSKey())
//        GMSPlacesClient.provideAPIKey(Configurations.getGoogleIOSKey())
        
        GeneralFunctions.removeValue(key: "userHomeLocationAddress")
        GeneralFunctions.removeValue(key: "userHomeLocationLatitude")
        GeneralFunctions.removeValue(key: "userHomeLocationLongitude")
        GeneralFunctions.removeValue(key: "userWorkLocationAddress")
        GeneralFunctions.removeValue(key: "userWorkLocationLatitude")
        GeneralFunctions.removeValue(key: "userWorkLocationLongitude")
        
        let userFavouriteAddressArr = userProfileJson.getArrObj("UserFavouriteAddress")
        if(userFavouriteAddressArr.count > 0){
            for i in 0..<userFavouriteAddressArr.count {
                let dataItem = userFavouriteAddressArr[i] as! NSDictionary
                if(dataItem.get("eType").uppercased() == "HOME"){
                    GeneralFunctions.saveValue(key: "userHomeLocationAddress", value: dataItem.get("vAddress") as AnyObject)
                    GeneralFunctions.saveValue(key: "userHomeLocationLatitude", value: dataItem.get("vLatitude") as AnyObject)
                    GeneralFunctions.saveValue(key: "userHomeLocationLongitude", value: dataItem.get("vLongitude") as AnyObject)
                }else if(dataItem.get("eType").uppercased() == "WORK"){
                    GeneralFunctions.saveValue(key: "userWorkLocationAddress", value: dataItem.get("vAddress") as AnyObject)
                    GeneralFunctions.saveValue(key: "userWorkLocationLatitude", value: dataItem.get("vLatitude") as AnyObject)
                    GeneralFunctions.saveValue(key: "userWorkLocationLongitude", value: dataItem.get("vLongitude") as AnyObject)
                }
            }
        }
        
    }
}
