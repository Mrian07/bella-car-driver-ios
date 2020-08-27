//
//  AddVehiclesUV.swift
//  DriverApp
//
//  Created by ADMIN on 02/06/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class AddVehiclesUV: UIViewController, MyBtnClickDelegate, BEMCheckBoxDelegate, MyTxtFieldClickDelegate , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var vehicleTypeTxtField: MyTextField!
    @IBOutlet weak var vehicleTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var makeTxtField: MyTextField!
    @IBOutlet weak var modelTxtField: MyTextField!
    @IBOutlet weak var yearTxtField: MyTextField!
    @IBOutlet weak var colorTxtField: MyTextField!
    @IBOutlet weak var licPlatTxtField: MyTextField!
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var handiCapView: UIView!
    @IBOutlet weak var handiCapLbl: MyLabel!
    @IBOutlet weak var handiCapChkBox: BEMCheckBox!
    @IBOutlet weak var handiCapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var childAccessView: UIView!
    @IBOutlet weak var childAccessLbl: MyLabel!
    @IBOutlet weak var childAccessChkBox: BEMCheckBox!
    @IBOutlet weak var childAccessViewHeight: NSLayoutConstraint!
    @IBOutlet weak var wheelChairView: UIView!
    @IBOutlet weak var wheelChairLbl: MyLabel!
    @IBOutlet weak var wheelChairChkBox: BEMCheckBox!
    @IBOutlet weak var wheelChairViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vehicleInfoAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var vehicleInfoAreaView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableview: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    
    var userProfileJson:NSDictionary!
    
    let generalFunc = GeneralFunctions()
    
    var iDriverVehicleId = ""
    var currentVehicleData:NSDictionary!
    
    var isFromMainPage = false
    var mainScreenUv:MainScreenUV!
    
    var isPageLoaded = false
    
    var cntView:UIView!
    
    var loaderView:UIView!
    
    var window:UIWindow!
    
    var carlistArr = [NSDictionary]()
    var yearListArr = [String]()
    var carTypeArr = [NSDictionary]()
    var carTypeArrOfDelAll = [NSDictionary]()

    var makeListArr = [String]()
    var modelListArr = [String]()
    var modelsArr = [NSDictionary]()
    
    var selectedMakeId = -1
    var selectedModelId = -1
    var selectedYearId = -1
    
    var carTypesStatusArr = [Bool]()
    var carTypesStatusArrForDelAll = [Bool]()
    var carTypesRentalStatusArr = [Bool]()
    
    var PAGE_HEIGHT:CGFloat = 720
    
    var isSafeAreaSet = false
    
    var eType = Utils.cabGeneralType_Ride
    
    var manageVehiUV:ManageVehiclesUV!
    
    var isFromDriverStatesUV = false
    var APP_TYPE = ""
    
    
    var reqVehicleSection = 1
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        window = Application.window!
        
        
        cntView = self.generalFunc.loadView(nibName: "AddVehiclesScreenDesign", uv: self, contentView: scrollView)
        
        scrollView.addSubview(cntView)
        
        scrollView.isHidden = true
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clear
        
        if(Configurations.isIponeXDevice()){
            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 20
        }
        //        self.contentView.addSubview(self.generalFunc.loadView(nibName: "AddVehiclesScreenDesign", uv: self, contentView: contentView))
        
        
        self.addBackBarBtn()
        
        //        setData()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        var HANDICAP_ACCESSIBILITY_OPTION = userProfileJson.get("HANDICAP_ACCESSIBILITY_OPTION")
        var CHILD_ACCESSIBILITY_OPTION = userProfileJson.get("CHILD_SEAT_ACCESSIBILITY_OPTION")
        var WHEEL_CHAIR_ACCESSIBILITY_OPTION = userProfileJson.get("WHEEL_CHAIR_ACCESSIBILITY_OPTION")
        //        HANDICAP_ACCESSIBILITY_OPTION = "Yes"
        
        APP_TYPE = userProfileJson.get("APP_TYPE")
        
        if(APP_TYPE.uppercased() == Utils.cabGeneralType_Deliver.uppercased() || APP_TYPE.uppercased() == "DELIVERY"){
            HANDICAP_ACCESSIBILITY_OPTION = "No"
            CHILD_ACCESSIBILITY_OPTION = "No"
            WHEEL_CHAIR_ACCESSIBILITY_OPTION = "No"
            
        }
        
        if(HANDICAP_ACCESSIBILITY_OPTION.uppercased() != "YES"){
            hideHandiCappedView(isHide: true)
        }else{
            handiCapView.isHidden = false
            self.handiCapChkBox.boxType = .square
            self.handiCapChkBox.offAnimationType = .bounce
            self.handiCapChkBox.onAnimationType = .bounce
            self.handiCapChkBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
            self.handiCapChkBox.onFillColor = UIColor.UCAColor.AppThemeColor
            self.handiCapChkBox.onTintColor = UIColor.UCAColor.AppThemeColor
            self.handiCapChkBox.tintColor = UIColor.UCAColor.AppThemeColor_1
            self.handiCapLbl.text = self.generalFunc.getLanguageLabel(origValue: "Handicap accessibility available?", key: "LBL_HANDICAP_QUESTION")
        }
        
        if(CHILD_ACCESSIBILITY_OPTION.uppercased() != "YES"){
            childAccessView(isHide: true)
        }else{
            childAccessView.isHidden = false
            self.childAccessChkBox.boxType = .square
            self.childAccessChkBox.offAnimationType = .bounce
            self.childAccessChkBox.onAnimationType = .bounce
            self.childAccessChkBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
            self.childAccessChkBox.onFillColor = UIColor.UCAColor.AppThemeColor
            self.childAccessChkBox.onTintColor = UIColor.UCAColor.AppThemeColor
            self.childAccessChkBox.tintColor = UIColor.UCAColor.AppThemeColor_1
            self.childAccessLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHILD_SEAT_QUESTION")
        }
        
        if(WHEEL_CHAIR_ACCESSIBILITY_OPTION.uppercased() != "YES"){
            wheelChairView(isHide: true)
        }else{
            wheelChairView.isHidden = false
            self.wheelChairChkBox.boxType = .square
            self.wheelChairChkBox.offAnimationType = .bounce
            self.wheelChairChkBox.onAnimationType = .bounce
            self.wheelChairChkBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
            self.wheelChairChkBox.onFillColor = UIColor.UCAColor.AppThemeColor
            self.wheelChairChkBox.onTintColor = UIColor.UCAColor.AppThemeColor
            self.wheelChairChkBox.tintColor = UIColor.UCAColor.AppThemeColor_1
            self.wheelChairLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WHEEL_CHAIR_ADD_VEHICLES")
        }
        
        if(userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            self.vehicleInfoAreaHeight.constant = 0
            self.vehicleInfoAreaView.isHidden = true
        }
        
        self.vehicleTypeHeight.constant = 0
        self.vehicleTypeTxtField.isHidden = true
        self.vehicleInfoAreaHeight.constant = 450 + handiCapViewHeight.constant + wheelChairViewHeight.constant + childAccessViewHeight.constant - 60
        
        self.PAGE_HEIGHT = self.PAGE_HEIGHT - 75
        
        vehicleTypeTxtField.disableMenu()
        makeTxtField.disableMenu()
        yearTxtField.disableMenu()
        modelTxtField.disableMenu()
        
        setData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.bounces = false
        self.tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "CabTypeItemTVCell", bundle: nil), forCellReuseIdentifier: "CabTypeItemTVCell")
    }
    
    func hideHandiCappedView(isHide:Bool){
        if(isHide == true || userProfileJson.get("HANDICAP_ACCESSIBILITY_OPTION").uppercased() != "YES"){
            if(handiCapView.isHidden == false){
                handiCapViewHeight.constant = 0
                handiCapView.isHidden = true
                self.handiCapChkBox.on = false
                PAGE_HEIGHT = PAGE_HEIGHT - 45
                self.vehicleInfoAreaHeight.constant = self.vehicleInfoAreaHeight.constant - 45
            }
        }else{
            if(handiCapView.isHidden == true){
                handiCapViewHeight.constant = 45
                handiCapView.isHidden = false
                self.handiCapChkBox.on = false
                PAGE_HEIGHT = PAGE_HEIGHT + 45
                self.vehicleInfoAreaHeight.constant = self.vehicleInfoAreaHeight.constant + 45
            }
        }
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT + GeneralFunctions.getSafeAreaInsets().bottom)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT + GeneralFunctions.getSafeAreaInsets().bottom)
    }
    
    func childAccessView(isHide:Bool){
        if(isHide == true || userProfileJson.get("CHILD_SEAT_ACCESSIBILITY_OPTION").uppercased() != "YES"){
            if(childAccessView.isHidden == false){
                childAccessViewHeight.constant = 0
                childAccessView.isHidden = true
                self.childAccessChkBox.on = false
                PAGE_HEIGHT = PAGE_HEIGHT - 45
                self.vehicleInfoAreaHeight.constant = self.vehicleInfoAreaHeight.constant - 45
            }
        }else{
            if(childAccessView.isHidden == true){
                childAccessViewHeight.constant = 45
                childAccessView.isHidden = false
                self.childAccessChkBox.on = false
                PAGE_HEIGHT = PAGE_HEIGHT + 45
                self.vehicleInfoAreaHeight.constant = self.vehicleInfoAreaHeight.constant + 45
            }
        }
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT + GeneralFunctions.getSafeAreaInsets().bottom)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT + GeneralFunctions.getSafeAreaInsets().bottom)
    }
    
    func wheelChairView(isHide:Bool){
        if(isHide == true || userProfileJson.get("WHEEL_CHAIR_ACCESSIBILITY_OPTION").uppercased() != "YES"){
            if(wheelChairView.isHidden == false){
                wheelChairViewHeight.constant = 0
                wheelChairView.isHidden = true
                self.wheelChairChkBox.on = false
                PAGE_HEIGHT = PAGE_HEIGHT - 45
                self.vehicleInfoAreaHeight.constant = self.vehicleInfoAreaHeight.constant - 45
            }
        }else{
            if(wheelChairView.isHidden == true){
                wheelChairViewHeight.constant = 45
                wheelChairView.isHidden = false
                self.wheelChairChkBox.on = false
                PAGE_HEIGHT = PAGE_HEIGHT + 45
                self.vehicleInfoAreaHeight.constant = self.vehicleInfoAreaHeight.constant + 45
            }
        }
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT + GeneralFunctions.getSafeAreaInsets().bottom)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT + GeneralFunctions.getSafeAreaInsets().bottom)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoaded == false){
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT + GeneralFunctions.getSafeAreaInsets().bottom)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT + GeneralFunctions.getSafeAreaInsets().bottom)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.makeTxtField.addArrowView(color: UIColor(hex: 0xbcbcbc), transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)))
                self.modelTxtField.addArrowView(color: UIColor(hex: 0xbcbcbc), transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)))
                self.yearTxtField.addArrowView(color: UIColor(hex: 0xbcbcbc), transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)))
                self.vehicleTypeTxtField.addArrowView(color: UIColor(hex: 0xbcbcbc), transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)))
            })
            
            getData(isCarTypeOnly: false)
            
            isPageLoaded = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            
            if(cntView != nil){
                cntView.frame.size.height = scrollView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
            }
            
            isSafeAreaSet = true
        }
    }
    
    func setData(){
        if(userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MANAGE_VEHICLES")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MANAGE_VEHICLES")
        }else{
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_VEHICLE")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_VEHICLE")
        }
        
        self.vehicleTypeTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Vehicle Type", key: "LBL_VEHICLE_TYPE_SMALL_TXT"))
        self.makeTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MAKE"))
        self.modelTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MODEL"))
        self.yearTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YEAR"))
        self.colorTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COLOR_TXT"))
        self.licPlatTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LICENCE_PLATE_TXT"))
        
        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT"))
        
        self.vehicleTypeTxtField.setEnable(isEnabled: false)
        self.vehicleTypeTxtField.myTxtFieldDelegate = self
        
        self.makeTxtField.setEnable(isEnabled: false)
        self.makeTxtField.myTxtFieldDelegate = self
        
        self.modelTxtField.setEnable(isEnabled: false)
        self.modelTxtField.myTxtFieldDelegate = self
        
        self.yearTxtField.setEnable(isEnabled: false)
        self.yearTxtField.myTxtFieldDelegate = self
        
        self.vehicleTypeTxtField.getTextField()!.clearButtonMode = .never
        self.makeTxtField.getTextField()!.clearButtonMode = .never
        self.modelTxtField.getTextField()!.clearButtonMode = .never
        self.yearTxtField.getTextField()!.clearButtonMode = .never
        
        self.submitBtn.clickDelegate = self
        
        if(APP_TYPE.uppercased() != Utils.cabGeneralType_Ride.uppercased()){
            self.lineView.isHidden = true
        }
        
        if(self.currentVehicleData != nil){
            self.licPlatTxtField.setText(text: self.currentVehicleData!.get("vLicencePlate"))
            self.colorTxtField.setText(text: self.currentVehicleData!.get("vColour"))
            
            if(self.currentVehicleData!.get("eHandiCapAccessibility") == "Yes"){
                self.handiCapChkBox.on = true
            }
            
            if(self.currentVehicleData!.get("eChildAccessibility") == "Yes"){
                self.childAccessChkBox.on = true
            }
            
            if(self.currentVehicleData!.get("eWheelChairAccessibility") == "Yes"){
                self.wheelChairChkBox.on = true
            }
            
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Edit Vehicle", key: "LBL_EDIT_VEHICLE")
            self.title = self.generalFunc.getLanguageLabel(origValue: "Edit Vehicle", key: "LBL_EDIT_VEHICLE")
        }
        
        
