//
//  UpdateDirections.swift
//  DriverApp
//
//  Created by ADMIN on 27/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps

@objc protocol OnDirectionUpdateDelegate:class
{
    func onDirectionUpdate(directionResultDict:NSDictionary)
}

class UpdateDirections: NSObject, OnLocationUpdateDelegate {
    
    var userLocation:CLLocation!
    var timer:Timer!
    var uv:UIViewController!
    
    var getLoc:GetLocation!
    var gMap:GMSMapView!
    var navigateView:navigationVIew!
    
    var destinationLocation:CLLocation!
    var fromLocation:CLLocation!
    
    var listOfPoints = [String()]
    
    var listOfPaths = [GMSPolyline]()
    
    let generalFunc = GeneralFunctions()
    
    var eTollSkipped = ""
    
    var isCurrentLocationEnabled = true
    
    var onDirectionUpdateDelegate:OnDirectionUpdateDelegate!
    var userProfileJson:NSDictionary!
    var totalDefaultViewHeight:CGFloat = 0
    
    var ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP = ""
    var DRIVER_ARRIVED_MIN_TIME_PER_MINUTE = ""
    
    var topNavViewHeight:CGFloat = 90
    
    var DESTINATION_UPDATE_TIME_INTERVAL_value:Double = 30

    init(uv:UIViewController, gMap:GMSMapView, destinationLocation:CLLocation, navigateView:navigationVIew){
        self.uv = uv
        self.gMap = gMap
        self.destinationLocation = destinationLocation
        self.navigateView = navigateView
        
        super.init()
    }
    
    init(uv:UIViewController, gMap:GMSMapView, fromLocation:CLLocation, destinationLocation:CLLocation, isCurrentLocationEnabled:Bool){
        self.uv = uv
        self.gMap = gMap
        self.fromLocation = fromLocation
        self.destinationLocation = destinationLocation
        self.isCurrentLocationEnabled = isCurrentLocationEnabled
        
        super.init()
    }
    
    func setCurrentLocEnabled(isCurrentLocationEnabled:Bool){
        self.isCurrentLocationEnabled = isCurrentLocationEnabled
    }
 
