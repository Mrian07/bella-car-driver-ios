//
//  SearchPlacesUV.swift
//  DriverApp
//
//  Created by ADMIN on 20/11/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

protocol OnPlaceSelectDelegate {
    func onPlaceSelected(location:CLLocation, address:String, searchBar:UISearchBar, searchPlaceUv:SearchPlacesUV)
    func onPlaceSelectCancel(searchBar:UISearchBar, searchPlaceUv:SearchPlacesUV)
}

class SearchPlacesUV: UIViewController, UISearchBarDelegate, MyLabelClickDelegate, UITableViewDelegate, UITableViewDataSource, OnLocationUpdateDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var existingPlacesView: UIView!
    @IBOutlet weak var searchPlaceTableView: UITableView!
    
    @IBOutlet weak var placesHLbl: MyLabel!
    @IBOutlet weak var homeLocAreaView: UIView!
    @IBOutlet weak var homeLocHLbl: MyLabel!
    @IBOutlet weak var homeLocVLbl: MyLabel!
    @IBOutlet weak var homeLocEditImgView: UIImageView!
    @IBOutlet weak var homeLocImgView: UIImageView!
  
    
    @IBOutlet weak var setLocMapAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var setLocMapLbl: MyLabel!
    @IBOutlet weak var setLocRightArrowImgView: UIImageView!
    @IBOutlet weak var setLocOnMapAreaView: UIView!
    @IBOutlet weak var pinImgView: UIImageView!
    
    @IBOutlet weak var recentLocationHLbl: MyLabel!
    @IBOutlet weak var recentLocTableView: UITableView!
    @IBOutlet weak var generalHAreaView: UIView!
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet weak var generalAreaViewHeight: NSLayoutConstraint!
    
    
    let generalFunc = GeneralFunctions()
    
    
    let searchBar = UISearchBar()
    var userProfileJson:NSDictionary!
    
    var locationBias:CLLocation!
    
    var placeSelectDelegate:OnPlaceSelectDelegate?
    
    var isScreenLoaded = false
    
    var isScreenKilled = false
    
    var isHomePlaceAdded = false
   
//    var dataArrList = [RecentLocationItem]()
    var searchPlaceDataArr = [SearchLocationItem]()
    
    var cntView:UIView!
    
    var PAGE_HEIGHT:CGFloat = 310
    
    var keyboardHeightSet = false
    
    var cancelLbl:MyLabel!
    
    var loaderView:UIView!
    
    var placeSearchExeServerTask:ExeServerUrl!
    
    var fromAddAddress = false
    
    var isFromSelectLoc = false
    
    var getLocation:GetLocation!
    
    var currentLocation:CLLocation!
    
    var getAddressFrmLocation:GetAddressFromLocation!
    
    var SCREEN_TYPE = ""
    
    var currentSearchQuery = ""
    
    var defaultPageHeight:CGFloat = 0
    
    var errorLbl:MyLabel!
    
    var homeLoc:CLLocation!
    
    var currentCabType = ""
    
    var finalPageHeight:CGFloat = 0
    
    var isFromDeliverAll = false
    var session_token = ""
    
    var sessionTokenFreqTask:UpdateFreqTask!
    var MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE:Int = 2
    
    var isForDriverDestinations = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        if(isScreenKilled){
            self.closeCurrentScreen()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.sizeToFit()
        
        searchBar.delegate = self
        
        scrollView.keyboardDismissMode = .onDrag
        

        //if(currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && userProfileJson.get("APP_DESTINATION_MODE").uppercased() == "NONSTRICT" && isDriverAssigned == false){
           self.PAGE_HEIGHT = self.PAGE_HEIGHT + 50
        //}
        
        //        navItem.titleView = searchBar
        let textWidth = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").width(withConstrainedHeight: 29, font: UIFont(name: Fonts().light, size: 17)!)
        searchBar.frame.size = CGSize(width: Application.screenSize.width - 55 - textWidth, height: 40)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:searchBar)
        
        cancelLbl = MyLabel()
        cancelLbl.font = UIFont(name: Fonts().light, size: 17)!
        cancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
        cancelLbl.setClickDelegate(clickDelegate: self)
        cancelLbl.fitText()
        cancelLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.navigationItem.titleView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:cancelLbl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE = GeneralFunctions.parseInt(origValue: 2, data: userProfileJson.get("MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE"))

    }

    override func viewDidAppear(_ animated: Bool) {
        
        
        if(isScreenLoaded == false){
            cntView = self.generalFunc.loadView(nibName: "SearchPlacesScreenDesign", uv: self, contentView: scrollView)
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT > scrollView.frame.height ? PAGE_HEIGHT : scrollView.frame.height)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT > scrollView.frame.height ? PAGE_HEIGHT : scrollView.frame.height)
            finalPageHeight = self.cntView.frame.size.height
            
            self.scrollView.addSubview(cntView)
            self.scrollView.bounces = false
            
            isScreenLoaded = true
            
            self.recentLocTableView.bounces = false
            
            setData()
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        
        self.searchBar.becomeFirstResponder()
        