//        self.licPlatTxtField.regexToMatch = "^[a-zA-Z0-9 ]+$"
    }
    
    func myTxtFieldTapped(sender: MyTextField){
      
        if(self.makeTxtField != nil && sender == self.makeTxtField){
            
            let openListView = OpenListView(uv: self, containerView: self.view)
            openListView.show(listObjects: self.makeListArr, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_MAKE"), currentInst: openListView, handler: { (selectedItemId) in
                self.makeChanged(selectedIndex: selectedItemId)
            })
            
        }else if(modelTxtField != nil && sender == modelTxtField){
           
            if(self.selectedMakeId != -1){
                let openListView = OpenListView(uv: self, containerView: self.view)
                openListView.show(listObjects: self.modelListArr, title: self.generalFunc.getLanguageLabel(origValue: "Select model", key: "LBL_SELECT_MODEL"), currentInst: openListView, handler: { (selectedItemId) in
                    self.modelChanged(selectedIndex: selectedItemId)
                })
            }else{
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "Please select make", key: "LBL_SELECT_MAKE_HINT"), uv: self)
            }
        }else if(yearTxtField != nil && sender == yearTxtField){
            
            let openListView = OpenListView(uv: self, containerView: self.view)
            openListView.show(listObjects: self.yearListArr, title: self.generalFunc.getLanguageLabel(origValue: "Select Year", key: "LBL_SELECT_YEAR"), currentInst: openListView, handler: { (selectedItemId) in
                self.yearChanged(selectedIndex: selectedItemId)
            })
        }/*else if(vehicleTypeTxtField != nil && sender == vehicleTypeTxtField){
           
            let dataArr = ["\(self.generalFunc.getLanguageLabel(origValue: "Ride", key: "LBL_RIDE"))","\(self.generalFunc.getLanguageLabel(origValue: "Delivery", key: "LBL_DELIVERY"))","\(self.generalFunc.getLanguageLabel(origValue: "Ride", key: "LBL_RIDE"))-\(self.generalFunc.getLanguageLabel(origValue: "Delivery", key: "LBL_DELIVERY"))"]
            let openListView = OpenListView(uv: self, containerView: self.view)
            openListView.show(listObjects: dataArr, title: self.generalFunc.getLanguageLabel(origValue: "Select Vehicle Type", key: "LBL_SELECT_VEHICLE_TYPE"), currentInst: openListView, handler: { (selectedItemId) in
                if(selectedItemId == 0){
                    self.eType = Utils.cabGeneralType_Ride
                    self.vehicleTypeTxtField.setText(text:"\(self.generalFunc.getLanguageLabel(origValue: "Ride", key: "LBL_RIDE"))")
                    self.hideHandiCappedView(isHide: false)
                }else if(selectedItemId == 1){
                    self.eType = Utils.cabGeneralType_Deliver
                    self.vehicleTypeTxtField.setText(text:"\(self.generalFunc.getLanguageLabel(origValue: "Delivery", key: "LBL_DELIVERY"))")
                    self.hideHandiCappedView(isHide: true)
                }else{
                    self.hideHandiCappedView(isHide: false)
                    self.eType = Utils.cabGeneralType_Ride_Deliver
                    self.vehicleTypeTxtField.setText(text:"\(self.generalFunc.getLanguageLabel(origValue: "Ride", key: "LBL_RIDE"))-\(self.generalFunc.getLanguageLabel(origValue: "Delivery", key: "LBL_DELIVERY"))")
                }
                
                self.getData(isCarTypeOnly: true)
            })
        }*/
    }
    
    func getData(isCarTypeOnly:Bool){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.isHidden = false
        }else{
            loaderView.isHidden = false
        }
        loaderView.backgroundColor = UIColor.clear
        
        scrollView.isHidden = true
        
        let parameters = ["type":"getUserVehicleDetails","iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                if(dataDict.get("Action") == "1"){
                    
                    self.loaderView.isHidden = true
                    self.scrollView.isHidden = false
                    
                    let yearArr = dataDict.getObj(Utils.message_str).getArrObj("year")
                    
                    let carlist = dataDict.getObj(Utils.message_str).getArrObj("carlist")
                    let vehicletypelist = dataDict.getObj(Utils.message_str).getArrObj("vehicletypelist")
                    
                    self.yearListArr.removeAll()
                    self.carTypeArr.removeAll()
                    self.carTypeArrOfDelAll.removeAll()
                    self.carTypesStatusArr.removeAll()
                    self.carTypesStatusArrForDelAll.removeAll()
                    self.carlistArr.removeAll()
                    self.makeListArr.removeAll()
                    self.carTypesRentalStatusArr.removeAll()
                    
                    for i in 0..<yearArr.count{
                        self.yearListArr += [Configurations.convertNumToAppLocal(numStr: yearArr[i] as! String)]
                        
                        if(self.currentVehicleData != nil && (yearArr[i] as! String) == self.currentVehicleData.get("iYear") && isCarTypeOnly == false){
                            self.selectedYearId = i
                        }
                    }
                    
                    var vCarType = [String]()
                    
                    if(self.currentVehicleData != nil && self.currentVehicleData!.get("vCarType") != ""){
                        vCarType = self.currentVehicleData!.get("vCarType").components(separatedBy: ",")
                    }
                    
                    var vRentalCarType = [String]()
                    
                    if(self.currentVehicleData != nil && self.currentVehicleData!.get("vRentalCarType") != ""){
                        vRentalCarType = self.currentVehicleData!.get("vRentalCarType").components(separatedBy: ",")
                    }
                    
                    if(vehicletypelist.count == 0){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT").uppercased(), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT").uppercased(), completionHandler: { (btnClickedId) in
                            
                            if(btnClickedId == 1){
                                if(self.isFromMainPage == true && self.mainScreenUv != nil){
                                    self.closeCurrentScreen()
                                    if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                                        self.mainScreenUv.openManageVehiclesScreen()
                                    }
                                    return
                                }
                                
                                if self.isFromDriverStatesUV{
                                    self.closeCurrentScreen()
                                    return
                                }
                                
                                if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                                    self.performSegue(withIdentifier: "unwindToManageVehicles", sender: self)
                                }
                            }else{
                                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                contactUsUv.manageVehiUV = self.manageVehiUV
                                (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(contactUsUv, animated: true)
                            }
                        })
                        return
                    }
                    
                    var heightForTableView : CGFloat = 0
                    for i in 0..<vehicletypelist.count{
                        let item = vehicletypelist[i] as! NSMutableDictionary
                        item["IS_SHOW_VEHICLE_TYPE"] = dataDict.getObj(Utils.message_str).get("IS_SHOW_VEHICLE_TYPE")
                        var cellHeight : CGFloat = 75
                        
                        if item.get("eType") == "DeliverAll"
                        {
                            self.carTypeArrOfDelAll.append(item)
                            
                            if((self.currentVehicleData != nil && vCarType.contains(item.get("iVehicleTypeId"))) || (item.get("VehicleServiceStatus") != "" && item.get("VehicleServiceStatus") == "true")){
                                self.carTypesStatusArrForDelAll.append(true)
                                
                            }else{
                                self.carTypesStatusArrForDelAll.append(false)
                                
                            }
                            
                        }else
                        {
                            self.carTypeArr.append(item)
                            
                            if((self.currentVehicleData != nil && vCarType.contains(item.get("iVehicleTypeId"))) || (item.get("VehicleServiceStatus") != "" && item.get("VehicleServiceStatus") == "true")){
                                self.carTypesStatusArr.append(true)
                                
                                if item.get("eRental").uppercased() == "YES"{
                                    cellHeight += 25
                                }
                            }else{
                                self.carTypesStatusArr.append(false)
                            }
                            
                            if((self.currentVehicleData != nil && vRentalCarType.contains(item.get("iVehicleTypeId"))) || (item.get("VehicleServiceStatus") != "" && item.get("VehicleServiceStatus") == "true")){
                                self.carTypesRentalStatusArr.append(true)
                            }else{
                                self.carTypesRentalStatusArr.append(false)
                            }
                        }
                        
                        self.PAGE_HEIGHT = self.PAGE_HEIGHT + cellHeight
                        heightForTableView += cellHeight
                        
                    }
                    
                    // var heightForTableView : CGFloat = 0
                    
                    //                    for i in 0..<vehicletypelist.count{
                    //                        let item = vehicletypelist[i] as! NSDictionary
                    //                        var cellHeight : CGFloat = 75
                    //
                    //                        if item.get("eType") != "DeliverAll"
                    //                        {
                    //                            if self.carTypesStatusArr[i] == true {
                    //                                if item.get("eRental").uppercased() == "YES"{
                    //                                    cellHeight += 25
                    //                                }
                    //                            }
                    //                        }
                    //
                    //                        self.PAGE_HEIGHT = self.PAGE_HEIGHT + cellHeight
                    //                        heightForTableView += cellHeight
                    //                    }
                    
                    var extraHeightForNewSection:CGFloat = 0
                    if self.carTypeArrOfDelAll.count > 0
                    {
                        extraHeightForNewSection = 25
                        self.reqVehicleSection = 2
                    }
                    self.PAGE_HEIGHT = self.PAGE_HEIGHT + extraHeightForNewSection
                    heightForTableView = heightForTableView + extraHeightForNewSection
                    self.heightTableview.constant = heightForTableView
                    
                    _ = self.contentView.frame.height + self.heightTableview.constant + 40
                    
                    self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: self.PAGE_HEIGHT)
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
                    
                    for i in 0..<carlist.count{
                        let item = carlist[i] as! NSDictionary
                        self.makeListArr += [item.get("vMake")]
                        
                        if(self.currentVehicleData != nil && item.get("iMakeId") == self.currentVehicleData.get("iMakeId") && isCarTypeOnly == false){
                            self.selectedMakeId = i
                        }
                        
                        self.carlistArr += [item]
                    }
                    
