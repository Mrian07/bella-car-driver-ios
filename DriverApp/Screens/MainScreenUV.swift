//
//  MainScreenUV.swift
//  DriverApp
//
//  Created by ADMIN on 11/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import SwiftExtensionData

class MainScreenUV: UIViewController, OnLocationUpdateDelegate, CMSwitchViewDelegate, OnTaskRunCalledDelegate, GMSMapViewDelegate, MyLabelClickDelegate, UITableViewDelegate, UITableViewDataSource, AddressFoundDelegate, MyBtnClickDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var googleMapContainerView: UIView!
    @IBOutlet weak var statusLbl: MyLabel!
    @IBOutlet weak var statusSwitch: CMSwitchView!
    @IBOutlet weak var changeCarLbl: MyLabel!
    @IBOutlet weak var carNameLBl: MyLabel!
    @IBOutlet weak var carNumLbl: MyLabel!
    @IBOutlet weak var userPicImgView: UIImageView!
    @IBOutlet weak var myLocImgView: UIImageView!
    @IBOutlet weak var heatMapImgView: UIImageView!
    @IBOutlet weak var taxiHailImgView: UIImageView!
    @IBOutlet weak var ufxScrollView: UIScrollView!
    @IBOutlet weak var driverDetailBottomCOntainerViewHeight: NSLayoutConstraint!
    
    //WorkLocation Outlets
    @IBOutlet weak var workLocArea: UIView!
    @IBOutlet weak var workLocAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var workLocLbl: MyLabel!
    @IBOutlet weak var workLocImgView: UIImageView!
    @IBOutlet weak var editWorkLocBtn: MyButton!
    
    // UFXMain screen OutLets
    @IBOutlet weak var ufxHeaderView: UIView!
    @IBOutlet weak var jobLocHLbl: MyLabel!
    @IBOutlet weak var jobLocAddLbl: MyLabel!
    @IBOutlet weak var availabilityRadiusLbl: MyLabel!
    @IBOutlet weak var availRadiusLblWidth: NSLayoutConstraint!
    @IBOutlet weak var editAvailRadiusImgView: UIImageView!
    @IBOutlet weak var upcomingJobCountLbl: MyLabel!
    @IBOutlet weak var jobAreaSeperatorView: UIView!
    @IBOutlet weak var pendingJobAreaView: UIView!
    @IBOutlet weak var upcomingJobAreaView: UIView!
    @IBOutlet weak var pendingJobCountLbl: MyLabel!
    @IBOutlet weak var pendingJobLbl: MyLabel!
    @IBOutlet weak var upcomingJobLbl: MyLabel!
    @IBOutlet weak var ufxUserNameLbl: MyLabel!
    @IBOutlet weak var ufxJobLocAreaHeight: NSLayoutConstraint!
    
    // Select Car Design Outlets
    @IBOutlet weak var selectCarHImgView: UIImageView!
    @IBOutlet weak var selectCarHLbl: MyLabel!
    @IBOutlet weak var selectCarTableView: UITableView!
    @IBOutlet weak var addNewVehicleLbl: MyLabel!
    @IBOutlet weak var manageVehiclesLbl: MyLabel!
    
    // DRIVER DESTINATION MODE //
    @IBOutlet weak var driverDestiImgView: UIImageView!
    @IBOutlet weak var hailImgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var driverDestinationModeView: UIView!
    @IBOutlet weak var destAddressLbl: MyLabel!
    @IBOutlet weak var destAddressSHLbl: MyLabel!
    @IBOutlet weak var cancelimgView: UIImageView!
    @IBOutlet weak var startDestModeBtn: MyButton!
    @IBOutlet weak var destModeViewHeight: NSLayoutConstraint!
    let linearBar: LinearProgressBar = LinearProgressBar()
    @IBOutlet weak var driverDestTopHeight: NSLayoutConstraint!
    @IBOutlet weak var driverDestTopCloseView: UIImageView!
    @IBOutlet weak var driverDestTopView: UIView!
    @IBOutlet weak var destAddressTopLbl: MyLabel!
    @IBOutlet weak var destAddressTopAnimatedView: UIView!
    @IBOutlet weak var destModeOnTopLbl: MyLabel!
    
    var userProfileJson:NSDictionary!
    
    var navItem:UINavigationItem!
    
    
    var getAddressFromLocation:GetAddressFromLocation!
    
    var gMapView:GMSMapView!
    
    let generalFunc = GeneralFunctions()
    
    var getLocation:GetLocation!
    
    var isDriverOnline:Bool = false
    
    var currentLocation:CLLocation?
    
    var isHeatMapEnabled = false
    
    var task_update_heatMapData: ExeServerUrl?
    
    var historyData = [String]()
    var onlineData = [String]()
    
    var currentRadius = 0.0
    var dtaCircleHeatMap = [GMSMarker]()
    
    var updateCurrentReqFreqTask:UpdateFreqTask!
    var currentReqTaskPosition = 0
    var isFirstLocationUpdate = true
    
    var window:UIWindow!
    
    var isDataSet = false
    
    var updateDriverStatus:UpdateDriverStatus!
    
    var carListDataArrList = [NSDictionary]()
    
    var selectCarView:UIView!
    var selectCarBGView:UIView!
    
    let userLocTapGue = UITapGestureRecognizer()
    
    var locationDialog:OpenLocationEnableView!
    
    var isMyLocationEnabled = true
    
    private var gradientColors = [UIColor.red , UIColor.white]
    private var gradientStartPoints = [0.005,1.0]
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var onlineHeatmapLayer: GMUHeatmapTileLayer!
    private var onlineGradientColors = [UIColor.green]
    private var onlineGradientStartPoints = [0.2]
    
    var isCameraUpdateIgnore = false
    
    var ufxPAGE_HEIGHT:CGFloat = 550
    var ufxCntView:UIView!
    var cntView:UIView!
    
    var isSafeAreaSet = false
    
    var PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT:Double = 5
    
    var lastPublishedLoc:CLLocation!
    
    var APPSTORE_MODE_IOS:AnyObject?
    
    
    // DRIVER DESTINATION MODE //
    var driverDestinationModeLat = ""
    var driverDestinationModeLong = ""
    var driverDestinationAddress = ""
    var directionFailedDialog:MTDialog!
    var driverRoutesLat = ""
    var driverRoutesLong = ""
    var listOfPoints = [String()]
    var listOfPaths = [GMSPolyline]()
    var DRIVER_DESTINATION_AVAILABLE = "NO"
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        if(self.userProfileJson != nil){
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            self.userProfileJson = userProfileJson
            userPicImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImage"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
            
            if(userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
                self.navigationController?.navigationBar.layer.zPosition = -1
                
                if(self.ufxUserNameLbl != nil){
                    self.ufxUserNameLbl.text = "\(userProfileJson.get("vName").uppercased()) \(userProfileJson.get("vLastName").uppercased())"
                    getProviderStates()
                }
            }
        }
        
        GeneralFunctions.saveValue(key: "IS_LIVE_TASK_AVAILABLE", value: "false" as AnyObject)
     
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            
            if(cntView != nil){
                cntView.frame.size.height = cntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
                driverDetailBottomCOntainerViewHeight.constant = driverDetailBottomCOntainerViewHeight.constant + GeneralFunctions.getSafeAreaInsets().bottom
                if(Configurations.isIponeXDevice()){
                    self.driverDetailBottomCOntainerViewHeight.constant = self.driverDetailBottomCOntainerViewHeight.constant - 20
                }
            }
            
            if(ufxCntView != nil){
                ufxCntView.frame.size.height = ufxCntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
            }
            
            isSafeAreaSet = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
         // DRIVER DESTINATION MODE //
        DRIVER_DESTINATION_AVAILABLE = self.userProfileJson.get("DRIVER_DESTINATION_AVAILABLE").uppercased()
        
        
        
        APPSTORE_MODE_IOS = GeneralFunctions.getValue(key: Utils.APPSTORE_MODE_IOS_KEY)
        
        /** Used for configDriverTripStatus Type */
        GeneralFunctions.saveValue(key: "iTripId", value: "" as AnyObject)
        /** Used for configDriverTripStatus Type */
        
        PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT = GeneralFunctions.parseDouble(origValue: 5, data: GeneralFunctions.getValue(key: Utils.PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT_KEY) as! String)

        if(userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
            cntView = self.generalFunc.loadView(nibName: "MainScreenDesign", uv: self, contentView: contentView)
            self.contentView.addSubview(cntView)
        }else{
            
            ufxCntView = self.generalFunc.loadView(nibName: "UFXMainScreenDesign", uv: self, contentView: self.ufxScrollView)
            ufxCntView.frame.size = CGSize(width: ufxCntView.frame.width, height: ufxPAGE_HEIGHT)
            
            self.ufxHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES" && self.pendingJobAreaView != nil && self.jobAreaSeperatorView != nil){
                self.pendingJobAreaView.isHidden = true
                self.jobAreaSeperatorView.isHidden = true
                self.upcomingJobAreaView.isHidden = true
                ufxPAGE_HEIGHT = ufxPAGE_HEIGHT - 150
            }
            
            self.ufxScrollView.contentSize = CGSize(width: self.ufxScrollView.frame.size.width, height: ufxPAGE_HEIGHT)
            self.ufxScrollView.isHidden = false
            self.ufxScrollView.addSubview(ufxCntView)
            self.ufxScrollView.bounces = false
        }
        
        Utils.driverMarkersPositionList.removeAll()
        Utils.driverMarkerAnimFinished = true
        
        window = Application.window!
        
        Utils.createRoundedView(view: userPicImgView, borderColor: Color.clear, borderWidth: 0)
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            heatMapImgView.isHidden = true
        }

        taxiHailImgView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: taxiHailImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        let taxiHailTapGue = UITapGestureRecognizer()
        taxiHailTapGue.addTarget(self, action: #selector(self.openTaxiHail))
        taxiHailImgView.isUserInteractionEnabled = true
        
        taxiHailImgView.addGestureRecognizer(taxiHailTapGue)
        self.hideShowHail(isHide: true)
        
        GeneralFunctions.removeValue(key: "OPEN_MSG_SCREEN")
        
        setData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
        self.setWorkLocationArea(isHide: true)
        
       
    }
    
    deinit {
        releaseAllTask()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.userProfileJson != nil){
           
            if(userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
                self.navigationController?.navigationBar.layer.zPosition = 1
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
//        Utils.printLog(msgData: "MemoryWarningReceived")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isDataSet == false){
            DispatchQueue.main.async {
                let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 0.0)
                self.gMapView = GMSMapView.map(withFrame: self.googleMapContainerView.frame, camera: camera)
                
                if(GeneralFunctions.hasLocationEnabled() == true){
                    self.gMapView.isMyLocationEnabled = self.isMyLocationEnabled
                }
                
                self.gMapView.delegate = self
                self.googleMapContainerView.addSubview(self.gMapView)
                
                self.getLocation = GetLocation(uv: self, isContinuous: true)
                self.getLocation.buildLocManager(locationUpdateDelegate: self)
                
                if(self.ufxCntView != nil){
                    self.ufxCntView.frame.size = CGSize(width: self.ufxCntView.frame.width, height: self.ufxPAGE_HEIGHT)
                    self.ufxScrollView.contentSize = CGSize(width: self.ufxScrollView.frame.size.width, height: self.ufxPAGE_HEIGHT)
                }
                
                self.checkLocationEnabled()
                self.isDataSet = true
                
                if((self.userProfileJson.get("eEmailVerified").uppercased() != "YES" && self.userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES") || (self.userProfileJson.get("ePhoneVerified").uppercased() != "YES" && self.userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES") ){
                    
                    let verifyBtn = Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT_TXT"), uv: self, btnTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_VERIFY_TXT"), delayShow: 1, delayHide: 15)
                    
                    verifyBtn.addTarget(self, action: #selector(self.openAccountVerify(sender:)), for: UIControl.Event.touchUpInside)
                }
            }