//        searchBar.becomeFirstResponder()
    }
    
    override func closeCurrentScreen() {
        if(sessionTokenFreqTask != nil){
            sessionTokenFreqTask.stopRepeatingTask()
        }
        super.closeCurrentScreen()
    }
    
    @objc func releaseAllTask(){
        
        if(getAddressFrmLocation != nil){
            getAddressFrmLocation!.addressFoundDelegate = nil
            getAddressFrmLocation = nil
        }
        
        if(self.getLocation != nil){
            self.getLocation!.locationUpdateDelegate = nil
            self.getLocation!.releaseLocationTask()
            self.getLocation = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
    }
    
    func setData(){
        self.placesHLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.placesHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.searchPlaceTableView.isHidden = true
        
        if(fromAddAddress != true){
            self.recentLocationHLbl.isHidden = false
            self.recentLocationHLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
            self.recentLocationHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        }else{
            self.recentLocationHLbl.isHidden = true
        }
        
        
        self.recentLocationHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Recent Locations", key: "LBL_RECENT_LOCATIONS")
        self.placesHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Favorite Places", key: "LBL_FAV_LOCATIONS")
        
        self.setLocMapLbl.text = self.generalFunc.getLanguageLabel(origValue: "Set location on map", key: "LBL_SET_LOC_ON_MAP")
        

        if(isForDriverDestinations == true){
            
            let locOnMapTapGue = UITapGestureRecognizer()
            locOnMapTapGue.addTarget(self, action: #selector(self.findLocOnMap))
            self.setLocOnMapAreaView.isUserInteractionEnabled = true
            self.setLocOnMapAreaView.addGestureRecognizer(locOnMapTapGue)
            
            self.recentLocTableView.register(UINib(nibName: "RecentLocationTVCell", bundle: nil), forCellReuseIdentifier: "RecentLocationTVCell")
            self.existingPlacesView.isHidden = false
            self.recentLocTableView.dataSource = self
            self.recentLocTableView.delegate = self
        }
        
        self.searchPlaceTableView.dataSource = self
        self.searchPlaceTableView.delegate = self
        
        checkPlaces()
        
        self.searchPlaceTableView.register(UINib(nibName: "GPAutoCompleteListTVCell", bundle: nil), forCellReuseIdentifier: "GPAutoCompleteListTVCell")
        self.recentLocTableView.tableFooterView = UIView()
        
        let power_googleImgView = UIImageView()
        power_googleImgView.image = UIImage(named: "ic_powered_google_light_bg")!.imageWithInsets(insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 15))
        power_googleImgView.contentMode = .bottomRight
        power_googleImgView.frame.size.height = 25
        self.searchPlaceTableView.tableFooterView = power_googleImgView
        
        if(self.isFromSelectLoc == true || GeneralFunctions.getMemberd() == ""){
            
            if(GeneralFunctions.getMemberd() == "") {
                self.generalHAreaView.isHidden = true
                self.generalAreaViewHeight.constant = 0
            }else{
                
                self.setLocMapAreaHeight.constant = 0
                self.setLocOnMapAreaView.isHidden = true
                self.existingPlacesView.isHidden = true
            }
            
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.setLocRightArrowImgView, color: UIColor(hex: 0x6F6F6F))
       
//        GeneralFunctions.setImgTintColor(imgView: self.pinImgView, color: UIColor.UCAColor.AppThemeColor_1)
//        GeneralFunctions.setImgTintColor(imgView: self.desLaterImgView, color: UIColor.UCAColor.AppThemeColor_1)
        
        if(Configurations.isRTLMode()){
            self.setLocRightArrowImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
          
        }
        
        
    }
    
    
    func onAddressFound(address: String, location: CLLocation, isPickUpMode: Bool, dataResult: String) {
//        self.userLocationAddress = address
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelected(location: location, address: address, searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    func onLocationUpdate(location: CLLocation) {
        self.currentLocation = location
        self.locationBias = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.getLocation.locationUpdateDelegate = nil
        self.getLocation.releaseLocationTask()
        self.getLocation = nil
    }
    

    @objc func keyboardWillDisappear(sender: NSNotification){
        let info = sender.userInfo!
        _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
//        if(keyboardHeightSet){
        changeContentSize(PAGE_HEIGHT: finalPageHeight)
//        changeContentSize(PAGE_HEIGHT: (self.PAGE_HEIGHT - keyboardSize))
            keyboardHeightSet = false
//        }
    }
    @objc func keyboardWillAppear(sender: NSNotification){
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        finalPageHeight = self.PAGE_HEIGHT
//        if(Application.screenSize.height < (keyboardSize + self.PAGE_HEIGHT)){
            changeContentSize(PAGE_HEIGHT: (keyboardSize + self.PAGE_HEIGHT))
            keyboardHeightSet = true
//        }
    }
    
    func changeContentSize(PAGE_HEIGHT:CGFloat){
        self.PAGE_HEIGHT = PAGE_HEIGHT
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
//        cntView.backgroundColor = UIColor.blue
//        recentLocTableView.backgroundColor = UIColor.clear
//        existingPlacesView.backgroundColor = UIColor.clear
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //        for(id subview in [yourSearchBar subviews])
        //        {
        //            if ([subview isKindOfClass:[UIButton class]]) {
        //                [subview setEnabled:YES];
        //            }
        //        }
        
        Utils.printLog(msgData: "EndEditing")
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        Utils.printLog(msgData: "Begin Editing")
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(self.currentSearchQuery == searchText.trim()){
            return
        }
        if(session_token == ""){
            session_token = "\(Utils.appUserType)_\(GeneralFunctions.getMemberd())_\(Utils.currentTimeMillis())"
            initializeSessionRegeneration()
        }
        self.currentSearchQuery = searchText.trim()
        fetchAutoCompletePlaces(searchText: searchText.trim())
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        self.closeCurrentScreen()
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelectCancel(searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    func initializeSessionRegeneration(){
        if(self.sessionTokenFreqTask != nil){
            self.sessionTokenFreqTask.stopRepeatingTask()
        }
        let freqTask = UpdateFreqTask(interval: 170)
        freqTask.currInst = freqTask
        freqTask.setTaskRunHandler { (instance) in
            self.session_token = "\(Utils.appUserType)_\(GeneralFunctions.getMemberd())_\(Utils.currentTimeMillis())"
        }
        self.sessionTokenFreqTask = freqTask
        freqTask.startRepeatingTask()
    }

    func fetchAutoCompletePlaces(searchText:String){
        
        if(searchText.count < MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE){
           
            self.searchPlaceTableView.isHidden = true
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
            
            if(self.errorLbl != nil){
                self.errorLbl.isHidden = true
            }
            
            return
        }else{
//            defaultPageHeight = self.PAGE_HEIGHT

            self.existingPlacesView.isHidden = true
            self.searchPlaceTableView.isHidden = false
        }
        
        self.searchPlaceDataArr.removeAll()
        self.searchPlaceTableView.reloadData()
        
        if(self.errorLbl != nil){
            self.errorLbl.isHidden = true
        }
        
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
        
        let session_token = self.session_token

        var autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchText)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true&sessiontoken=\(session_token)"
        
        if(locationBias != nil){
            autoCompleteUrl = "\(autoCompleteUrl)&location=\(locationBias.coordinate.latitude),\(locationBias.coordinate.longitude)&radius=20000"
        }
        
        if(placeSearchExeServerTask != nil){
            placeSearchExeServerTask.cancel()
            placeSearchExeServerTask = nil
        }
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: false)
        self.placeSearchExeServerTask = exeWebServerUrl
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(self.currentSearchQuery != searchText){
                return
            }
            
            if(response != ""){
                
                
                if(self.errorLbl != nil){
                    self.errorLbl.isHidden = true
                }
                
                if(self.searchPlaceTableView.isHidden == true){
                    self.loaderView.isHidden = true
                    return
                }
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("status").uppercased() == "OK"){
                    
                    let predictionsArr = dataDict.getArrObj("predictions")
                    
                    for i in 0..<predictionsArr.count{
                        let item = predictionsArr[i] as! NSDictionary
                        
                        if(item.get("place_id") != ""){
                            let structured_formatting = item.getObj("structured_formatting")
                            let searchLocItem = SearchLocationItem(placeId: item.get("place_id"), mainAddress: structured_formatting.get("main_text"), subAddress: structured_formatting.get("secondary_text"), description: item.get("description"), session_token: session_token, location: nil)
                            
                            self.searchPlaceDataArr += [searchLocItem]
                        }
                        
                    }
                    
                    
                    self.searchPlaceTableView.reloadData()
                    
                }else if(dataDict.get("status") == "ZERO_RESULTS"){
                    if(self.errorLbl != nil){
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT")
                    }else{
                        self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
                        
                        self.errorLbl.isHidden = false
                    }
                    
                }else{
                    if(self.errorLbl != nil){
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                    }else{
                        self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                        
                        self.errorLbl.isHidden = false
                    }
                }
                
                
            }else{
                //                self.generalFunc.setError(uv: self)
                if(self.errorLbl != nil){
                    self.errorLbl.isHidden = false
                    self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                }else{
                    self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                    self.errorLbl.isHidden = false
                }
            }
            
            self.loaderView.isHidden = true
        }, url: autoCompleteUrl)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchPlaecFromTxt(searchText: searchBar.text ?? "")
    }
    
    func fetchPlaecFromTxt(searchText:String){
        
        if(searchText.count < MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE){
            self.existingPlacesView.isHidden = self.isFromSelectLoc == true ? true : false
            self.searchPlaceTableView.isHidden = true
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
            
            if(self.errorLbl != nil){
                self.errorLbl.isHidden = true
            }
            
            return
        }else{
            //            defaultPageHeight = self.PAGE_HEIGHT
            
            self.existingPlacesView.isHidden = true
            self.searchPlaceTableView.isHidden = false
        }
        
        self.searchPlaceDataArr.removeAll()
        self.searchPlaceTableView.reloadData()
        
        if(self.errorLbl != nil){
            self.errorLbl.isHidden = true
        }
        
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
    
        
        var autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(searchText)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true&inputtype=textquery&fields=photos,formatted_address,name,rating,geometry"
        
        if(locationBias != nil){
            autoCompleteUrl = "\(autoCompleteUrl)&location=\(locationBias.coordinate.latitude),\(locationBias.coordinate.longitude)&radius=20000"
        }
        
        if(placeSearchExeServerTask != nil){
            placeSearchExeServerTask.cancel()
            placeSearchExeServerTask = nil
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: false)
        self.placeSearchExeServerTask = exeWebServerUrl
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(self.currentSearchQuery != searchText){
                return
            }
            
            if(response != ""){
                
                
                if(self.errorLbl != nil){
                    self.errorLbl.isHidden = true
                }
                
                if(self.searchPlaceTableView.isHidden == true){
                    self.loaderView.isHidden = true
                    return
                }
                let dataDict = response.getJsonDataDict()
                
                print(dataDict)
                if(dataDict.get("status").uppercased() == "OK"){
                    
                    let predictionsArr = dataDict.getArrObj("candidates")
                    
                    for i in 0..<predictionsArr.count{
                        let item = predictionsArr[i] as! NSDictionary
                        
                        if(item.get("formatted_address") != ""){
                            let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.getObj("geometry").getObj("location").get("lat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.getObj("geometry").getObj("location").get("lng")))
                            
                            let searchLocItem = SearchLocationItem(placeId: "", mainAddress: item.get("formatted_address"), subAddress: "", description: "", session_token: "", location: location)
                            
                            self.searchPlaceDataArr += [searchLocItem]
                        }
                        
                    }
                    
                    self.searchPlaceTableView.reloadData()
                    
                }else if(dataDict.get("status") == "ZERO_RESULTS"){
                    if(self.errorLbl != nil){
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT")
                    }else{
                        self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
                        
                        self.errorLbl.isHidden = false
                    }
                    
                }else{
                    if(self.errorLbl != nil){
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                    }else{
                        self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                        
                        self.errorLbl.isHidden = false
                    }
                }
                
                
            }else{
                //                self.generalFunc.setError(uv: self)
                if(self.errorLbl != nil){
                    self.errorLbl.isHidden = false
                    self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                }else{
                    self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                    self.errorLbl.isHidden = false
                }
            }
            
            self.loaderView.isHidden = true
        }, url: autoCompleteUrl)
    }
    
    @objc func addDestLaterTapped(){
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelected(location: CLLocation(latitude: 0.0, longitude: 0.0), address: "DEST_SKIPPED", searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    @objc func findLocOnMap(){
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
        addDestinationUv.isForDriverDestinations = self.isForDriverDestinations
        
        addDestinationUv.centerLocation = self.locationBias
        
        self.pushToNavController(uv: addDestinationUv)
    }
    
    @objc func homePlaceTapped(){
        //        self.closeCurrentScreen()
        //        self.mainScreenUV.continueLocationSelected(selectedLocation: , selectedAddress: (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String))
        
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelected(location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLatitude") as! String), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLongitude") as! String)), address: (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String), searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    @objc func workPlaceTapped(){
        //        self.closeCurrentScreen()
        //        self.mainScreenUV.continueLocationSelected(selectedLocation: , selectedAddress: )
        
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelected(location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLatitude") as! String), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLongitude") as! String)), address: (GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String), searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.placesHLbl){
            
        }else if(sender == self.homeLocHLbl || sender == self.homeLocVLbl){
            if(isHomePlaceAdded){
                homePlaceTapped()
            }else{
                homePlaceEditTapped()
            }
        }else if(self.cancelLbl != nil && sender == cancelLbl){
            searchBarCancelButtonClicked(self.searchBar)
        }
    }
    
    
    func getHomePlaceTapGue() -> UITapGestureRecognizer{
        let homePlaceTapGue = UITapGestureRecognizer()
        homePlaceTapGue.addTarget(self, action: #selector(self.homePlaceTapped))
        
        return homePlaceTapGue
    }
    
    func getWorkPlaceTapGue() -> UITapGestureRecognizer{
        let workPlaceTapGue = UITapGestureRecognizer()
        workPlaceTapGue.addTarget(self, action: #selector(self.workPlaceTapped))
        
        return workPlaceTapGue
    }
    
    func checkRecentPlaces(){
        
//        self.dataArrList.removeAll()
     
        let destLocations = userProfileJson.getArrObj("DestinationLocations")
        
        for i in 0..<destLocations.count{
            let currentItem = destLocations[i] as! NSDictionary
            
//            let recentLocItem = RecentLocationItem(location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("tDestLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("tDestLongitude"))), address: currentItem.get("tDaddress"))
//
//            self.dataArrList += [recentLocItem]
        }
        
//        if(self.dataArrList.count < 1 ){
//            self.recentLocTableView.isHidden = true
//            self.recentLocationHLbl.isHidden = true
//        }else{
//            self.recentLocTableView.isHidden = false
//            self.recentLocationHLbl.isHidden = false
//        }
        
        var dataArrHeight:CGFloat = 0
        
//        for i in 0..<self.dataArrList.count{
//            let address = self.dataArrList[i].address
//            var height = address!.height(withConstrainedWidth: Application.screenSize.width - 77, font: UIFont(name: Fonts().light, size: 16)!)
//            if(height < 50){
//                height = 50
//            }
//            dataArrHeight = dataArrHeight + height
//        }
        
        PAGE_HEIGHT = PAGE_HEIGHT + dataArrHeight
        self.finalPageHeight = PAGE_HEIGHT
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        self.recentLocTableView.isScrollEnabled = false
        self.recentLocTableView.reloadData()
        
    }
    
    func checkPlaces(){
        
        if(fromAddAddress != true){
            checkRecentPlaces()
        }
        
        let userHomeLocationAddress = GeneralFunctions.getValue(key: "userHomeLocationAddress") != nil ? (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String) : ""
       
        if(userHomeLocationAddress != ""){
            isHomePlaceAdded = true
            
            self.homeLocEditImgView.image = UIImage(named: "ic_edit")
            self.homeLocHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_PLACE")
            self.homeLocVLbl.text = GeneralFunctions.getValue(key: "userHomeLocationAddress") as? String
            
            let homeLatitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLatitude") as! String)
            let homeLongitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLongitude") as! String)
            
            self.homeLoc = CLLocation(latitude: homeLatitude, longitude: homeLongitude)
            
        }else{
            self.homeLocEditImgView.image = UIImage(named: "ic_add_plus")
            self.homeLocVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_HOME_PLACE_TXT")
            self.homeLocHLbl.text = "----"
            
            isHomePlaceAdded = false
        }
        
        self.homeLocHLbl.setClickDelegate(clickDelegate: self)
        self.homeLocVLbl.setClickDelegate(clickDelegate: self)
        
        self.homeLocImgView.isUserInteractionEnabled = true
        self.homeLocImgView.addGestureRecognizer(self.getHomePlaceTapGue())
        
        
        GeneralFunctions.setImgTintColor(imgView: self.homeLocImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: self.homeLocEditImgView, color: UIColor(hex: 0x909090))
       
        let homePlaceTapGue = UITapGestureRecognizer()
        homePlaceTapGue.addTarget(self, action: #selector(self.homePlaceEditTapped))
        self.homeLocEditImgView.isUserInteractionEnabled = true
        self.homeLocEditImgView.addGestureRecognizer(homePlaceTapGue)
       
    }
    
    @objc func homePlaceEditTapped(){
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
        addDestinationUv.isForDriverDestinations = self.isForDriverDestinations
        addDestinationUv.SCREEN_TYPE = "HOME"
      
        self.pushToNavController(uv: addDestinationUv)
    }
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
//        if(tableView == self.searchPlaceTableView){
//
//        }
        return self.searchPlaceDataArr.count
//        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if(tableView == self.searchPlaceTableView){
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GPAutoCompleteListTVCell", for: indexPath) as! GPAutoCompleteListTVCell
        
        let item = self.searchPlaceDataArr[indexPath.item]
        
        cell.mainTxtLbl.text = item.mainAddress
        cell.secondaryTxtLbl.text = item.subAddress
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentLocationTVCell", for: indexPath) as! RecentLocationTVCell
//
//        let item = self.dataArrList[indexPath.item]
//
//        cell.recentAddressLbl.text = item.address
//
//        cell.selectionStyle = .none
//        cell.backgroundColor = UIColor.clear
//        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == self.searchPlaceTableView){
            let item = self.searchPlaceDataArr[indexPath.item]
            if(item.location != nil){
                let location = item.location!
                
                if(self.placeSelectDelegate != nil){
                    self.placeSelectDelegate?.onPlaceSelected(location: location, address: item.mainAddress, searchBar: self.searchBar, searchPlaceUv: self)
                }
            }else{
                findPlaceDetail(placeId: item.placeId, description: item.description, session_token: item.session_token)
            }
            return
        }
        
//        let item = self.dataArrList[indexPath.item]
        
        //        self.closeCurrentScreen()
        //        self.mainScreenUV.continueLocationSelected(selectedLocation: item.location, selectedAddress: item.address)
        
//        if(self.placeSelectDelegate != nil){
//            self.placeSelectDelegate?.onPlaceSelected(location: item.location, address: item.address, searchBar: self.searchBar, searchPlaceUv: self)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if(tableView == self.searchPlaceTableView){
            tableView.estimatedRowHeight = 1500
            tableView.rowHeight = UITableView.automaticDimension
            return UITableView.automaticDimension
        }else{
            tableView.estimatedRowHeight = 1500
            tableView.rowHeight = UITableView.automaticDimension
            if(UITableView.automaticDimension < 50){
                return 50
            }else{
                return UITableView.automaticDimension
            }
        }
    }
    
    func findPlaceDetail(placeId:String, description:String, session_token:String){
        
        let placeDetailUrl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true&fields=formatted_address,name,geometry&sessiontoken=\(session_token)"
        
        Utils.printLog(msgData: "PlaceDetailURL:\(placeDetailUrl)")
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: true)
        self.placeSearchExeServerTask = exeWebServerUrl
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("status").uppercased() == "OK"){
                    
                    let resultObj = dataDict.getObj("result")
                    let geometryObj = resultObj.getObj("geometry")
                    let locationObj = geometryObj.getObj("location")
                    let latitude = locationObj.get("lat")
                    let longitude = locationObj.get("lng")
                    
                    let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: latitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: longitude))
                    
                    if(self.placeSelectDelegate != nil){
                        self.placeSelectDelegate?.onPlaceSelected(location: location, address: description, searchBar: self.searchBar, searchPlaceUv: self)
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
                
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
        }, url: placeDetailUrl)
        
    }
    
    @IBAction func unwindToSearchPlaceScreen(_ segue:UIStoryboardSegue) {
        //        unwindToSignUp
        
        if(segue.source.isKind(of: AddDestinationUV.self))
        {
            let addDestinationUv = segue.source as! AddDestinationUV
            let selectedLocation = addDestinationUv.selectedLocation
            let selectedAddress = addDestinationUv.selectedAddress
            
            GeneralFunctions.setSelectedLocations(latitude: selectedLocation!.coordinate.latitude, longitude: selectedLocation!.coordinate.longitude, address: selectedAddress, type: addDestinationUv.SCREEN_TYPE)
            
            //            self.mainScreenUV.continueLocationSelected(selectedLocation: selectedLocation, selectedAddress: selectedAddress)
            if(self.placeSelectDelegate != nil){
                self.placeSelectDelegate?.onPlaceSelected(location: selectedLocation!, address: selectedAddress, searchBar: self.searchBar, searchPlaceUv: self)
            }
            
        }
    }
}

class SearchLocationItem {
    
    var placeId:String!
    var mainAddress:String!
    var subAddress:String!
    var description:String!
    var session_token:String!
    var location:CLLocation?
    
    // MARK: Initialization
    
    init(placeId: String, mainAddress:String, subAddress:String, description:String, session_token: String, location:CLLocation?) {
        // Initialize stored properties.
        self.placeId = placeId
        self.mainAddress = mainAddress
        self.subAddress = subAddress
        self.description = description
        self.session_token = session_token
        self.location = location
        
    }
}