//                    self.generateCarTypes(isCarTypeOnly: isCarTypeOnly)
                    
                    
                     self.tableView.reloadData()
                    
                    
                    if(self.selectedMakeId != -1 && isCarTypeOnly == false){
                        self.makeChanged(selectedIndex: self.selectedMakeId)
                    }
                    
                    if(self.selectedYearId != -1 && isCarTypeOnly == false){
                        self.yearChanged(selectedIndex: self.selectedYearId)
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func makeChanged(selectedIndex:Int){
        
        self.selectedMakeId = selectedIndex
        
        //        if(selectedIndex != -1){
        let item = self.carlistArr[selectedIndex]
        let vModellist = item.getArrObj("vModellist")
        
        self.makeTxtField.setText(text: self.makeListArr[selectedIndex])
        self.modelListArr.removeAll()
        self.modelsArr.removeAll()
        
        var selectedModelPosition = -1
        for i in 0..<vModellist.count{
            let item = vModellist[i] as! NSDictionary
            self.modelListArr += [item.get("vTitle")]
            
            self.modelsArr += [item]
            
            if(self.currentVehicleData != nil && item.get("iModelId") == self.currentVehicleData.get("iModelId")){
                selectedModelPosition = i
            }
        }
        
        self.selectedModelId = selectedModelPosition
        
        if(self.selectedModelId != -1){
            self.modelTxtField.setText(text: "\(self.modelListArr[self.selectedModelId])")
        }else{
            self.modelTxtField.setText(text: "")
        }
        
    }
    
    func yearChanged(selectedIndex:Int){
        self.selectedYearId = selectedIndex
        self.yearTxtField.setText(text: self.yearListArr[selectedIndex])
    }
    
    func modelChanged(selectedIndex:Int){
        self.selectedModelId = selectedIndex
        self.modelTxtField.setText(text: self.modelListArr[selectedIndex])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            if(self.eType.uppercased() == Utils.cabGeneralType_Ride_Deliver.uppercased()){
                return 75
            }else{
                let item = carTypeArr[indexPath.row]
                if item.get("eRental").uppercased() == "YES"{
                    if(self.carTypesStatusArr[indexPath.row] == true){
                        return 100
                    }else{
                        return 75
                    }
                }else{
                    return 75
                }
            }
        }else{
             return 75
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.reqVehicleSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0
        {
            return self.carTypeArr.count
            
        }else
        {
            return self.carTypeArrOfDelAll.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return ""
        }else
        {
            return self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERALL")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CabTypeItemTVCell", for: indexPath) as! CabTypeItemTVCell
     
        cell.selectionStyle = .none
        if indexPath.section == 0
        {
            let item = carTypeArr[indexPath.row]
            cell.carTypeNameLbl.text = item.get("vVehicleType")
            cell.subTitleLbl.text = item.get("SubTitle")
            cell.vtypeLbl.isHidden = true
            
            cell.allowRentalLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AVAILABLE_FOR_RENTAL")
            
            cell.containerView.layer.shadowOpacity = 0.5
            cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
            cell.containerView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
            
            cell.checkRadioImgView.isHidden = true
            cell.rentalChkBox.tag = indexPath.row
            cell.rentalChkBox.boxType = .square
            cell.rentalChkBox.offAnimationType = .bounce
            cell.rentalChkBox.onAnimationType = .bounce
            cell.rentalChkBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
            cell.rentalChkBox.onFillColor = UIColor.UCAColor.AppThemeColor
            cell.rentalChkBox.onTintColor = UIColor.UCAColor.AppThemeColor
            cell.rentalChkBox.tintColor = UIColor.UCAColor.AppThemeColor_1
            cell.rentalChkBox.delegate = self
            
            cell.carTypeChkBox.tag = indexPath.row
            cell.carTypeChkBox.boxType = .square
            cell.carTypeChkBox.offAnimationType = .bounce
            cell.carTypeChkBox.onAnimationType = .bounce
            cell.carTypeChkBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
            cell.carTypeChkBox.onFillColor = UIColor.UCAColor.AppThemeColor
            cell.carTypeChkBox.onTintColor = UIColor.UCAColor.AppThemeColor
            cell.carTypeChkBox.tintColor = UIColor.UCAColor.AppThemeColor_1
            //            carTypeSwitch.addTarget(self, action: #selector(self.carTypeStatusChanged), for: .valueChanged)
            
            cell.allowRentalView.isHidden = false
            cell.heightContainerView.constant = 60
            
            if(self.carTypesStatusArr[indexPath.row] == true){
                cell.carTypeChkBox.setOn(true, animated: true)
                if item.get("eRental").uppercased() == "YES"{
                    cell.allowRentalView.isHidden = false
                    cell.heightContainerView.constant = 85
                    if(self.carTypesRentalStatusArr[indexPath.row] == true){
                        cell.rentalChkBox.setOn(true, animated: true)
                    }else{
                        cell.rentalChkBox.setOn(false, animated: true)
                    }
                }else{
                    cell.allowRentalView.isHidden = true
                    cell.heightContainerView.constant = 60
                }
            }else{
                cell.carTypeChkBox.setOn(false, animated: true)
                cell.allowRentalView.isHidden = true
                cell.heightContainerView.constant = 60
            }
            cell.carTypeChkBox.delegate = self
            
            let serviceSelectTapGue = UITapGestureRecognizer()
            serviceSelectTapGue.addTarget(self, action: #selector(self.selectServiceViewTapped(sender:)))
            
            cell.rentalChkBoxContainerView.isUserInteractionEnabled = true
            cell.rentalChkBoxContainerView.tag = indexPath.item
            cell.rentalChkBoxContainerView.addGestureRecognizer(serviceSelectTapGue)
            
            //        if(self.eType.uppercased() == Utils.cabGeneralType_Ride_Deliver.uppercased()){
            //            cell.vtypeLbl.isHidden = false
            //            cell.vtypeLbl.text = String(format:"(%@)",item.get("eType"))
            //            cell.allowRentalView.isHidden = true
            //            cell.heightContainerView.constant = 60
            //        }
            
            if(item.get("IS_SHOW_VEHICLE_TYPE").uppercased() == "YES"){
                cell.vtypeLbl.isHidden = false
                var eTypeValue = ""
                if item.get("eType") == Utils.cabGeneralType_Deliver
                {
                    eTypeValue = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY")
                }else if item.get("eType") == Utils.cabGeneralType_Ride
                {
                    eTypeValue = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE")
                }else
                {
                    eTypeValue = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERALL")
                }
                
                cell.vtypeLbl.text = String(format:"(%@)",eTypeValue)
            }
            
            return cell
            
        }else{
            
            let item = self.carTypeArrOfDelAll[indexPath.row]
            cell.carTypeNameLbl.text = item.get("vVehicleType")
            cell.subTitleLbl.text = item.get("SubTitle")
            cell.vtypeLbl.isHidden = true
            
            cell.allowRentalLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AVAILABLE_FOR_RENTAL")
            
            cell.containerView.layer.shadowOpacity = 0.5
            cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
            cell.containerView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
            
            cell.carTypeChkBox.isHidden = true
            cell.checkRadioImgView.isHidden = false
            
            let carTypeChkBoxTapGue = UITapGestureRecognizer()
            carTypeChkBoxTapGue.addTarget(self, action: #selector(self.carTypeChkBoxTapped(sender:)))
            
            cell.containerView.isUserInteractionEnabled = true
            cell.containerView.tag = indexPath.item
            cell.containerView.addGestureRecognizer(carTypeChkBoxTapGue)
            
            cell.allowRentalView.isHidden = true
            cell.heightContainerView.constant = 60
            
            GeneralFunctions.setImgTintColor(imgView: cell.checkRadioImgView, color: UIColor.UCAColor.AppThemeColor)
            
            //            carTypeSwitch.addTarget(self, action: #selector(self.carTypeStatusChanged), for: .valueChanged)
         
            
            if(self.carTypesStatusArrForDelAll[indexPath.row] == true){
                
                cell.checkRadioImgView.image = UIImage.init(named:"ic_select_true")
                GeneralFunctions.setImgTintColor(imgView: cell.checkRadioImgView, color: UIColor.UCAColor.AppThemeColor)
            }else{
                
                cell.checkRadioImgView.image = UIImage.init(named:"ic_select_false")
                GeneralFunctions.setImgTintColor(imgView: cell.checkRadioImgView, color: UIColor.UCAColor.AppThemeColor)
            }
            cell.carTypeChkBox.delegate = self
           
            //        if(self.eType.uppercased() == Utils.cabGeneralType_Ride_Deliver.uppercased()){
            //            cell.vtypeLbl.isHidden = false
            //            cell.vtypeLbl.text = String(format:"(%@)",item.get("eType"))
            //            cell.allowRentalView.isHidden = true
            //            cell.heightContainerView.constant = 60
            //        }
            
          
            if(item.get("IS_SHOW_VEHICLE_TYPE").uppercased() == "YES"){
                cell.vtypeLbl.isHidden = false
                var eTypeValue = ""
                if item.get("eType") == Utils.cabGeneralType_Deliver
                {
                    eTypeValue = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY")
                }else if item.get("eType") == Utils.cabGeneralType_Ride
                {
                    eTypeValue = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE")
                }else
                {
                    eTypeValue = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERALL")
                }
                
                cell.vtypeLbl.text = String(format:"(%@)",eTypeValue)
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    @objc func carTypeChkBoxTapped(sender:UITapGestureRecognizer){
        let index = sender.view!.tag
        for i in 0..<self.carTypesStatusArrForDelAll.count
        {
            if i == index
            {
                if self.carTypesStatusArrForDelAll[index] == true{
                    self.carTypesStatusArrForDelAll[index] = false
                }else{
                    self.carTypesStatusArrForDelAll[index] = true
                }
                
            }else{
                self.carTypesStatusArrForDelAll[i] = false
            }
        }
        
        self.tableView.reloadData()
    }
    
    @objc func selectServiceViewTapped(sender:UITapGestureRecognizer){
        let index = sender.view!.tag
        self.carTypesRentalStatusArr[index] = self.carTypesRentalStatusArr[index] == true ? false : true
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        var extraHeight : CGFloat = 0
        let item = self.carTypeArr[checkBox.tag]
        self.carTypesStatusArr[checkBox.tag] = checkBox.on
        if !checkBox.on {
            self.carTypesRentalStatusArr[checkBox.tag] = checkBox.on
            if item.get("eRental").uppercased() == "YES"{
                extraHeight = -25
            }
        }else{
            if item.get("eRental").uppercased() == "YES"{
                extraHeight = 25
            }
        }
        
        self.heightTableview.constant += extraHeight
        _ = self.contentView.frame.height + self.heightTableview.constant + 40
        self.PAGE_HEIGHT += extraHeight
        self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: self.PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
        
        tableView.reloadRows(at: [IndexPath(item: checkBox.tag, section: 0)], with: .none)
    }
    
    
    //    func carTypeStatusChanged(sender:UISwitch){
    //        self.carTypesStatusArr[sender.tag] = sender.isOn
    //    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.submitBtn){
            checkData()
        }
    }
    
    func checkData(){
        
        self.view.endEditing(true)
        
        if(userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
            if(self.selectedMakeId == -1){
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_MAKE"), uv: self)
                return
            }
            
            
            if(self.selectedModelId == -1){
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_VEHICLE_MODEL"), uv: self)
                return
            }
            
            
            if(self.selectedYearId == -1){
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_YEAR"), uv: self)
                return
            }
            
            if(Utils.checkText(textField: self.licPlatTxtField.getTextField()!) == false){
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "Please add your car's licence plate no.", key: "LBL_ADD_LICENCE_PLATE"), uv: self)
                return
            }
        }
        
        var isCarTypeSelected = false
        var carTypes_str = ""
        var rentalCarTypes_str = ""
        
        for i in 0..<self.carTypesStatusArr.count{
            if(self.carTypesStatusArr[i] == true){
                isCarTypeSelected = true
                let carTypeId = self.carTypeArr[i].get("iVehicleTypeId")
                carTypes_str = carTypes_str == "" ? carTypeId : ("\(carTypes_str),\(carTypeId)")
            }
        }
        
        for i in 0..<self.carTypesStatusArrForDelAll.count{
            if(self.carTypesStatusArrForDelAll[i] == true){
                isCarTypeSelected = true
                let carTypeId = self.carTypeArrOfDelAll[i].get("iVehicleTypeId")
                carTypes_str = carTypes_str == "" ? carTypeId : (carTypes_str + "," + carTypeId)
            }
        }
        
        for i in 0..<self.carTypesRentalStatusArr.count{
            if(self.carTypesRentalStatusArr[i] == true){
                isCarTypeSelected = true
                let carTypeId = self.carTypeArr[i].get("iVehicleTypeId")
                rentalCarTypes_str = rentalCarTypes_str == "" ? carTypeId : (rentalCarTypes_str + "," + carTypeId)
            }
        }
        
        if(isCarTypeSelected == false){
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CAR_TYPE"), uv: self)
            return
        }
        
        if(userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
            let vMakeId = self.carlistArr[self.selectedMakeId].get("iMakeId")
            let vModelId = self.modelsArr[self.selectedModelId].get("iModelId")
            
            if userProfileJson.get("ENABLE_EDIT_DRIVER_VEHICLE").uppercased() == "NO"{
                if iDriverVehicleId == ""{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COMFIRM_ADD_VEHICLE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_TXT").uppercased(), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased(), completionHandler: { (btnClickedId) in
                        
                        if btnClickedId == 0{
                            self.updateCarDetails(carTypes: carTypes_str, vMakeId: vMakeId, vModelId: vModelId, rentalCarTypes: rentalCarTypes_str)
                        }
                    })
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_VEHICLE_DISABLED"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT").uppercased() , nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT").uppercased(), completionHandler: { (btnClickedId) in
                        
                        if(btnClickedId == 1){
                            let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                            self.pushToNavController(uv: contactUsUv)
                        }
                    })
                }
                return
            }
            updateCarDetails(carTypes: carTypes_str, vMakeId: vMakeId, vModelId: vModelId , rentalCarTypes : rentalCarTypes_str)
        }else{
            
            updateCarDetails(carTypes: carTypes_str, vMakeId: "", vModelId: "" , rentalCarTypes : "")
        }
    }
    
    func updateCarDetails(carTypes:String, vMakeId:String, vModelId:String , rentalCarTypes:String){
        
        var deliverAllVehicleAdeed = "No"
        for i in 0..<self.carTypesStatusArrForDelAll.count{
            if(self.carTypesStatusArrForDelAll[i] == true){
                deliverAllVehicleAdeed = "Yes"
            }
        }
        
        
        let parameters = ["type":"UpdateDriverVehicle","iDriverId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iMakeId": vMakeId, "iModelId": vModelId, "iYear": Configurations.convertNumToEnglish(numStr:  Utils.getText(textField: self.yearTxtField.getTextField()!)), "vLicencePlate": Utils.getText(textField: self.licPlatTxtField.getTextField()!), "vCarType": carTypes, "iDriverVehicleId": iDriverVehicleId, "vColor": Utils.getText(textField: self.colorTxtField.getTextField()!), "HandiCap": "\(self.handiCapChkBox.on == true ? "Yes" : "No")","ChildAccess": "\(self.childAccessChkBox.on == true ? "Yes" : "No")","WheelChair": "\(self.wheelChairChkBox.on == true ? "Yes" : "No")", "eType": "\(self.eType)" , "vRentalCarType" : rentalCarTypes, "eAddedDeliverVehicle": deliverAllVehicleAdeed]
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    if(self.iDriverVehicleId == ""){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPLOAD_DOC").uppercased(), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SKIP_TXT").uppercased(), completionHandler: { (btnClickedId) in
                            
                            if(self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased() || self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Deliver.uppercased()){
                                GeneralFunctions.saveValue(key: "IS_VEHICLE_ADDED", value: "Yes" as AnyObject)
                            }
                            
                            if(btnClickedId == 1){
                                if(self.isFromMainPage == true && self.mainScreenUv != nil){
                                    
                                    self.closeCurrentScreen()
//                                    if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
//                                        self.mainScreenUv.openManageVehiclesScreen()
//                                    }
                                    return
                                }
                                
                                if self.isFromDriverStatesUV{
                                    self.closeCurrentScreen()
                                    return
                                }
                                
                                if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                                    self.performSegue(withIdentifier: "unwindToManageVehicles", sender: self)
                                }
                            }else{
                                let listOfDocumentUV = GeneralFunctions.instantiateViewController(pageName: "ListOfDocumentUV") as! ListOfDocumentUV
                                listOfDocumentUV.LIST_TYPE = "vehicle"
                                listOfDocumentUV.iDriverVehicleId = dataDict.get("VehicleInsertId")
                                listOfDocumentUV.fromAddVehicle = true
                                
                                listOfDocumentUV.manageVehiUV = self.manageVehiUV
                                self.pushToNavController(uv: listOfDocumentUV)
                            }
                            
                        })
                    }else{
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                            
                            if(self.isFromMainPage == true && self.mainScreenUv != nil){
                                self.closeCurrentScreen()
                                if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                                    self.mainScreenUv.openManageVehiclesScreen()
                                }
                                return
                            }
                            
                            if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                                self.performSegue(withIdentifier: "unwindToManageVehicles", sender: self)
                            }
                        })
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
        })
        
    }
    
}