//             // DRIVER DESTINATION MODE //
//            self.driverDestinationModeSetup() // DRIVER DESTINATION MODE //
        }
        
        if(GeneralFunctions.getValue(key: "IS_WORK_LOCATION_CHANGED") != nil){
            
            let dataStr = GeneralFunctions.getValue(key: "IS_WORK_LOCATION_CHANGED") as! String
            if(dataStr.uppercased() == "YES" && userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
                
                let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                self.userProfileJson = userProfileJson
                
                if(userProfileJson.get("eSelectWorkLocation").uppercased() == "FIXED"){
                    onAddressFound(address: userProfileJson.get("vWorkLocation"), location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: userProfileJson.get("vWorkLocationLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: userProfileJson.get("vWorkLocationLongitude"))), isPickUpMode: false, dataResult: "")
                }else{
                    self.onRefreshCalled()
                }
            }
            
            GeneralFunctions.removeValue(key: "IS_WORK_LOCATION_CHANGED")
        }
    }
    
    
    func setData(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        GeneralFunctions.saveValue(key: "IS_DRIVER_ONLINE", value: "false" as AnyObject)
        
        userPicImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImage"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        
        self.statusSwitch.delegate = self
        
        if(userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            self.changeCarLbl.isHidden = true
            self.carNumLbl.isHidden = true
            self.carNameLBl.text = " \(userProfileJson.get("vName")) \(userProfileJson.get("vLastName"))"
            self.carNameLBl.textColor = UIColor.UCAColor.AppThemeColor
            
            statusSwitch.dotColor = UIColor(hex: 0xFFFFFF)
            statusSwitch.color = UIColor(hex: 0xFF0000)
            statusSwitch.tintColor = UIColor(hex: 0xFF0000)
            
            self.jobLocHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Your Job Location", key: "LBL_YOUR_JOB_LOCATION_TXT").uppercased()
            self.jobLocAddLbl.text = "-----"
            self.pendingJobLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pending Jobs", key: "LBL_PENDING_JOBS").uppercased()
            self.pendingJobCountLbl.text = "--"
            
            self.upcomingJobLbl.text = self.generalFunc.getLanguageLabel(origValue: "Upcoming Jobs", key: "LBL_UPCOMING_JOBS").uppercased()
            self.upcomingJobCountLbl.text = "--"
            
            self.ufxUserNameLbl.text = "\(userProfileJson.get("vName").uppercased()) \(userProfileJson.get("vLastName").uppercased())"
            
            self.availabilityRadiusLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "Within", key: "LBL_WITHIN")) \(userProfileJson.get("vWorkLocationRadius")) \(self.generalFunc.getLanguageLabel(origValue: "", key: userProfileJson.get("eUnit") == "KMs" ? "LBL_KM_DISTANCE_TXT" : "LBL_MILE_DISTANCE_TXT")) \(self.generalFunc.getLanguageLabel(origValue: "Work Radius", key: "LBL_RADIUS"))"
            GeneralFunctions.setImgTintColor(imgView: self.editAvailRadiusImgView, color: UIColor.UCAColor.AppThemeColor)
            
            let availRadiusTapGue = UITapGestureRecognizer()
            availRadiusTapGue.addTarget(self, action: #selector(self.openAvailRadius))
            
            self.editAvailRadiusImgView.isUserInteractionEnabled = true
            self.editAvailRadiusImgView.addGestureRecognizer(availRadiusTapGue)
            
            self.pendingJobCountLbl.setClickDelegate(clickDelegate: self)
            self.upcomingJobCountLbl.setClickDelegate(clickDelegate: self)
            
            setUFXRadiusLblFrame()
            
            getProviderStates()
            
            
        }else{
            self.changeCarLbl.isHidden = false
            self.carNumLbl.isHidden = false
            
            self.changeCarLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE").uppercased()
            self.changeCarLbl.setClickDelegate(clickDelegate: self)
            self.carNumLbl.text = userProfileJson.get("vLicencePlateNo") == "" ? "" : userProfileJson.get("vLicencePlateNo")
            
            self.carNameLBl.text = (userProfileJson.get("vMake") == "" && userProfileJson.get("vModel") == "") ? "" : "\(userProfileJson.get("vMake")) \(userProfileJson.get("vModel"))"
            self.carNumLbl.textColor = UIColor.white
            self.carNameLBl.textColor = UIColor.white
            statusSwitch.dotColor = UIColor(hex: 0xFF0000)
            statusSwitch.color = UIColor(hex: 0xFFFFFF)
            statusSwitch.tintColor = UIColor(hex: 0xFFFFFF)
        }
        
        self.statusLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GO_ONLINE_TXT").uppercased()
        
        let heatViewTapGue = UITapGestureRecognizer()
        heatViewTapGue.addTarget(self, action: #selector(self.heatViewTapped(sender:)))
        heatMapImgView.isUserInteractionEnabled = true
        
        heatMapImgView.addGestureRecognizer(heatViewTapGue)
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            heatMapImgView.isHidden = true
            heatMapImgView.frame.origin.x = heatMapImgView.frame.origin.x - heatMapImgView.frame.size.width - 15
        }
        
        ConfigPubNub.getInstance().buildPubNub()
        
        self.userLocTapGue.addTarget(self, action: #selector(self.myLocImgTapped))
        self.myLocImgView.isUserInteractionEnabled = true
        self.myLocImgView.addGestureRecognizer(self.userLocTapGue)
        
        checkPendingRequests()
        
        deleteTripStatusMessages()
        
        if((userProfileJson.get("eEmailVerified").uppercased() != "YES" && userProfileJson.get("DRIVER_EMAIL_VERIFICATION").uppercased() == "YES") || (userProfileJson.get("ePhoneVerified").uppercased() != "YES" && userProfileJson.get("DRIVER_PHONE_VERIFICATION").uppercased() == "YES") ){
            
            let verifyBtn = Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT_TXT"), uv: self, btnTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_VERIFY_TXT"), delayShow: 1, delayHide: 15)
            verifyBtn.addTarget(self, action: #selector(self.openAccountVerify(sender:)), for: UIControl.Event.touchUpInside)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appTerminated), name: NSNotification.Name(rawValue: Utils.appKilledNotificationKey), object: nil)
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("eShowVehicles").uppercased() == "NO"){
            self.carNameLBl.isHidden = true
            self.carNumLbl.isHidden = true
            self.changeCarLbl.isHidden = true
        }
        
    }
    
    func setWorkLocationArea(isHide:Bool){
        if(workLocAreaHeight != nil){
            if( isHide == false){
                self.editWorkLocBtn.bgColor = UIColor(hex: 0xFFFFFF)
                self.editWorkLocBtn.titleColor = UIColor(hex: 0x000000)
                self.editWorkLocBtn.pulseColor = UIColor(hex: 0xFFFFFF).darker(by: 20)
                self.editWorkLocBtn.enableCustomColor()
                self.editWorkLocBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT"))
                self.workLocLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_WORK_LOCATION")
                self.workLocLbl.textColor = UIColor(hex: 0xFFFFFF)
                GeneralFunctions.setImgTintColor(imgView: self.workLocImgView, color: UIColor(hex: 0xFFFFFF))
                self.workLocArea.isHidden = false
                self.workLocAreaHeight.constant = 50
                self.editWorkLocBtn.clickDelegate = self
            }else{
                workLocAreaHeight.constant = 0
                self.workLocArea.isHidden = true
            }
        }
    }
    
    func setUFXRadiusLblFrame(){
        
        let totalWidth = self.availabilityRadiusLbl.text!.width(withConstrainedHeight: 20, font: UIFont(name: Fonts().light, size: 17)!) + 10
        let availWidth = Application.screenSize.width - 90
        
        if(totalWidth > availWidth){
            self.availRadiusLblWidth.constant = availWidth
        }else{
            self.availRadiusLblWidth.constant = totalWidth
        }
    }
    
    @objc func openAvailRadius(){
    }
    
    func getProviderStates(){
        
        let parameters = ["type":"GetUserStats", "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.pendingJobCountLbl.text = dataDict.get("Pending_Count")
                    self.upcomingJobCountLbl.text = dataDict.get("Upcoming_Count")
                    
                    self.availabilityRadiusLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "Within", key: "LBL_WITHIN")) \(dataDict.get("Radius")) \(self.generalFunc.getLanguageLabel(origValue: "", key: self.userProfileJson.get("eUnit") == "KMs" ? "LBL_KM_DISTANCE_TXT" : "LBL_MILE_DISTANCE_TXT")) \(self.generalFunc.getLanguageLabel(origValue: "Work Radius", key: "LBL_RADIUS"))"
                    
                    self.setUFXRadiusLblFrame()
                }
                
            }else{
                
//                if(isAlertShown == true){
//                    self.generalFunc.setError(uv: self)
//                }
            }
            
        })
    }
    
    @objc func openTaxiHail(){
        let parameters = ["type":"CheckVehicleEligibleForHail","iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let taxiHailUv = GeneralFunctions.instantiateViewController(pageName: "TaxiHailUV") as! TaxiHailUV
                    self.pushToNavController(uv: taxiHailUv)
                    
                }else{
                    if(dataDict.get(Utils.message_str) == "REQUIRED_MINIMUM_BALNCE"){
                        //                self.generalFunc.setError(uv: self, title: "", content: dict.get("Msg"))
                        let openMinAmountReqView = OpenMinAmountReqView(uv: self, containerView: self.contentView)
                        openMinAmountReqView.setHandler(handler: { (isSkipped, isOpenWallet, view, bgView) in
                            if(isOpenWallet == true){
                                if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() == "CASH" || (self.APPSTORE_MODE_IOS != nil && (self.APPSTORE_MODE_IOS as! String).uppercased() == "REVIEW")){
                                    let contactUsUV = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                    self.pushToNavController(uv: contactUsUV)
                                }else{
                                    let manageWalletUv = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    self.pushToNavController(uv: manageWalletUv)
                                }
                            }
                        })
                        openMinAmountReqView.show(msg: dataDict.get("Msg"))
                        return
                    }
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    func checkLocationEnabled(){
        if(locationDialog != nil){
            locationDialog.removeView()
            locationDialog = nil
        }
        
        if(GeneralFunctions.hasLocationEnabled() == false || InternetConnection.isConnectedToNetwork() == false){
            if(APPSTORE_MODE_IOS != nil && (APPSTORE_MODE_IOS as! String).uppercased() != "REVIEW"){
                locationDialog = OpenLocationEnableView(uv: self, containerView: self.cntView == nil ? (self.ufxCntView == nil ? UIView() : self.ufxCntView) : self.cntView , gMapView: self.gMapView, isMapLocEnabled: isMyLocationEnabled)
                locationDialog.show()
                
                if(GeneralFunctions.hasLocationEnabled() == false){
                    goOffline(isAlertShown: false)
                }
            }
            return
        }else{
            if(self.gMapView != nil && self.gMapView.isMyLocationEnabled != self.isMyLocationEnabled){
                self.gMapView.isMyLocationEnabled = self.isMyLocationEnabled
            }
        }
        
    }
    
    @objc func appTerminated(){
        
        let parameters = ["type":"updateDriverStatus", "isUpdateOnlineDate": "", "iDriverId": GeneralFunctions.getMemberd(),"latitude": "", "longitude": "", "Status": "Not Available"]
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in

        })

        sleep(4)
    }
    
    @objc func appInForground(){
        checkLocationEnabled()
        
        if(userProfileJson != nil && userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            self.navigationController?.navigationBar.layer.zPosition = -1
            
            if(self.ufxUserNameLbl != nil){                
                getProviderStates()
            }
        }
    }
    
    @objc func openAccountVerify(sender:FlatButton){
        
        self.snackbarController?.animate(snackbar: .hidden, delay: 0)
        
        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
        if(userProfileJson.get("eEmailVerified").uppercased() != "YES" && userProfileJson.get("ePhoneVerified").uppercased() != "YES" ){
            accountVerificationUv.requestType = "DO_EMAIL_PHONE_VERIFY"
        }else if(userProfileJson.get("eEmailVerified").uppercased() != "YES"){
            accountVerificationUv.requestType = "DO_EMAIL_VERIFY"
        }else{
            accountVerificationUv.requestType = "DO_PHONE_VERIFY"
        }
        accountVerificationUv.mainScreenUv = self
        self.pushToNavController(uv: accountVerificationUv)
    }
    
    @objc func myLocImgTapped(){
        if(GeneralFunctions.hasLocationEnabled() == true){
            if(self.currentLocation == nil){
                return
            }

            let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation!.coordinate.latitude,
                                                  longitude: self.currentLocation!.coordinate.longitude, zoom: Utils.defaultZoomLevel)
            
            self.gMapView.animate(to: camera)
        }
        else{
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
        }
    }
    
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.changeCarLbl){
            self.loadAvailableCar()
        }else if(self.manageVehiclesLbl != nil && sender == self.manageVehiclesLbl){
            self.selectCarBGView.removeFromSuperview()
            self.selectCarView.removeFromSuperview()
            
            openManageVehiclesScreen()
        }else if(self.addNewVehicleLbl != nil && sender == self.addNewVehicleLbl){
            self.selectCarBGView.removeFromSuperview()
            self.selectCarView.removeFromSuperview()
            
            let addVehiclesUv = GeneralFunctions.instantiateViewController(pageName: "AddVehiclesUV") as! AddVehiclesUV
            addVehiclesUv.isFromMainPage = true
            addVehiclesUv.mainScreenUv = self
             self.pushToNavController(uv: addVehiclesUv)
        }else if(self.pendingJobCountLbl != nil && sender == self.pendingJobCountLbl){
            openHistory(isFirstUpcoming: false)
        }else if(self.upcomingJobCountLbl != nil && sender == self.upcomingJobCountLbl){
            openHistory(isFirstUpcoming: true)
        }
    }
    
    
    func openHistory(isFirstUpcoming:Bool){
        
        let rideHistoryUv = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
        let myBookingsUv = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
        let pendingBookingsUv = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
        rideHistoryUv.HISTORY_TYPE = "PAST"
        myBookingsUv.HISTORY_TYPE = "LATER"
        pendingBookingsUv.HISTORY_TYPE = "PENDING"
        
        rideHistoryUv.pageTabBarItem.title = self.generalFunc.getLanguageLabel(origValue: "PAST", key: "LBL_PAST")
        myBookingsUv.pageTabBarItem.title = self.generalFunc.getLanguageLabel(origValue: "UPCOMING", key: "LBL_UPCOMING")
        pendingBookingsUv.pageTabBarItem.title = self.generalFunc.getLanguageLabel(origValue: "UPCOMING", key: "LBL_PENDING")
        
        var uvArr = [UIViewController]()
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
            if(isFirstUpcoming == true){
                uvArr += [myBookingsUv]
                uvArr += [pendingBookingsUv]
                uvArr += [rideHistoryUv]
            }else{
                uvArr += [pendingBookingsUv]
                uvArr += [myBookingsUv]
                uvArr += [rideHistoryUv]
            }
        }else{
            uvArr += [rideHistoryUv]
            uvArr += [myBookingsUv]
        }
        if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() == "YES"){
            let rideHistoryTabUv = RideHistoryTabUV(viewControllers: uvArr, selectedIndex: 0)
            self.pushToNavController(uv: rideHistoryTabUv)
        }else{
            rideHistoryUv.isDirectPush = true
            self.pushToNavController(uv: rideHistoryUv)
        }
        
    }
    
    func openManageVehiclesScreen(){
        let manageVehiclesUV = GeneralFunctions.instantiateViewController(pageName: "ManageVehiclesUV") as! ManageVehiclesUV
        self.pushToNavController(uv: manageVehiclesUV)
    }
    
    @objc func releaseAllTask(isDismiss:Bool = true){
        
        if(updateDriverStatus != nil){
            updateDriverStatus.stopFrequentUpdate()
        }
        
        if(gMapView != nil){
            gMapView!.removeFromSuperview()
            gMapView!.clear()
            gMapView!.delegate = nil
            gMapView = nil
        }
        
        if(self.getLocation != nil){
            self.getLocation!.locationUpdateDelegate = nil
            self.getLocation!.releaseLocationTask()
            self.getLocation = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
        
        if(isDismiss){
            self.dismiss(animated: false, completion: nil)
            self.navigationController?.dismiss(animated: false, completion: nil)
        }
    }
    
    
    func onLocationUpdate(location: CLLocation) {
        
        if(gMapView == nil){
            releaseAllTask()
            return
        }
        
        self.currentLocation = location
        
        let vAvailability = userProfileJson.get("vAvailability")
        
        if(vAvailability == "Available" && isFirstLocationUpdate == true && userProfileJson.get("eEmailVerified").uppercased() == "YES" && userProfileJson.get("ePhoneVerified").uppercased() == "YES" ){
            
            updateStatus(offline: false, isAlertShown: true, true)

        }
        
        let GO_ONLINE = GeneralFunctions.getValue(key: "GO_ONLINE")
        
        if(GO_ONLINE != nil && (GO_ONLINE as! String) == "1"){
            updateStatus(offline: false, isAlertShown: true, true)
            GeneralFunctions.removeValue(key: "GO_ONLINE")
        }
        
        var currentZoomLevel:Float = self.gMapView.camera.zoom
        
        if(currentZoomLevel < Utils.defaultZoomLevel && isFirstLocationUpdate == true){
            currentZoomLevel = Utils.defaultZoomLevel
        }
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude, zoom: currentZoomLevel)
        
        if isHeatMapEnabled == false{
            self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
        }
    
        
        
        if(isFirstLocationUpdate == true && userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            self.jobLocAddLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOAD_ADDRESS")
            
            self.findUserLocAddress()
            
        }
        
        isFirstLocationUpdate = false
        
        updateLocationToPubNub()
        
        if(driverDestinationModeView.isHidden == false){
            self.boundMapForDestinationMode()
        }
    }
    
    @objc func onRefreshCalled(){
        findUserLocAddress()
        getProviderStates()
    }
    
    func findUserLocAddress(){
        if(self.currentLocation == nil){
            return
        }
        
        if(userProfileJson.get("eSelectWorkLocation").uppercased() == "FIXED"){
            onAddressFound(address: userProfileJson.get("vWorkLocation"), location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: userProfileJson.get("vWorkLocationLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: userProfileJson.get("vWorkLocationLongitude"))), isPickUpMode: false, dataResult: "")
        }else{
            getAddressFromLocation = GetAddressFromLocation(uv: self, addressFoundDelegate: self)
            getAddressFromLocation.setLocation(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude)
            getAddressFromLocation.executeProcess(isOpenLoader: false, isAlertShow: false)
        }
    }
    
    func onAddressFound(address: String, location: CLLocation, isPickUpMode: Bool, dataResult: String) {
        if(getAddressFromLocation != nil){
            getAddressFromLocation.addressFoundDelegate = nil
            getAddressFromLocation = nil
        }
        
        self.jobLocAddLbl.text = address
        self.jobLocAddLbl.fitText()
        
        let height = address.height(withConstrainedWidth: Application.screenSize.width - 20, font: self.jobLocAddLbl.font!)
        
        ufxPAGE_HEIGHT = ufxPAGE_HEIGHT  - self.ufxJobLocAreaHeight.constant
        
        self.ufxJobLocAreaHeight.constant = 105 + height - 20
        ufxPAGE_HEIGHT = ufxPAGE_HEIGHT + self.ufxJobLocAreaHeight.constant
        
        ufxCntView.frame.size = CGSize(width: ufxCntView.frame.width, height: ufxPAGE_HEIGHT)
        self.ufxScrollView.contentSize = CGSize(width: self.ufxScrollView.frame.size.width, height: ufxPAGE_HEIGHT)
    }
    
    
    func checkPendingRequests(){
        GeneralFunctions.saveValue(key: Utils.DRIVER_CURRENT_REQ_OPEN_KEY, value: "false" as AnyObject)
        let currentReqArr = userProfileJson.getArrObj("CurrentRequests")
        
        if(currentReqArr.count > 0){
            updateCurrentReqFreqTask = UpdateFreqTask(interval: 5)
            updateCurrentReqFreqTask.currInst = updateCurrentReqFreqTask
            updateCurrentReqFreqTask.setTaskRunListener(onTaskRunCalled: self)
            updateCurrentReqFreqTask.startRepeatingTask()
        }else{
            for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                if(key.hasPrefix(Utils.DRIVER_REQ_CODE_PREFIX_KEY)){
                    let dataValue = Int64(value as! String)
                    let day = 1000 * 60 * 60 * 24 * 1
                    let currentTimeInmill = Utils.currentTimeMillis() - Int64(day)
                    
                    if(currentTimeInmill > dataValue!){
                        GeneralFunctions.removeValue(key: key)
                    }
                }
            }
        }
    }
    
    func deleteTripStatusMessages(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            
            if(key.hasPrefix(Utils.TRIP_STATUS_MSG_PRFIX)){
                
                let dataValue = Int64(value as! String)
                let day = 1000 * 60 * 60 * 24 * 1
                let currentTimeInmill = Utils.currentTimeMillis() - Int64(day)
                
                if(currentTimeInmill > dataValue!){
                    GeneralFunctions.removeValue(key: key)
                }
            }
        }
    }
    
    func onTaskRun(currInst: UpdateFreqTask) {
        if(GeneralFunctions.getValue(key: Utils.DRIVER_CURRENT_REQ_OPEN_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DRIVER_CURRENT_REQ_OPEN_KEY) as! String == "true")){
            return
        }
        
        let currentReqArr = userProfileJson!.getArrObj("CurrentRequests")
        
        if(currentReqTaskPosition < currentReqArr.count){
            
            let msg_str = currentReqArr[currentReqTaskPosition] as! NSDictionary
            
            let message = msg_str.get("tMessage")
            
            FireTripStatusMessges().fireTripMsg(message, true, "Script")
            
            currentReqTaskPosition = currentReqTaskPosition + 1
            
            return
        }else{
            updateCurrentReqFreqTask.stopRepeatingTask()
        }
    }
    
    
    @objc func heatViewTapped(sender:UITapGestureRecognizer){
        
        gMapView.clear()
        
        onlineData.removeAll()
        historyData.removeAll()
        dtaCircleHeatMap.removeAll()
        currentRadius = 0
        
        if(isHeatMapEnabled == false){
            isHeatMapEnabled = true
            gMapView.delegate = self
            heatMapImgView.image = UIImage(named: "ic_heat_map_on")
            
            let camera = GMSCameraPosition.camera(withLatitude: getCenterCoordinate().latitude, longitude: getCenterCoordinate().longitude, zoom: 14)
            
            self.isCameraUpdateIgnore = true
            
            self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
            
            loadHeatMapData()
            
        }else{
            isHeatMapEnabled = false
            gMapView.delegate = nil
            heatMapImgView.image = UIImage(named: "ic_heat_map_off")
            
            if(self.currentLocation != nil){
                let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude, zoom: Utils.defaultZoomLevel)
                
                self.gMapView.animate(with: GMSCameraUpdate.setCamera(camera))
            }else{
                let camera = GMSCameraPosition.camera(withLatitude: getCenterCoordinate().latitude, longitude: getCenterCoordinate().longitude, zoom: Utils.defaultZoomLevel)
                self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
            }
        }
    }
   
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if(self.isCameraUpdateIgnore == true){
            self.isCameraUpdateIgnore = false
            return
        }
        
        if(isHeatMapEnabled){
            loadHeatMapData()
        }
    }
    
    func loadHeatMapData() {
        var radius = getRadius()
        
        if(radius < 0.5){
            radius = 1.0
        }
        
        if(currentRadius == 0.0 || radius > (currentRadius + 0.001)){
            getNearByPassenger(radius: radius, centerLatitude: getCenterCoordinate().latitude, centerLongitude: getCenterCoordinate().longitude)
        }
    }
    
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.gMapView.center
        let centerCoordinate = self.gMapView.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = self.gMapView.convert(CGPoint(self.gMapView.frame.size.width / 2.0, 0), from: gMapView)
        let point = self.gMapView.projection.coordinate(for: topCenterCoor)
        return point
    }
    
    func getRadius() -> CLLocationDistance {
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        
        let radius = (centerLocation.distance(from: topCenterLocation)) / 1000
        
        return round(radius)
    }
    
    func switchValueChanged(_ sender: Any!, andNewValue value: Bool) {
        if (value == true) {
            if(userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                self.statusSwitch.dotColor = UIColor(hex: 0x009900)
            }else{
                statusSwitch.dotColor = UIColor(hex: 0xFFFFFF)
                statusSwitch.color = UIColor(hex: 0x009900)
                statusSwitch.tintColor = UIColor(hex: 0x009900)
            }
        } else {
            if(userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                self.statusSwitch.dotColor = UIColor(hex: 0xFF0000)
            }else{
                statusSwitch.dotColor = UIColor(hex: 0xFFFFFF)
                statusSwitch.color = UIColor(hex: 0xFF0000)
                statusSwitch.tintColor = UIColor(hex: 0xFF0000)
            }
        }
        self.updateOnlineStatus(isAlertShown: true, true)
    }
    
    func stateChanged(onlineOfflineStatusSwitch: UISwitch) {
        
        onlineOfflineStatusSwitch.tintColor = UIColor(hex: 0xFFFFFF)
        onlineOfflineStatusSwitch.onTintColor = UIColor(hex: 0xFFFFFF)
        
        if(onlineOfflineStatusSwitch.isOn){
            onlineOfflineStatusSwitch.thumbTintColor = UIColor(hex: 0xFF0000)
        } else {
            onlineOfflineStatusSwitch.thumbTintColor = UIColor(hex: 0x009900)
        }
        
        updateOnlineStatus(isAlertShown: true)
    }
    
    
    func updateOnlineStatus(isAlertShown: Bool, _ switchValueChanged:Bool = false){
        if(isDriverOnline == false){
            goOnline(isAlertShown: isAlertShown, switchValueChanged)
        }else{
            goOffline(isAlertShown: isAlertShown, switchValueChanged)
        }
    }
    
    func goOnline(isAlertShown: Bool, _ switchValueChanged:Bool = false){
        if(currentLocation != nil){
            let currentLocLatitude:String = self.currentLocation!.coordinate.latitude.description
            let currentLocLongitude:String = self.currentLocation!.coordinate.longitude.description
            
            if(currentLocLatitude != "" && currentLocLatitude != "0.0" && currentLocLongitude != "" && currentLocLongitude != "0.0"){
                updateStatus(offline: false,isAlertShown: isAlertShown, switchValueChanged)
            
            }else{
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
                self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
            }
        }else{
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
            self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
        }
    }
    
    func goOffline(isAlertShown: Bool, _ switchValueChanged:Bool = false){
        if(isDriverOnline == true){
            if(currentLocation == nil){
                currentLocation = CLLocation(latitude: 0.0,longitude: 0.0)
            }
            updateStatus(offline: true, isAlertShown: isAlertShown, switchValueChanged)
            
        }else{
            self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
        }
       
    }
    
    func updateStatus(offline:Bool, isAlertShown:Bool, _ switchValueChanged:Bool = false){
        
        var vAvailability_str:String = ""
        if(offline == false){
            vAvailability_str = "Available"
        }else{
            vAvailability_str = "Not Available"
        }
        
        let currentLocLatitude = self.currentLocation!.coordinate.latitude.description
        let currentLocLongitude = self.currentLocation!.coordinate.longitude.description
        
        var parameters = ["type":"updateDriverStatus", "isUpdateOnlineDate": offline == false ? "true" : "", "iDriverId": GeneralFunctions.getMemberd(),"latitude": currentLocLatitude, "longitude": currentLocLongitude, "Status": vAvailability_str]
        
        if(switchValueChanged == true){
            parameters["isOnlineSwitchPressed"] = offline == false ? "true" : ""
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: isAlertShown)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                

                if (dataDict.get("UberX_message") != ""){
                    self.generalFunc.setAlertMessage(uv: self, title: "", content:self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("UberX_message")) , positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    })
                }
                
                self.DRIVER_DESTINATION_AVAILABLE = dataDict.get("DRIVER_DESTINATION_AVAILABLE").uppercased()
        
                self.checkStatusUpdateRespose(dict: dataDict, offline: offline, isAlertShown: isAlertShown)
                // Driver Destinations Changes
                if(dataDict.get("ENABLE_DRIVER_DESTINATIONS") == "Yes" && self.userProfileJson.get("ONLYDELIVERALL") != "Yes"){
                    
                    self.driverDestinationModeSetup()
                }else{
                    self.driverDestiImgView.isHidden = true
                }// Driver Destinations Changes
                
                
                if(dataDict.get("Enable_Hailtrip") == "Yes" && self.isDriverOnline == true){
                    if(self.userProfileJson.get("ONLYDELIVERALL") != "Yes"){
                        self.hideShowHail(isHide: false)
                    }else{
                        self.hideShowHail(isHide: true)
                    }
                }else{
                    self.hideShowHail(isHide: true)
                }
                
            }else{
                self.setSwitchStatusAvoidUpdate(value: offline, isAnim: false)
                
                if(isAlertShown == true){
                    self.generalFunc.setError(uv: self)
                }
            }
        })
    }
    
    
    func checkStatusUpdateRespose(dict:NSDictionary, offline:Bool, isAlertShown:Bool){
        
        if(dict.get("Action") == "1"){
            
            if(dict.get(Utils.message_str) == "REQUIRED_MINIMUM_BALNCE" && isDriverOnline == false && isAlertShown == true){
                let openMinAmountReqView = OpenMinAmountReqView(uv: self, containerView: self.cntView)
                openMinAmountReqView.setHandler(handler: { (isSkipped, isOpenWallet, view, bgView) in
                    if(isOpenWallet == true){
                        
                        if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() == "CASH" || (self.APPSTORE_MODE_IOS != nil && (self.APPSTORE_MODE_IOS as! String).uppercased() == "REVIEW")){
                            let contactUsUV = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                            self.pushToNavController(uv: contactUsUV)
                        }else{
                            let manageWalletUv = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                            self.pushToNavController(uv: manageWalletUv)
                        }
                    }
                })
                openMinAmountReqView.show(msg: dict.get("Msg"))
                
            }
//            self.HailEnableOnDriverStatus = dict.get("Enable_Hailtrip")
            if(isDriverOnline == false){
                self.setOnlineState(isAlertShown: isAlertShown)
                
                self.setWorkLocationArea(isHide: dict.get("isExistUberXServices").uppercased() == "YES" ? false : true)
                
            }else{
                self.setOfflineState(isAlertShown: isAlertShown)
            }
            
        }else{
            
            if(offline == true){
                self.setSwitchStatusAvoidUpdate(value: true, isAnim: false)
            }else{
                self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
            }
            
            let message = dict.get("message")
            
            let message_str = dict.get("message")
            
            if(isAlertShown == false){
                return
            }
            
            if(dict.get(Utils.message_str) == "SESSION_OUT"){
                
                self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.releaseAllTask(isDismiss: true)
                    GeneralFunctions.logOutUser()
                    GeneralFunctions.restartApp(window: self.window!)
                })
                
                return
            }else if(message_str == "DO_EMAIL_PHONE_VERIFY" || message_str == "DO_PHONE_VERIFY" || message_str == "DO_EMAIL_VERIFY"){
                
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                        accountVerificationUv.isMainPage = true
                        accountVerificationUv.requestType = message_str
                        accountVerificationUv.mainScreenUv = self
                        self.pushToNavController(uv: accountVerificationUv)
                    }
                })
                
                return
            }else if(message_str == "REQUIRED_MINIMUM_BALNCE"){
                let openMinAmountReqView = OpenMinAmountReqView(uv: self, containerView: self.contentView)
                openMinAmountReqView.setHandler(handler: { (isSkipped, isOpenWallet, view, bgView) in
                    if(isOpenWallet == true){
                        if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() == "CASH" || (self.APPSTORE_MODE_IOS != nil && (self.APPSTORE_MODE_IOS as! String).uppercased() == "REVIEW")){
                            let contactUsUV = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                            self.pushToNavController(uv: contactUsUV)
                        }else{
                            let manageWalletUv = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                            self.pushToNavController(uv: manageWalletUv)
                        }
                    }
                })
                openMinAmountReqView.show(msg: dict.get("Msg"))
                
                return
            }else if(message_str == "LBL_INACTIVE_CARS_MESSAGE_TXT"){
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: message_str), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT").uppercased() , nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT").uppercased(), completionHandler: { (btnClickedId) in
                    
                    if(btnClickedId == 1){
                        let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                        self.pushToNavController(uv: contactUsUv)
                    }
                })
                
                return
            }
            
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: message, key: message))
            
        }
    }
    
    func setOnlineState(isAlertShown:Bool){
        
        DispatchQueue.main.async {
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONLINE_HEADER_TXT"), uv: self)
            self.statusLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GO_OFFLINE_TXT").uppercased()
            
            self.setSwitchStatusAvoidUpdate(value: true, isAnim: false)
        }
        
        GeneralFunctions.saveValue(key: "IS_DRIVER_ONLINE", value: "true" as AnyObject)
        isDriverOnline = true
        
        addNotifyOnPassengerRequested()
        
        ConfigPubNub.getInstance().subscribeToCabReqChannel()
        
        if(updateDriverStatus == nil){
            updateDriverStatus = UpdateDriverStatus(uv: self)
        }
        updateDriverStatus.isOnline = true
        updateDriverStatus.scheduleDriverUpdate()
        
        updateLocationToPubNub()
        
        // DRIVER DESTINATION MODE //
        if(userProfileJson.get("ENABLE_DRIVER_DESTINATIONS").uppercased() == "YES"){
            self.openDriverDestinationTrip(isFromRestartApp: true)
        }
        
    }
    
    func setOfflineState(isAlertShown:Bool){
        
        DispatchQueue.main.async {
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFLINE_HEADER_TXT"), uv: self)
            self.statusLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GO_ONLINE_TXT").uppercased()
            
            self.setSwitchStatusAvoidUpdate(value: false, isAnim: false)
        }
        
        GeneralFunctions.saveValue(key: "IS_DRIVER_ONLINE", value: "false" as AnyObject)
        
        isDriverOnline = false
        
        ConfigPubNub.getInstance().unSubscribeToCabReqChannel()
        
        updateDriverStatus.isOnline = false
        updateDriverStatus.stopFrequentUpdate()
        
        self.hideShowHail(isHide: true)
        
        self.setWorkLocationArea(isHide: true)
        
        // DRIVER DESTINATION MODE //
        if(userProfileJson.get("ENABLE_DRIVER_DESTINATIONS").uppercased() == "YES"){
            self.hideDestinationMode()
        }
        
    }
    
    func hideShowHail(isHide:Bool){
       
        var height = 0
        if(isHide == false){
            height = 65
        }
        self.view.layoutIfNeeded()
        hailImgViewHeight.constant = CGFloat(height)

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if(isHide == false){
                self.taxiHailImgView.isHidden = false
            }else{
                self.taxiHailImgView.isHidden = true
            }
        })
    }
    
    func setSwitchStatus(value:Bool, isAnim:Bool){
        DispatchQueue.main.async {
            self.statusSwitch.configSwitchState(value, animated: isAnim)
        }
    }
    
    func setSwitchStatusAvoidUpdate(value:Bool, isAnim:Bool){
        DispatchQueue.main.async {
            self.statusSwitch.configSwitchStateAvoidUpdate(value, animated: isAnim)
            
            if (value == true) {
                if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                    self.statusSwitch.dotColor = UIColor(hex: 0x009900)
                }else{
                    self.statusSwitch.dotColor = UIColor(hex: 0xFFFFFF)
                    self.statusSwitch.color = UIColor(hex: 0x009900)
                    self.statusSwitch.tintColor = UIColor(hex: 0x009900)
                }
            } else {
                if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                    self.statusSwitch.dotColor = UIColor(hex: 0xFF0000)
                }else{
                    self.statusSwitch.dotColor = UIColor(hex: 0xFFFFFF)
                    self.statusSwitch.color = UIColor(hex: 0xFF0000)
                    self.statusSwitch.tintColor = UIColor(hex: 0xFF0000)
                }
            }
        }
    }
    
    func openManageProfile(isOpenEditProfile: Bool){
        let manageProfileUv = GeneralFunctions.instantiateViewController(pageName: "ManageProfileUV") as! ManageProfileUV
        manageProfileUv.isOpenEditProfile = isOpenEditProfile
        self.pushToNavController(uv: manageProfileUv)
    }
    
    func getNearByPassenger(radius:Double, centerLatitude:Double, centerLongitude:Double){
        
        if(task_update_heatMapData != nil){
            task_update_heatMapData!.cancel()
        }
        
        let parameters = ["type":"loadPassengersLocation", "Radius": "\(radius)", "iMemberId": GeneralFunctions.getMemberd(),"Latitude": "\(centerLatitude)", "Longitude": "\(centerLongitude)"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    self.checkNearByPassengerDataResponse(radius: radius, dict: dataDict)
                }else{
                    //                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                //                self.generalFunc.setError(uv: self)
            }
            
        })
        
        self.task_update_heatMapData = exeWebServerUrl
        
    }
    
    func checkNearByPassengerDataResponse(radius:Double,dict:NSDictionary){
        
        if(self.isHeatMapEnabled == false){
            gMapView.clear()
            
            onlineData.removeAll()
            historyData.removeAll()
            dtaCircleHeatMap.removeAll()
            currentRadius = 0
            return
        }
        
        if(dict.get("Action")  == "1"){
            self.currentRadius = radius
            let message = dict.get("message")
            
            var list = [GMUWeightedLatLng]()
            var onlineList = [GMUWeightedLatLng]()
            if(message != ""){
                let message_arr = dict.getArrObj("message")
                
                for i in 0 ..< message_arr.count {
                    let tempItem = message_arr[i] as! NSDictionary
                    
                    let type = tempItem.get("Type")
                    
                    //                    print("Type::\(type)")
                    
                    let latitude = Double(tempItem.get("Latitude"))
                    let longitude = Double(tempItem.get("Longitude"))
                    
                    let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(latitude!, longitude!), intensity: 1.0)
                    
                    if(type == "Online"){
                        
                        onlineList.append(coords)
                    }else{
                        list.append(coords)
                    }
                }
                
                heatmapLayer = GMUHeatmapTileLayer()
                heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                                    startPoints: gradientStartPoints as [NSNumber],
                                                    colorMapSize: 256)
//                heatmapLayer.opacity = 1
//                heatmapLayer.radius = 50
                self.heatmapLayer.weightedData = list
                heatmapLayer.map = gMapView
                onlineHeatmapLayer = GMUHeatmapTileLayer()
                onlineHeatmapLayer.gradient = GMUGradient(colors: onlineGradientColors,
                                                          startPoints: onlineGradientStartPoints as [NSNumber],
                                                          colorMapSize: 256)
//                onlineHeatmapLayer.opacity = 1
//                onlineHeatmapLayer.radius = 50
                self.onlineHeatmapLayer.weightedData = onlineList
                onlineHeatmapLayer.map = gMapView
                self.gMapView.setNeedsDisplay()
            }
        }
    }
    
    func updateLocationToPubNub(){
        if(isDriverOnline == true && currentLocation != nil){
            if(lastPublishedLoc != nil){
                
                if(currentLocation!.distance(from: lastPublishedLoc) < PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT){
                    return
                }else{
                    lastPublishedLoc = currentLocation
                }
                
            }else{
                lastPublishedLoc = currentLocation
            }
            
            ConfigPubNub.getInstance().publishMsg(channelName: GeneralFunctions.getLocationUpdateChannel(), content: GeneralFunctions.buildLocationJson(location: currentLocation!))
        }
    }
    
    
    func goToMyLoc(sender: UITapGestureRecognizer) {
        
        if(currentLocation == nil){
            return
        }
        
        var currentZoomLevel:Float = self.gMapView.camera.zoom
        
        if(currentZoomLevel < Utils.defaultZoomLevel){
            currentZoomLevel = Utils.defaultZoomLevel
        }
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation!.coordinate.latitude,
                                              longitude: currentLocation!.coordinate.longitude, zoom: currentZoomLevel)
        
        self.gMapView.animate(to: camera)
    }
    
    func loadAvailableCar(){
        carListDataArrList.removeAll()
        
        let parameters = ["type":"LoadAvailableCars", "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    self.carListDataArrList.removeAll()
                    
                    for i in 0 ..< dataArr.count{
                        self.carListDataArrList += [dataArr[i] as! NSDictionary]
                    }
                    
                    let totalVehicleCount = self.carListDataArrList.count == 0 ? 1 : self.carListDataArrList.count
                    
                    self.selectCarView = self.generalFunc.loadView(nibName: "SelectCarDesign", uv: self, isWithOutSize: true)
                    
                    let defaultHeight:CGFloat = 220
                    
                    let heightOfRow:CGFloat = 50
//                    if(IS_SHOW_VEHICLE_TYPE.uppercased() == "YES"){
//                        heightOfRow = 60
//                    }
                    
                    self.selectCarView.frame.size = CGSize(width: Application.screenSize.width > 370 ? 360 : (Application.screenSize.width - 50), height: ((CGFloat(totalVehicleCount) * heightOfRow) + defaultHeight) > self.contentView.frame.height ? (self.contentView.frame.height - 100) : ((CGFloat(totalVehicleCount) * heightOfRow) + defaultHeight))
                    
//                    _ = ((self.selectCarView.frame.height / 2) - (self.contentView.frame.height / 2)) >= 0 ? ((self.selectCarView.frame.height / 2) - (self.contentView.frame.height / 2)) : self.contentView.bounds.midY
                    
                    self.selectCarView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY )
                    
                    self.selectCarBGView = UIView()
                    self.selectCarBGView.frame = self.cntView.frame
                    self.cntView.addSubview(self.selectCarBGView)
                    self.cntView.addSubview(self.selectCarView)
                    
                    self.selectCarBGView.alpha = 0
                    self.selectCarView.alpha = 0
    
                    UIView.animate(
                        withDuration: 0.5,
                        delay: 0,
                        options: .curveEaseInOut,
                        animations: {
                            self.selectCarBGView.alpha = 0.4
                            self.selectCarView.alpha = 1
                        }
                    )
                    
                    GeneralFunctions.setImgTintColor(imgView: self.selectCarHImgView, color: UIColor.UCAColor.AppThemeColor)
                    self.selectCarHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CAR_TXT")
                    self.manageVehiclesLbl.text = self.generalFunc.getLanguageLabel(origValue: "Manage Vehicles", key: "LBL_MANAGE_VEHICLES").uppercased()
                    self.manageVehiclesLbl.setClickDelegate(clickDelegate: self)
                    
//                    if (IS_SHOW_VEHICLE_TYPE.uppercased() != "YES"){
                        self.addNewVehicleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_VEHICLES").uppercased()
                        self.addNewVehicleLbl.setClickDelegate(clickDelegate: self)
//                    }else{
//                        self.addNewVehicleLbl.isHidden = true
//                    }
                    
                    self.selectCarBGView.backgroundColor = UIColor.black
                    self.selectCarBGView.alpha = 0.4
                    self.selectCarView.layer.shadowOpacity = 0.5
                    self.selectCarView.layer.shadowOffset = CGSize(width: 0, height: 3)
                    self.selectCarView.layer.shadowColor = UIColor.black.cgColor
                    self.selectCarView.layer.cornerRadius = 10
                    self.selectCarView.layer.masksToBounds = true
                    
                    self.selectCarTableView.dataSource = self
                    self.selectCarTableView.delegate = self
                    self.selectCarTableView.register(CountryListTVCell.self, forCellReuseIdentifier: "SelectCarListTVCell")
                    self.selectCarTableView.register(UINib(nibName: "SelectCarListTVCell", bundle: nil), forCellReuseIdentifier: "SelectCarListTVCell")
                    self.selectCarTableView.tableFooterView = UIView()
                    self.selectCarTableView.bounces = false
                    self.selectCarTableView.reloadData()
                    
                    let selectCarBgTapGue = UITapGestureRecognizer()
                    selectCarBgTapGue.addTarget(self, action: #selector(self.removeSelectCarView))
                    self.selectCarBGView.addGestureRecognizer(selectCarBgTapGue)
                    
                }else{
                    
                    let alertMsgLbl = dataDict.get("message")
                    
                    if(alertMsgLbl == "LBL_INACTIVE_CARS_MESSAGE_TXT"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: alertMsgLbl), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT").uppercased() , nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT").uppercased(), completionHandler: { (btnClickedId) in
                            
                            if(btnClickedId == 1){
                                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                self.pushToNavController(uv: contactUsUv)
                            }
                        })
                        return
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: alertMsgLbl))
                    }
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
        })
    }
    
    @objc func removeSelectCarView(){
        self.selectCarBGView.removeFromSuperview()
        self.selectCarView.removeFromSuperview()
    }
    
    func requestChangeCar(selectedDataDict:NSDictionary){
        
        let parameters = ["type":"SetDriverCarID", "iDriverId": GeneralFunctions.getMemberd(), "iDriverVehicleId": selectedDataDict.get("iDriverVehicleId")]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.carNumLbl.text = selectedDataDict.get("vLicencePlate")
                    self.carNameLBl.text = "\(selectedDataDict.get("vMake")) \(selectedDataDict.get("vTitle"))"
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INFO_UPDATED_TXT"), uv: self)
                    
                    if(selectedDataDict.get("Enable_Hailtrip").uppercased() == "YES" && self.isDriverOnline == true){
                        self.hideShowHail(isHide: false)
                    }else{
                        self.hideShowHail(isHide: true)
                    }
                }else{
                    
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                
                self.generalFunc.setError(uv: self)
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.carListDataArrList[indexPath.item]
        removeSelectCarView()
        
        self.requestChangeCar(selectedDataDict: item)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carListDataArrList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCarListTVCell", for: indexPath) as! SelectCarListTVCell
        
        let item = self.carListDataArrList[indexPath.item]
        
        cell.carNameLbl.text = "\(item.get("vMake")) \(item.get("vTitle"))"
        cell.carPlateNoLbl.text = "(\(item.get("vLicencePlate")))"
        /*if(item.get("IS_SHOW_VEHICLE_TYPE").uppercased() == "YES"){
            if(item.get("eType").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
                cell.carNameLbl.text = "\(cell.carNameLbl.text!)\n(\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE")))"
            }else if(item.get("eType").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || item.get("eType").uppercased() == "DELIVERY"){
                cell.carNameLbl.text = "\(cell.carNameLbl.text!)\n(\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY")))"
            }else{
                cell.carNameLbl.text = "\(cell.carNameLbl.text!)\n(\(item.get("eType")))"
            }
        }*/
        
        if(item.get("DriverSelectedVehicleId") == item.get("iDriverVehicleId")){
            cell.selectionImgView.image = UIImage(named: "ic_select_true")
            GeneralFunctions.setImgTintColor(imgView: cell.selectionImgView, color: UIColor.UCAColor.AppThemeColor)
        }else{
            cell.selectionImgView.image = UIImage(named: "ic_select_false")
            GeneralFunctions.setImgTintColor(imgView: cell.selectionImgView, color: UIColor(hex: 0xd3d3d3))
        }
        
//        GeneralFunctions.setImgTintColor(imgView: cell.selectionImgView, color: UIColor.UCAColor.AppThemeColor)
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let item = self.carListDataArrList[indexPath.item]
//        var heightOfRow:CGFloat = 50
        /*if(item.get("IS_SHOW_VEHICLE_TYPE").uppercased() == "YES"){
            heightOfRow = 60
        }*/
        return 50
    }
    
    // DRIVER DESTINATION MODE //
    func driverDestinationModeSetup(){
       
        if(userProfileJson.get("ENABLE_DRIVER_DESTINATIONS").uppercased() == "YES"){
            
            self.driverDestinationModeView.addSubview(linearBar)
            
            cancelimgView.setOnClickListener { (instance) in
                self.setDestinationModeTo(isStart: false)
            }
            
            startDestModeBtn.backgroundColor = UIColor.UCAColor.AppThemeColor
            startDestModeBtn.clickDelegate = self
            startDestModeBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_START_DEST_MODE_TXT"))
            
            driverDestiImgView.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            driverDestiImgView.setOnClickListener { (instance) in
                
                if(self.DRIVER_DESTINATION_AVAILABLE.uppercased() == "YES"){
                    let launchPlaceFinder = LaunchPlaceFinder(viewControllerUV: self)
                    launchPlaceFinder.currInst = launchPlaceFinder
                    launchPlaceFinder.isForDriverDestinations = true
                    
                    launchPlaceFinder.initializeFinder { (address, latitude, longitude) in
                        
                        self.driverDestinationModeLat = "\(latitude)"
                        self.driverDestinationModeLong = "\(longitude)"
                        self.driverDestinationAddress = address
                        
                        if(self.currentLocation != nil){
                            self.checkRoute()
                        }else{
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
                        }
                        
                    }
                    
                }else{
                    
                    
                    let msg = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DRIVER_DEST_LIMIT_REACHED") + " " + Configurations.convertNumToAppLocal(numStr: String(GeneralFunctions.parseInt(origValue: 0, data: self.userProfileJson.get("MAX_DRIVER_DESTINATIONS")))) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FOR_A_DAY")
                    Utils.showSnakeBar(msg: msg, uv: self)
                }
              
            }
        }
    }
    
    func checkRoute(_ isFromRestart:Bool = false){
    
        var directionURL = ""
        directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(self.currentLocation!.coordinate.latitude),\(self.currentLocation!.coordinate.longitude)&destination=\(self.driverDestinationModeLat),\(self.driverDestinationModeLong)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true"
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: false)
        
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
            
                
                if(dataDict.get("status").uppercased() != "OK" || dataDict.getArrObj("routes").count == 0){
                    
                    if(self.directionFailedDialog != nil){
                        self.directionFailedDialog.disappear()
                        self.directionFailedDialog = nil
                    }
                    
                    self.directionFailedDialog = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ROUTE_NOT_FOUND"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                    })
                    
                    return
                }
                
                let routesArr = dataDict.getArrObj("routes")
                let legs_arr = (routesArr.object(at: 0) as! NSDictionary).getArrObj("legs")
                let steps_arr = (legs_arr.object(at: 0) as! NSDictionary).getArrObj("steps")
               
                var latArray = [String]()
                var longArray = [String]()
                for step in steps_arr{
                    
                    
                    latArray.append((step as! NSDictionary).getObj("end_location").get("lat"))
                    longArray.append((step as! NSDictionary).getObj("end_location").get("lng"))
                }
                
                if(latArray.count == 0 || longArray.count == 0){
                    if(self.directionFailedDialog != nil){
                        self.directionFailedDialog.disappear()
                        self.directionFailedDialog = nil
                    }
                    
                    self.directionFailedDialog = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ROUTE_NOT_FOUND"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                    })
                    
                    return
                }else{
                    
                    self.driverRoutesLat = latArray.joined(separator: ",")
                    self.driverRoutesLong = longArray.joined(separator: ",")
                    
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
                    
                    
                    let destMarker = GMSMarker()
                    destMarker.position = CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.driverDestinationModeLat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.driverDestinationModeLong))
                    destMarker.icon = UIImage.init(named:"ic_pin_dest_selection")
                    destMarker.appearAnimation = GMSMarkerAnimation.pop
                    destMarker.map = self.gMapView
                    
                    let pickupMarker = GMSMarker()
                    pickupMarker.position = CLLocationCoordinate2D(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude)
                    pickupMarker.icon = UIImage.init(named:"ic_pin_source_selection")
                    pickupMarker.appearAnimation = GMSMarkerAnimation.pop
                    pickupMarker.map = self.gMapView
                    
                    self.boundMapForDestinationMode()
                    
                    
                    if(isFromRestart == false){
                        self.setDestinationModeTo(isStart: true)
                    }
                    
                }
               
            }else{
                //                self.generalFunc.setError(uv: self)
            }
        }, url: directionURL)
        
    }
    
    func boundMapForDestinationMode(){
        
        if(self.gMapView != nil){
            var bounds = GMSCoordinateBounds()
            bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude))
            bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.driverDestinationModeLat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.driverDestinationModeLong)))
            let edgeInsets = UIEdgeInsets.init(top: self.navigationController?.navigationBar.height ?? 100, left: 20, bottom: 300, right: 20)
            let update = GMSCameraUpdate.fit(bounds, with: edgeInsets)
            self.gMapView.animate(with: update)
        }
    }
    
    func addPolyLineWithEncodedStringInMap(encodedString: String) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 5
        polyLine.strokeColor = UIColor.black
        polyLine.map = self.gMapView
        
        self.listOfPaths += [polyLine]
    }
    
    func setDestinationModeTo(isStart:Bool){
     
        if(isStart == true){
            
            self.heatMapImgView.isHidden = true
            linearBar.startAnimation()
            hailImgViewHeight.constant = CGFloat(0)
            self.driverDestiImgView.isHidden = true
            self.destAddressLbl.text = self.driverDestinationAddress
            self.destAddressSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DESTINATION") + ": " + Configurations.convertNumToAppLocal(numStr: String(GeneralFunctions.parseInt(origValue: 0, data: self.userProfileJson.get("MAX_DRIVER_DESTINATIONS")) -  GeneralFunctions.parseInt(origValue: 0, data: self.userProfileJson.get("iDestinationCount")))) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMAINIG_TXT").lowercased()
            self.destAddressSHLbl.textColor = UIColor(hex: 0x3252b4)
            self.driverDestinationModeView.isHidden = false
            self.view.layoutIfNeeded()
            self.destModeViewHeight.constant = 280
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                
            })
            
        }else{
            
            self.heatMapImgView.isHidden = false
            linearBar.stopAnimation()
            hailImgViewHeight.constant = CGFloat(65)
            self.driverDestiImgView.isHidden = false
            
            self.gMapView.clear()
            
            self.view.layoutIfNeeded()
            self.destModeViewHeight.constant = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.driverDestinationModeView.isHidden = true
            })
        }
    }
    
    func hideDestinationMode(){
        self.heatMapImgView.isHidden = false
        self.gMapView.clear()
       
        self.driverDestiImgView.isHidden = true
        self.view.layoutIfNeeded()
        self.driverDestTopHeight.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.driverDestTopView.isHidden = true
        })
        
    }
    
    
    func openDriverDestinationTrip(isFromRestartApp:Bool){
        
        if(self.userProfileJson.get("eDestinationMode").uppercased() == "YES"){
            
            self.heatMapImgView.isHidden = true
            linearBar.stopAnimation()
            hailImgViewHeight.constant = CGFloat(0)
            self.driverDestiImgView.isHidden = true
            self.driverDestTopView.isHidden = false
            self.view.layoutIfNeeded()
            self.driverDestTopHeight.constant = 100
            self.destModeViewHeight.constant = 0
            GeneralFunctions.setImgTintColor(imgView: self.driverDestTopCloseView, color: UIColor.darkGray)
            
            if(isFromRestartApp == true){
              
                self.driverDestinationModeLat = self.userProfileJson.getObj("DriverDestinationData").get("tDestinationStartedLatitude")
                self.driverDestinationModeLong = self.userProfileJson.getObj("DriverDestinationData").get("tDestinationStartedLongitude")
                self.driverDestinationAddress = self.userProfileJson.getObj("DriverDestinationData").get("tDestinationStartedAddress")
                
                if(self.currentLocation != nil){
                    self.checkRoute(true)
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
                }
            }
            
            self.destAddressTopLbl.text = self.userProfileJson.getObj("DriverDestinationData").get("tDestinationStartedAddress")
            self.destModeOnTopLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DESTINATION_MODE_ON_TXT")
            self.destModeOnTopLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            self.destModeOnTopLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
    
           
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                
                self.driverDestinationModeView.isHidden = true
                self.driverDestTopCloseView.setOnClickListener { (instance) in
                   
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_DESTINATION_TRIP"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_YES_TXT").uppercased(), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO").uppercased(), completionHandler: { (btnClickedId) in
                 
                        if(btnClickedId == 0){
                            
                            self.endDriverDestination()
                        }
                    })
                 
                }
            })
        }else{
            
            self.heatMapImgView.isHidden = false
            self.driverDestiImgView.isHidden = false
        }
    }
    
    func endDriverDestination(){
        let parameters = ["type":"CancelDriverDestination","iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                   
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    self.DRIVER_DESTINATION_AVAILABLE = self.userProfileJson.get("DRIVER_DESTINATION_AVAILABLE").uppercased()
                    
                    self.hideDestinationMode()
                    
                    // DRIVER DESTINATION MODE //
                    if(self.isDriverOnline == true){
                        self.hailImgViewHeight.constant = CGFloat(65)
                        self.driverDestiImgView.isHidden = false
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func startDriverDestination(){
        
        let parameters = ["type":"startDriverDestination","iDriverId": GeneralFunctions.getMemberd(), "tRootDestLatitudes": self.driverRoutesLat, "tRootDestLongitudes": self.driverRoutesLong, "tAdress": self.driverDestinationAddress, "eStatus": "Active", "tDriverDestLatitude": self.driverDestinationModeLat, "tDriverDestLongitude": self.driverDestinationModeLong]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    self.DRIVER_DESTINATION_AVAILABLE = self.userProfileJson.get("DRIVER_DESTINATION_AVAILABLE").uppercased()


                    self.openDriverDestinationTrip(isFromRestartApp:false)
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: dataDict.get("message"))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func myBtnTapped(sender: MyButton) {
        if(self.editWorkLocBtn != nil && sender == self.editWorkLocBtn){
        }else if(self.startDestModeBtn == sender){
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_START_DESTINATION_TRIP"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_YES_TXT").uppercased(), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO").uppercased(), completionHandler: { (btnClickedId) in
                
                if(btnClickedId == 0){
                    
                    self.startDriverDestination()
                }
            })
          
        }
    }

    
    @IBAction func unwindToMainScreen(_ segue:UIStoryboardSegue) {
        
        if(segue.source.isKind(of: AddDestinationUV.self))
        {
            let addDestinationUv = segue.source as! AddDestinationUV
            self.driverDestinationModeLat = "\(addDestinationUv.selectedLocation.coordinate.latitude)"
            self.driverDestinationModeLong = "\(addDestinationUv.selectedLocation.coordinate.longitude)"
            self.driverDestinationAddress = addDestinationUv.selectedAddress
            
            if(self.currentLocation != nil){
                self.checkRoute()
            }else{
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
            }
            
        }
    }
 
}