    func addReleaseObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
    }
    
    func scheduleDirectionUpdate(eTollSkipped:String){
        self.eTollSkipped = eTollSkipped
        addReleaseObserver()
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        if(navigateView != nil){
            navigateView.addressLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOAD_ADDRESS")
        }
        
        ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP = GeneralFunctions.getValue(key: Utils.ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP_KEY) as! String
        DRIVER_ARRIVED_MIN_TIME_PER_MINUTE = GeneralFunctions.getValue(key: Utils.DRIVER_ARRIVED_MIN_TIME_PER_MINUTE_KEY) as! String
        
        if(timer != nil){
            timer!.invalidate()
        }
        let DESTINATION_UPDATE_TIME_INTERVAL = GeneralFunctions.getValue(key: "DESTINATION_UPDATE_TIME_INTERVAL")
        
        
        DESTINATION_UPDATE_TIME_INTERVAL_value = GeneralFunctions.parseDouble(origValue: 30, data: DESTINATION_UPDATE_TIME_INTERVAL == nil ? "30" : (DESTINATION_UPDATE_TIME_INTERVAL as! String)) * 60
        
        startTimer()
        
        if(isCurrentLocationEnabled){
            if(getLoc == nil){
                getLoc = GetLocation(uv: self.uv, isContinuous: true)
                getLoc.buildLocManager(locationUpdateDelegate: self)
            }else{
                getLoc.buildLocManager(locationUpdateDelegate: self)
                getLoc.resumeLocationUpdates()
            }
        }
    }
    
   private func startTimer(){
        if(timer != nil){
            timer!.invalidate()
            timer = nil
        }
        
        timer =  Timer.scheduledTimer(timeInterval: DESTINATION_UPDATE_TIME_INTERVAL_value, target: self, selector: #selector(updateDirections), userInfo: nil, repeats: true)
        
        timer.fire()
    }
    
    func startDirectionUpdate(){
        startTimer()
    }
    
    func pauseDirectionUpdate(){
        if(timer != nil){
            timer!.invalidate()
        }
    }
    
    func stopFrequentUpdate(){
        if(timer != nil){
            timer!.invalidate()
        }
        
        if(getLoc != nil){
            getLoc.releaseLocationTask()
            getLoc.locationUpdateDelegate = nil
        }
    }
    
    @objc func releaseTask(){
        if(timer != nil){
            timer!.invalidate()
            timer = nil
        }
        
        if(getLoc != nil){
            getLoc.releaseLocationTask()
            getLoc.locationUpdateDelegate = nil
            getLoc = nil
        }
        
        for i in 0..<self.listOfPaths.count{
            self.listOfPaths[i].map = nil
        }
        
        self.listOfPaths.removeAll()
        self.listOfPoints.removeAll()
       
        GeneralFunctions.removeObserver(obj: self)
    }
    
    func onLocationUpdate(location: CLLocation) {
       
        if(self.userLocation == nil){
            self.userLocation = location
            updateDirections()
        }
        
        self.userLocation = location
    }
    
    @objc func updateDirections(){
        let fromLocation = userLocation == nil ? self.fromLocation : userLocation
        let destinationLocation = self.destinationLocation
        
//        if(gMap == nil || destinationLocation == nil || userLocation == nil || destinationLocation!.coordinate.latitude == 0.0 || destinationLocation!.coordinate.longitude == 0.0){
//            return
//        }

        if(gMap == nil || destinationLocation == nil || fromLocation == nil || destinationLocation!.coordinate.latitude == 0.0 || destinationLocation!.coordinate.longitude == 0.0){
            return
        }
        
        if(ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP.uppercased() == "NO"){
            if(self.navigateView != nil){
                
                if(self.navigateView.tripIntervalLbl.isHidden == true){
                    self.navigateView.tripIntervalLbl.isHidden = false
                }
                
                var distance = destinationLocation!.distance(from: fromLocation!) / 1000
                
                let time_value_str = GeneralFunctions.parseDouble(origValue: 2, data: DRIVER_ARRIVED_MIN_TIME_PER_MINUTE) * distance * 60
                let time_str = Utils.formateSecondsToHours(seconds: "\(time_value_str)")
                
                if(userProfileJson != nil && userProfileJson.get("eUnit") != "KMs"){
                    distance = distance *  0.621371
                }
                
                var distance_str = ""
                
                if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
                    distance_str = "\(String(format: "%.02f", distance)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT"))"
                }else{
                    distance_str = "\(String(format: "%.02f", distance)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_DISTANCE_TXT"))"
                }
                
                self.navigateView.tripIntervalLbl.text = "\(time_str) \(self.generalFunc.getLanguageLabel(origValue: "to reach", key: "LBL_TO_REACH")) & \(distance_str) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AWAY"))"
                
                self.navigateView.tripIntervalLbl.isHidden = false
                
                self.setDestAddress()
                
                if(self.gMap != nil){
                    var bounds = GMSCoordinateBounds()
                    bounds = bounds.includingCoordinate(fromLocation!.coordinate)
                    bounds = bounds.includingCoordinate(destinationLocation!.coordinate)
                    let edgeInsets = UIEdgeInsets.init(top: topNavViewHeight + 20 + self.navigateView.tripIntervalLbl.frame.height, left: 10, bottom: 120 + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 10)
                    let update = GMSCameraUpdate.fit(bounds, with: edgeInsets)
                    self.gMap.animate(with: update)
                }
            }
        }else{
            var directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(fromLocation!.coordinate.latitude),\(fromLocation!.coordinate.longitude)&destination=\(destinationLocation!.coordinate.latitude),\(destinationLocation!.coordinate.longitude)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true"
            
            if(userProfileJson != nil && userProfileJson.get("eUnit") != "KMs"){
                directionURL = "\(directionURL)&units=imperial"
            }
            
            if(eTollSkipped == "Yes"){
                directionURL = "\(directionURL)&avoid=tolls"
            }
            
            Utils.printLog(msgData: "directionURL::\(directionURL)")
            
            let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.uv.view, isOpenLoader: false)
            
            exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("status").uppercased() != "OK" || dataDict.getArrObj("routes").count == 0){
                        self.setDestAddress()
                        return
                    }
                    
                    if(self.onDirectionUpdateDelegate != nil){
                        self.onDirectionUpdateDelegate!.onDirectionUpdate(directionResultDict: dataDict)
                    }
                    
                    let routesArr = dataDict.getArrObj("routes")
                    let legs_arr = (routesArr.object(at: 0) as! NSDictionary).getArrObj("legs")
                    let steps_arr = (legs_arr.object(at: 0) as! NSDictionary).getArrObj("steps")
                    //                let start_address = (legs_arr.object(at: 0) as! NSDictionary).get("start_address")
                    //                let end_address = (legs_arr.object(at: 0) as! NSDictionary).get("end_address")