open class LinearProgressBar: UIView {
    
    //FOR DATA
    fileprivate var screenSize: CGRect = UIScreen.main.bounds
    fileprivate var isAnimationRunning = false
    
    //FOR DESIGN
    fileprivate var progressBarIndicator: UIView!
    
    //PUBLIC VARS
    open var backgroundProgressBarColor: UIColor = UIColor.clear
    open var progressBarColor: UIColor = UIColor.black//UIColor.UCAColor.AppThemeColor//UIColor(hex: 0x3252b4)
    open var heightForLinearBar: CGFloat = 3
    open var widthForLinearBar: CGFloat = 0
    
    public init () {
        super.init(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: screenSize.width, height: 0)))
        self.progressBarIndicator = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 0, height: heightForLinearBar)))
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.progressBarIndicator = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 0, height: heightForLinearBar)))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LIFE OF VIEW
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.screenSize = UIScreen.main.bounds
        
        if widthForLinearBar == 0 || widthForLinearBar == self.screenSize.height {
            widthForLinearBar = self.screenSize.width
        }
        
        self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x,y :self.frame.origin.y), size: CGSize(width: widthForLinearBar, height: self.frame.height))
    }
    
    //MARK: PUBLIC FUNCTIONS    ------------------------------------------------------------------------------------------
    
    //Start the animation
    open func startAnimation(){
        
        self.configureColors()
        
        self.show()
        
        if !isAnimationRunning {
            self.isAnimationRunning = true
            
            UIView.animate(withDuration: 0.5, delay:0, options: [], animations: {
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: self.heightForLinearBar)
            }, completion: { animationFinished in
                self.addSubview(self.progressBarIndicator)
                self.configureAnimation()
            })
        }
    }
    
    //Start the animation
    open func stopAnimation() {
        
        self.isAnimationRunning = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar, height: 0)
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: 0)
        })
    }
    
    //MARK: PRIVATE FUNCTIONS    ------------------------------------------------------------------------------------------
    
    fileprivate func show() {
        
        // Only show once
        if self.superview != nil {
            return
        }
        
        // Find current top viewcontroller
        if let topController = getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(self)
        }
    }
    
    fileprivate func configureColors(){
        
        self.backgroundColor = self.backgroundProgressBarColor
        self.progressBarIndicator.backgroundColor = self.progressBarColor
        self.layoutIfNeeded()
    }
    
    fileprivate func configureAnimation() {
        
        guard let superview = self.superview else {
            stopAnimation()
            return
        }
        
        self.progressBarIndicator.frame = CGRect(origin: CGPoint(x: 0, y :0), size: CGSize(width: 0, height: heightForLinearBar))
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar*0.7, height: self.heightForLinearBar)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: superview.frame.width, y: 0, width: 0, height: self.heightForLinearBar)
                
            })
            
        }) { (completed) in
            if (self.isAnimationRunning){
                self.configureAnimation()
            }
        }
    }
    
    // -----------------------------------------------------
    //MARK: UTILS    ---------------------------------------
    // -----------------------------------------------------
    
    fileprivate func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}