//                    var time_str = (legs_arr.object(at: 0) as! NSDictionary).getObj("duration").get("text")
                    let time_value_str = (legs_arr.object(at: 0) as! NSDictionary).getObj("duration").get("value")
                    let distance_value = (legs_arr.object(at: 0) as! NSDictionary).getObj("distance").get("value")
                    
                    var time_str = Utils.formateSecondsToHours(seconds: time_value_str)
                    
                    var distance_final = GeneralFunctions.parseDouble(origValue: 0.0, data: distance_value)
                    
                    if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
                        distance_final = distance_final * 0.000621371
                    }else{
                        distance_final = distance_final * 0.00099999969062399994
                    }
                    
                    distance_final = distance_final.roundTo(places: 2)
                    
                    var distance_str = ""
                    
                    if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
                        distance_str = "\(String(format: "%.02f", distance_final)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT"))"
                    }else{
                        distance_str = "\(String(format: "%.02f", distance_final)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_DISTANCE_TXT"))"
                    }
                    
                    time_str = Configurations.convertNumToAppLocal(numStr: time_str)
                    distance_str = Configurations.convertNumToAppLocal(numStr: distance_str)
                    
                    if(self.navigateView != nil){
                        
                        if(self.navigateView.tripIntervalLbl.isHidden == true){
                            self.navigateView.tripIntervalLbl.isHidden = false
                        }
                        
                        self.navigateView.tripIntervalLbl.text = "\(time_str) \(self.generalFunc.getLanguageLabel(origValue: "to reach", key: "LBL_TO_REACH")) & \(distance_str) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AWAY"))"
                        
                        self.navigateView.tripIntervalLbl.isHidden = false
                        
                        self.setDestAddress()
                        
                    }
                    
                    for i in 0..<self.listOfPaths.count{
                        self.listOfPaths[i].map = nil
                    }
                    self.listOfPaths.removeAll()
                    self.listOfPoints.removeAll()
                    
                    for i in 0..<steps_arr.count{
                        let polyPoints = (steps_arr.object(at: i) as! NSDictionary).getObj("polyline").get("points")
                        
                        self.listOfPoints += [polyPoints]
                        
                        self.addPolyLineWithEncodedStringInMap(encodedString: polyPoints)
                    }
                }else{
                    //                self.generalFunc.setError(uv: self)
                    self.setDestAddress()
                }
            }, url: directionURL)
        }
    }
    
    
    
    func setDestAddress(){
        if(self.navigateView != nil){
            var extraHeight = self.navigateView.tripIntervalLbl.text!.height(withConstrainedWidth: self.navigateView.frame.width - 20, font: self.navigateView.tripIntervalLbl.font!)

            if(extraHeight < 0){
                extraHeight = 0
            }
            self.navigateView.tripIntervalLbl.fitText()
            
            if(self.uv .isKind(of: DriverArrivedUV.self)){
                let driverArrivedUv = self.uv as! DriverArrivedUV
                let tSaddress = driverArrivedUv.tripData!.get("tSaddress")
                
                var destAddrHeight = tSaddress.height(withConstrainedWidth: Application.screenSize.width - 156, font: self.navigateView.addressLbl.font!) - 60
                
                if(destAddrHeight < 0){
                    destAddrHeight = 0
                }
                
                self.navigateView.addressLbl.text = tSaddress
                
                self.navigateView.addressLbl.fitText()
                //                        self.navigateView.frame.size = CGSize(width: self.navigateView.frame.size.width, height: CGFloat(125 + destAddrHeight + extraHeight))
                
//                (self.uv as! DriverArrivedUV).navigateViewHeight.constant = CGFloat(125 + destAddrHeight + extraHeight)
                
                if(totalDefaultViewHeight < 1){
                    self.totalDefaultViewHeight = (self.uv as! DriverArrivedUV).topDataContainerViewHeight.constant
                }
                
                (self.uv as! DriverArrivedUV).topNavView.frame.size.height = 95 + destAddrHeight + extraHeight
                (self.uv as! DriverArrivedUV).topNavView.view.frame.size.height = 95 + destAddrHeight + extraHeight
                (self.uv as! DriverArrivedUV).topDataContainerViewHeight.constant =  self.totalDefaultViewHeight + destAddrHeight + extraHeight
                
                topNavViewHeight = (self.uv as! DriverArrivedUV).topDataContainerViewHeight.constant
                
            }else if(self.uv .isKind(of: ActiveTripUV.self)){
                let activeTripUv = self.uv as! ActiveTripUV
                
                let tDaddress = activeTripUv.tripData!.get("tDaddress")
                var destAddrHeight = tDaddress.height(withConstrainedWidth: Application.screenSize.width - 156, font: self.navigateView.addressLbl.font!) - 60
                
                if(destAddrHeight < 0){
                    destAddrHeight = 0
                }
                
                self.navigateView.addressLbl.text = tDaddress
                
                self.navigateView.addressLbl.fitText()
                if(totalDefaultViewHeight < 1){
                    self.totalDefaultViewHeight = (self.uv as! ActiveTripUV).topDataContainerViewHeight.constant
                }
                
                (self.uv as! ActiveTripUV).topNavView.frame.size.height = 95 + destAddrHeight + extraHeight
                (self.uv as! ActiveTripUV).topNavView.view.frame.size.height = 95 + destAddrHeight + extraHeight
                (self.uv as! ActiveTripUV).topDataContainerViewHeight.constant =  self.totalDefaultViewHeight + destAddrHeight + extraHeight
                
                topNavViewHeight = (self.uv as! ActiveTripUV).topDataContainerViewHeight.constant
            }
        }
    }
    
    func addPolyLineWithEncodedStringInMap(encodedString: String) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 5
        polyLine.strokeColor = UIColor.black
        polyLine.map = gMap
        
        self.listOfPaths += [polyLine]
    }
}
