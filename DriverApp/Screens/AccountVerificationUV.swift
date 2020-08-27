//
//  AccountVerificationUV.swift
//  DriverApp
//
//  Created by ADMIN on 09/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class AccountVerificationUV: UIViewController, MyBtnClickDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    
    //    var userProfileJsonDict:NSDictionary?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var mainScreenUv:MainScreenUV?
    var menuScreenUv:MenuScreenUV?
    
    @IBOutlet weak var smsView: UIView!
    @IBOutlet weak var smsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var samsHeaderLbl: MyLabel!
    @IBOutlet weak var smsTxtField: MyTextField!
    @IBOutlet weak var smsOkBtn: MyButton!
    @IBOutlet weak var smsMobileNumLbl: MyLabel!
    @IBOutlet weak var smsSentLbl: MyLabel!
    @IBOutlet weak var smsResendBtn: MyButton!
    @IBOutlet weak var smsMobileEditBtn: MyButton!
    @IBOutlet weak var smsHelpLbl: MyLabel!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emailHeaderLbl: MyLabel!
    @IBOutlet weak var emailTxtField: MyTextField!
    @IBOutlet weak var emailOkBtn: MyButton!
    @IBOutlet weak var emailSentLbl: MyLabel!
    @IBOutlet weak var emailIdLbl: MyLabel!
    @IBOutlet weak var emailResendBtn: MyButton!
    @IBOutlet weak var emailEditBtn: MyButton!
    @IBOutlet weak var emailHelpLbl: MyLabel!
    @IBOutlet weak var demoHintLbl: MyLabel!
    @IBOutlet weak var demoHintLblHeight: NSLayoutConstraint!
    
    // Edit Mobile/Email View Outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cancelViewLbl: MyLabel!
    @IBOutlet weak var hLbl: MyLabel!
    @IBOutlet weak var hImgView: UIImageView!
    @IBOutlet weak var viewDesLbl: MyLabel!
    @IBOutlet weak var editBoxTxtField: MyTextField!
    @IBOutlet weak var updateLbl: MyLabel!
    @IBOutlet weak var countryLbl: MyLabel!
    @IBOutlet weak var countryImgView: UIImageView!
    
    var isSignUpPage = false
    var isFbVerifyPage = false
    var isEditProfile = false
    var isAccountInfo = false
    var isMainPage = false
    
    var emailVerificationCode = ""
    var smsVerificationCode = ""
    
    var mobileNumVerified = false
    var emailIdVerified = false
    
    var requestType = ""
    
    let generalFunc = GeneralFunctions()
    var userProfileJson:NSDictionary!
    
    var mobileNum = ""
    
    var isFirstLaunch = true
    var isFirstVerification = false
    
    var isEditInfoTapped = false
    
    var cntView:UIView!
    
    var bgEditView:UIView!
    var contentEditInfoView:UIView!
    
    var selectedCountryCode = ""
    var selectedPhoneCode = ""
    
    var freqTask_Phone:UpdateFreqTask!
    var freqTask_Email:UpdateFreqTask!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isFirstLaunch){
            setScreenHeight()
            isFirstLaunch = false
        }
    }
    
    func setScreenHeight(){
        self.smsViewHeight.constant = smsView.isHidden == false ? (235 + self.smsHelpLbl.frame.size.height - 20) : 0
        
        self.emailViewHeight.constant = emailView.isHidden == false ? (235 + self.emailHelpLbl.frame.size.height - 20) : 0
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.smsViewHeight.constant + self.emailViewHeight.constant + 40)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackBarBtn()
        cntView = self.generalFunc.loadView(nibName: "AccountVerificationScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        setData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_TXT")
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        samsHeaderLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_MOBILE_VERIFy_TXT")
        smsSentLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_SMS_SENT_TO")
        samsHeaderLbl.textColor = UIColor.UCAColor.AppThemeColor_1
        emailHeaderLbl.textColor = UIColor.UCAColor.AppThemeColor_1
        
        emailHeaderLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_VERIFy_TXT")
        emailSentLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_SENT_TO")
        
        smsHelpLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_SMS_SENT_NOTE")
        emailHelpLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_SENT_NOTE")
        
        self.smsHelpLbl.fitText()
        self.emailHelpLbl.fitText()
        
        self.smsResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_SMS"))
        self.smsMobileEditBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_MOBILE"))
        self.smsOkBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"))
        self.emailOkBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"))
        self.emailResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_EMAIL"))
        self.emailEditBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_EMAIL"))
        
        self.smsResendBtn.clickDelegate = self
        self.smsMobileEditBtn.clickDelegate = self
        self.smsOkBtn.clickDelegate = self
        self.emailOkBtn.clickDelegate = self
        self.emailResendBtn.clickDelegate = self
        self.emailEditBtn.clickDelegate = self
        
        if(isEditProfile || isSignUpPage || isAccountInfo){
            smsMobileNumLbl.text = "+\(mobileNum)"
        }else{
            setUserData()
        }
        
        if(requestType.trim() == "DO_PHONE_VERIFY"){
            emailViewHeight.constant = 0
            emailView.isHidden = true
            
            emailIdVerified = true
            
            self.emailViewHeight.constant = 0
        }else if(requestType.trim() == "DO_EMAIL_VERIFY"){
            smsViewHeight.constant = 0
            smsView.isHidden = true
            
            mobileNumVerified = true
            
            self.smsViewHeight.constant = 0
        }
        requestVerification()
        
        demoHintLbl.text = "Note: Please enter the OTP \"12345\" If you do not receive SMS/EMAIL on your registered number in next one minute. "
        demoHintLbl.backgroundColor = UIColor(hex: 0x4cb74c)
        demoHintLbl.textColor = UIColor.white
        demoHintLbl.fitText()
        
        
        if(GeneralFunctions.getValue(key: Utils.SITE_TYPE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.SITE_TYPE_KEY) as! String).uppercased() == "DEMO"){
            demoHintLbl.isHidden = false
        }else{
            demoHintLbl.isHidden = true
            self.demoHintLblHeight.constant = 0
        }
        
        emailView.layer.shadowOpacity = 0.5
        emailView.layer.shadowOffset = CGSize(width: 0, height: 3)
        emailView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
        smsView.layer.shadowOpacity = 0.5
        smsView.layer.shadowOffset = CGSize(width: 0, height: 3)
        smsView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
    }
    
    func setUserData(){
        self.removeView()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        mobileNum = userProfileJson.get("vCode") + userProfileJson.get("vPhone")
        
        let ePhoneVerified = userProfileJson.get("ePhoneVerified")
        let eEmailVerified = userProfileJson.get("eEmailVerified")
        
        selectedCountryCode = userProfileJson.get("vCountry")
        selectedPhoneCode = userProfileJson.get("vCode")
        
        if(isEditInfoTapped == true){
            if((smsMobileNumLbl.text! != "+\(mobileNum)" && ePhoneVerified.uppercased() != "YES") && (emailIdLbl.text! != userProfileJson.get("vEmail") && eEmailVerified.uppercased() != "YES")){
                requestType = "DO_EMAIL_PHONE_VERIFY"
                self.smsView.isHidden = false
                self.emailView.isHidden = false
                
                self.emailIdVerified = false
                self.mobileNumVerified = false
                
                emailVerificationCode = ""
                smsVerificationCode = ""
                
                self.setScreenHeight()
                requestVerification()
            }else if(smsMobileNumLbl.text! != "+\(mobileNum)" && ePhoneVerified.uppercased() != "YES"){
                requestType = "DO_PHONE_VERIFY"
                self.smsView.isHidden = false
                
                smsVerificationCode = ""
                
                self.mobileNumVerified = false
                
                self.setScreenHeight()
                requestVerification()
            }else if(emailIdLbl.text! != userProfileJson.get("vEmail") && eEmailVerified.uppercased() != "YES"){
                requestType = "DO_EMAIL_VERIFY"
                
                emailVerificationCode = ""
                
                self.emailIdVerified = false
                
                self.emailView.isHidden = false
                self.setScreenHeight()
                requestVerification()
            }else{
                self.smsView.isHidden = true
                self.emailView.isHidden = true
                
                self.closeCurrentScreen()
            }
            
            isEditInfoTapped = false
        }
        
        
        if(smsMobileNumLbl != nil){
            smsMobileNumLbl.text = "+\(mobileNum)"
        }
        
        if(emailIdLbl != nil){
            emailIdLbl.text = userProfileJson.get("vEmail")
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        self.view.endEditing(true)
        if(sender == smsResendBtn){
            requestType = "DO_PHONE_VERIFY"
            requestVerification()
        }else if(sender == smsMobileEditBtn){
            
            //            isEditInfoTapped = true
            
            if(mainScreenUv !=  nil || menuScreenUv != nil){
                
                self.openEditView(editType: "MOBILE")
                //                let manageProfileUv = GeneralFunctions.instantiateViewController(pageName: "ManageProfileUV") as! ManageProfileUV
                //                manageProfileUv.isOpenEditProfile = true
                //                manageProfileUv.isFromAccountVerifyScreen = true
                //
                //                self.pushToNavController(uv: manageProfileUv)
            }else{
                self.closeCurrentScreen()
            }
        }else if(sender == smsOkBtn){
            let smsCode_str = Utils.getText(textField: smsTxtField.getTextField()!)
            if((smsCode_str == smsVerificationCode && smsVerificationCode != "") || ((GeneralFunctions.getValue(key: Utils.SITE_TYPE_KEY) as! String).uppercased() == "DEMO" && smsCode_str == "12345")){
                requestType = "PHONE_VERIFIED"
                requestVerification()
            }else{
                
                if(smsCode_str == ""){
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_VERIFICATION_CODE"))
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFICATION_CODE_INVALID"))
                }
                
            }
            
        }else if(sender == emailOkBtn){
            
            let emailCode_str = Utils.getText(textField: emailTxtField.getTextField()!)
            //        emailCode_str == "12345" ||
            if((emailCode_str == emailVerificationCode && emailVerificationCode != "") || ((GeneralFunctions.getValue(key: Utils.SITE_TYPE_KEY) as! String).uppercased() == "DEMO" && emailCode_str == "12345")){
                requestType = "EMAIL_VERIFIED"
                requestVerification()
            }else{
                
                if(emailCode_str == ""){
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_VERIFICATION_CODE"))
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFICATION_CODE_INVALID"))
                }
            }
            
        }else if(sender == emailResendBtn){
            requestType = "DO_EMAIL_VERIFY"
            requestVerification()
        }else if(sender == emailEditBtn){
            
            //            isEditInfoTapped = true
            
            if(mainScreenUv !=  nil || menuScreenUv != nil){
                self.openEditView(editType: "EMAIL")
                // let manageProfileUv = GeneralFunctions.instantiateViewController(pageName: "ManageProfileUV") as! ManageProfileUV
                // manageProfileUv.isOpenEditProfile = true
                // manageProfileUv.isFromAccountVerifyScreen = true
                
                // self.pushToNavController(uv: manageProfileUv)
            }else{
                self.closeCurrentScreen()
            }
        }
    }
    
    func openEditView(editType:String){
        
        bgEditView = UIView()
        bgEditView.backgroundColor = UIColor.black
        bgEditView.alpha = 0.4
        //        bgView.frame = self.containerView.frame
        bgEditView.frame = CGRect(x:0, y:0, width:Application.screenSize.width, height: Application.screenSize.height)
        
        bgEditView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        let bgTapGue = UITapGestureRecognizer()
        bgTapGue.addTarget(self, action: #selector(self.removeView))
        bgEditView.addGestureRecognizer(bgTapGue)
        
        var height:CGFloat = 145 + (GeneralFunctions.getSafeAreaInsets().bottom / 2)
        
        let descriptionStr = self.generalFunc.getLanguageLabel(origValue: "", key: editType == "MOBILE" ? "LBL_MOBILE_EDIT_NOTE" : "LBL_EMAIL_EDIT_NOTE")
        
        let heightOfDescription = descriptionStr.height(withConstrainedWidth: Application.screenSize.width - 20, font: UIFont(name: Fonts().light, size: 15)!) - 18
        
        if(heightOfDescription > 0){
            height = height + heightOfDescription
        }
        
        contentEditInfoView = generalFunc.loadView(nibName: "AccountVerificationEditView", uv: self)
        
        contentEditInfoView.layer.shadowOpacity = 0.5
        contentEditInfoView.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentEditInfoView.layer.shadowColor = UIColor.black.cgColor
        
        //        if(self.navigationController != nil){
        //            contentEditInfoView.frame = CGRect(x: 0, y: Application.screenSize.height - height, width: Application.screenSize.width, height: height)
        //
        //            self.navigationController?.view.addSubview(bgEditView)
        //            self.navigationController?.view.addSubview(contentEditInfoView)
        //
        //            contentEditInfoView.tag = Utils.ALERT_DIALOG_CONTENT_TAG
        //            bgEditView.tag = Utils.ALERT_DIALOG_BG_TAG
        //        }else{
        contentEditInfoView.frame = CGRect(x: 0, y: self.cntView.frame.size.height - height, width: Application.screenSize.width, height: height)
        
        self.cntView.addSubview(bgEditView)
        self.cntView.addSubview(contentEditInfoView)
        // }
        
        self.hLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: editType == "MOBILE" ? "LBL_MOBILE_NUMBER_HEADER_TXT" : "LBL_EMAIL_LBL_TXT")
        self.hImgView.image = UIImage(named: editType == "MOBILE" ? "ic_mobile" : "ic_email_box")
        
        self.viewDesLbl.text = descriptionStr
        self.viewDesLbl.fitText()
        
        self.cancelViewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
        self.cancelViewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.hLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.editBoxTxtField.configDivider(isDividerEnabled: false)
        self.cancelViewLbl.setClickHandler { (instance) in
            self.removeView()
        }
        
        self.editBoxTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key:  editType == "MOBILE" ? "LBL_ENTER_MOBILE_HINT" : "LBL_ENTER_EMAIL_HINT"))
        self.updateLbl.text = self.generalFunc.getLanguageLabel(origValue: "Update", key: "LBL_UPDATE_TXT")
        self.editBoxTxtField.getTextField()!.placeholderAnimation = .hidden
        self.updateLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        GeneralFunctions.setImgTintColor(imgView: self.hImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.headerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        self.editBoxTxtField.getTextField()!.detailVerticalOffset = 8
        
        self.editBoxTxtField.getTextField()!.keyboardType = .emailAddress
        
        if(editType == "MOBILE"){
            self.countryLbl.isHidden = false
            self.countryImgView.isHidden = false
            countryImgView.transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
            GeneralFunctions.setImgTintColor(imgView: self.countryImgView, color: UIColor(hex: 0xbfbfbf))
            
            self.editBoxTxtField.getTextField()!.isDetailLabelPaddingLocked = true
            
            self.countryLbl.text = "+\(userProfileJson.get("vCode"))"
            let countryLblWidth = self.countryLbl.text!.width(withConstrainedHeight: 21, font: UIFont(name: Fonts().light, size: 17)!)
           
            if(Configurations.isRTLMode() == true){
                self.editBoxTxtField.textPadding = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: countryLblWidth + 27)
            }else{
                self.editBoxTxtField.textPadding = UIEdgeInsets.init(top: 0, left: countryLblWidth + 27, bottom: 0, right: 0)
            }
            
            self.editBoxTxtField.getTextField()!.keyboardType = .numberPad
            let countryTapGue = UITapGestureRecognizer()
            countryTapGue.addTarget(self, action: #selector(self.openCountrySelection))
            self.countryImgView.addGestureRecognizer(countryTapGue)
            self.countryImgView.isUserInteractionEnabled = true
            
            self.countryLbl.setClickHandler(handler: { (instance) in
                self.openCountrySelection()
            })
            
        }else{
            self.countryLbl.isHidden = true
            self.countryImgView.isHidden = true
        }
        
        self.updateLbl.setClickHandler { (instance) in
            var isDataProper = false
            let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD_ERROR_TXT")
            if(editType == "MOBILE"){
                let mobileInvalid = self.generalFunc.getLanguageLabel(origValue: "Invalid mobile no.", key: "LBL_INVALID_MOBILE_NO")
                
                isDataProper = Utils.checkText(textField: self.editBoxTxtField.getTextField()!) ? (Utils.getText(textField: self.editBoxTxtField.getTextField()!).count >= Utils.minMobileLength ? true : Utils.setErrorFields(textField: self.editBoxTxtField.getTextField()!, error: mobileInvalid)) : Utils.setErrorFields(textField: self.editBoxTxtField.getTextField()!, error: required_str)
            }else if(editType == "EMAIL"){
                isDataProper = Utils.checkText(textField: self.editBoxTxtField.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.editBoxTxtField.getTextField()!)) ? true : Utils.setErrorFields(textField: self.editBoxTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR_TXT"))) : Utils.setErrorFields(textField: self.editBoxTxtField.getTextField()!, error: required_str)
            }
            
            if(isDataProper){
                if((editType == "MOBILE" && (self.userProfileJson.get("vCode") != self.selectedPhoneCode || self.userProfileJson.get("vPhone") != Utils.getText(textField: self.editBoxTxtField.getTextField()!))) ||  (editType == "EMAIL" && self.userProfileJson.get("vEmail") != Utils.getText(textField: self.editBoxTxtField.getTextField()!))){
                    self.updateDataToServer(ACTION_TYPE: editType)
                }else{
                    self.removeView()
                }
            }
        }
    }
    
    @objc func removeView(){
        if(bgEditView != nil){
            bgEditView.removeFromSuperview()
            bgEditView = nil
        }
        
        if(contentEditInfoView != nil){
            contentEditInfoView.removeFromSuperview()
            contentEditInfoView = nil
        }
    }
    
    @objc func openCountrySelection(){
        let countryListUv = GeneralFunctions.instantiateViewController(pageName: "CountryListUV") as! CountryListUV
        countryListUv.fromAccountVerification = true
        self.pushToNavController(uv: countryListUv, isDirect: true)
    }
    
    func updateDataToServer(ACTION_TYPE:String){
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        let parameters = ["type":"updateUserProfileDetail","vName": userProfileJson.get("vName"), "vLastName": userProfileJson.get("vLastName"), "vEmail": ACTION_TYPE.uppercased() == "MOBILE" ? userProfileJson.get("vEmail") : Utils.getText(textField: self.editBoxTxtField.getTextField()!), "vPhone": ACTION_TYPE.uppercased() == "MOBILE" ? Utils.getText(textField: self.editBoxTxtField.getTextField()!) : userProfileJson.get("vPhone"), "vPhoneCode": ACTION_TYPE.uppercased() == "MOBILE" ?  self.selectedPhoneCode : userProfileJson.get("vCode"), "vCountry": ACTION_TYPE.uppercased() == "MOBILE" ? self.selectedCountryCode : userProfileJson.get("vCountry"), "vDeviceType": Utils.deviceType, "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "LanguageCode": userProfileJson.get("vLang"), "CurrencyCode": userProfileJson.get("vCurrencyDriver")]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    _ = SetUserData(uv: self, userProfileJson: dataDict, isStoreUserId: false)
                    
                    let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    
                    let vCurrencyDriver = userProfileJson.get("vCurrencyDriver")
                    
                    if((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) != userProfileJson.get("vLang") || vCurrencyDriver != userProfileJson.get("vCurrencyDriver")){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_TRIP_CANCEL_CONFIRM_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFY_RESTART_APP_TO_CHANGE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            let window = UIApplication.shared.delegate!.window!
                            
                            GeneralFunctions.restartApp(window: window!)
                        })
                        return
                    }
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    self.setUserData()
                    
                    if(ACTION_TYPE.uppercased() == "MOBILE"){
                        self.requestType = "DO_PHONE_VERIFY"
                        self.requestVerification()
                    }else if(ACTION_TYPE.uppercased() == "EMAIL"){
                        self.requestType = "DO_EMAIL_VERIFY"
                        self.requestVerification()
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func requestVerification(){
        
        if(requestType == "DO_EMAIL_PHONE_VERIFY"){
            DispatchQueue.main.async {
                self.smsResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_SMS"))
                self.emailResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_EMAIL"))
                self.emailResendBtn.setButtonEnabled(isBtnEnabled: false)
                self.emailResendBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
                self.smsResendBtn.setButtonEnabled(isBtnEnabled: false)
                self.smsResendBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
            }
        }else if(requestType == "DO_EMAIL_VERIFY"){
            if(freqTask_Email != nil){
                freqTask_Email.stopRepeatingTask()
                freqTask_Email = nil
            }
            
            DispatchQueue.main.async {
                self.emailResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_EMAIL"))
                self.emailResendBtn.setButtonEnabled(isBtnEnabled: false)
                self.emailResendBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
            }
        }else if(requestType == "DO_PHONE_VERIFY"){
            if(freqTask_Phone != nil){
                freqTask_Phone.stopRepeatingTask()
                freqTask_Phone = nil
            }
            DispatchQueue.main.async {
                self.smsResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_SMS"))
                self.smsResendBtn.setButtonEnabled(isBtnEnabled: false)
                self.smsResendBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
            }
        }
        
        let parameters = ["type":"sendVerificationSMS", "iMemberId": GeneralFunctions.getMemberd(), "MobileNo": mobileNum, "UserType": Utils.appUserType, "REQ_TYPE": requestType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.resetConfiguration(responsepositive:true, dataDict: dataDict)
                    self.checkResponse(dataDict)
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    self.resetConfiguration(responsepositive:false, dataDict: dataDict)
                }
                
            }else{
                self.generalFunc.setError(uv: self)
                self.resetConfiguration(responsepositive:false, dataDict: NSDictionary())
            }
        })
    }
    
    func resetConfiguration(responsepositive:Bool, dataDict:NSDictionary){
        
        if(requestType == "DO_EMAIL_PHONE_VERIFY"){
            
            if(responsepositive){
                var VERIFICATION_CODE_RESEND_TIME_IN_SECONDS = GeneralFunctions.parseInt(origValue: 0, data: userProfileJson.get("VERIFICATION_CODE_RESEND_TIME_IN_SECONDS"))
                
                self.smsResendBtn.setButtonTitle(buttonTitle: self.timeString(time: TimeInterval(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS)))
                self.emailResendBtn.setButtonTitle(buttonTitle: self.timeString(time: TimeInterval(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS)))
                
                self.smsResendBtn.setButtonEnabled(isBtnEnabled: false)
                self.smsResendBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
                self.emailResendBtn.setButtonEnabled(isBtnEnabled: false)
                self.emailResendBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
                
                if(dataDict.get("eEmailFailed").uppercased() == "YES"){
                    self.emailResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_EMAIL"))
                    self.emailResendBtn.setButtonEnabled(isBtnEnabled: true)
                }
                
                if(dataDict.get("eSMSFailed").uppercased() == "YES"){
                    self.smsResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_SMS"))
                    self.smsResendBtn.setButtonEnabled(isBtnEnabled: true)
                }
                
                let phonefreqTask = UpdateFreqTask(interval: 1.0)
                phonefreqTask.currInst = phonefreqTask
                freqTask_Phone = phonefreqTask
                phonefreqTask.setTaskRunHandler(handler: { (instance) in
                    
                    VERIFICATION_CODE_RESEND_TIME_IN_SECONDS = VERIFICATION_CODE_RESEND_TIME_IN_SECONDS - 1
                    
                    
                    if(dataDict.get("eSMSFailed").uppercased() != "YES"){
                        self.smsResendBtn.setButtonTitle(buttonTitle: self.timeString(time: TimeInterval(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS)))
                    }
                    
                    if(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS <= 0){
                        
                        self.smsResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_SMS"))
                        
                        self.smsResendBtn.setButtonEnabled(isBtnEnabled: true)
                        
                        instance.stopRepeatingTask()
                    }
                    
                })
                phonefreqTask.startRepeatingTask()
                
                let emailfreqTask = UpdateFreqTask(interval: 1.0)
                emailfreqTask.currInst = emailfreqTask
                freqTask_Email = emailfreqTask
                emailfreqTask.setTaskRunHandler(handler: { (instance) in
                    
                    VERIFICATION_CODE_RESEND_TIME_IN_SECONDS = VERIFICATION_CODE_RESEND_TIME_IN_SECONDS - 1
                    
                    if(dataDict.get("eEmailFailed").uppercased() != "YES"){
                        self.emailResendBtn.setButtonTitle(buttonTitle: self.timeString(time: TimeInterval(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS)))
                    }
                    
                    if(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS <= 0){
                        
                        self.emailResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_EMAIL"))
                        
                        self.emailResendBtn.setButtonEnabled(isBtnEnabled: true)
                        
                        instance.stopRepeatingTask()
                    }
                    
                })
                emailfreqTask.startRepeatingTask()
                
                
            }else{
                self.smsResendBtn.setButtonEnabled(isBtnEnabled: true)
                self.emailResendBtn.setButtonEnabled(isBtnEnabled: true)
                
                self.smsResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_SMS"))
                self.emailResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_EMAIL"))
            }
            
        }else if(requestType == "DO_EMAIL_VERIFY"){
            
            if(responsepositive){
                var VERIFICATION_CODE_RESEND_TIME_IN_SECONDS = GeneralFunctions.parseInt(origValue: 0, data: userProfileJson.get("VERIFICATION_CODE_RESEND_TIME_IN_SECONDS"))
                
                self.emailResendBtn.setButtonTitle(buttonTitle: self.timeString(time: TimeInterval(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS)))
                
                let freqTask = UpdateFreqTask(interval: 1.0)
                freqTask.currInst = freqTask
                freqTask_Email = freqTask
                freqTask.setTaskRunHandler(handler: { (instance) in
                    
                    VERIFICATION_CODE_RESEND_TIME_IN_SECONDS = VERIFICATION_CODE_RESEND_TIME_IN_SECONDS - 1
                    
                    self.emailResendBtn.setButtonTitle(buttonTitle: self.timeString(time: TimeInterval(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS)))
                    
                    if(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS <= 0){
                        
                        self.emailResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_EMAIL"))
                        
                        self.emailResendBtn.setButtonEnabled(isBtnEnabled: true)
                        
                        instance.stopRepeatingTask()
                    }
                    
                })
                freqTask.startRepeatingTask()
                
                self.emailResendBtn.setButtonEnabled(isBtnEnabled: false)
                self.emailResendBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
            }else{
                self.emailResendBtn.setButtonEnabled(isBtnEnabled: true)
                self.emailResendBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor)
            }
            
        }else if(requestType == "DO_PHONE_VERIFY"){
            
            if(responsepositive){
                var VERIFICATION_CODE_RESEND_TIME_IN_SECONDS = GeneralFunctions.parseInt(origValue: 0, data: userProfileJson.get("VERIFICATION_CODE_RESEND_TIME_IN_SECONDS"))
                
                self.smsResendBtn.setButtonTitle(buttonTitle: self.timeString(time: TimeInterval(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS)))
                
                let freqTask = UpdateFreqTask(interval: 1.0)
                freqTask.currInst = freqTask
                freqTask_Phone = freqTask
                freqTask.setTaskRunHandler(handler: { (instance) in
                    
                    VERIFICATION_CODE_RESEND_TIME_IN_SECONDS = VERIFICATION_CODE_RESEND_TIME_IN_SECONDS - 1
                    
                    self.smsResendBtn.setButtonTitle(buttonTitle: self.timeString(time: TimeInterval(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS)))
                    
                    if(VERIFICATION_CODE_RESEND_TIME_IN_SECONDS <= 0){
                        
                        self.smsResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_SMS"))
                        
                        self.smsResendBtn.setButtonEnabled(isBtnEnabled: true)
                        
                        instance.stopRepeatingTask()
                    }
                    
                })
                freqTask.startRepeatingTask()
                
                self.smsResendBtn.setButtonEnabled(isBtnEnabled: false)
                self.smsResendBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
            }else{
                self.smsResendBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_SMS"))
                self.smsResendBtn.setButtonEnabled(isBtnEnabled: true)
            }
        }
    }
    
    func timeString(time:TimeInterval) -> String{
        let min = Configurations.convertNumToAppLocal(numStr:String(format:"%02i",Int(time) / 60 % 60))
        let sec = Configurations.convertNumToAppLocal(numStr:String(format:"%02i",Int(time) % 60))
        return "\(min):\(sec)"
    }
    
    func checkResponse(_ dict:NSDictionary){
        let action_str=dict.get("Action")
        
        if(action_str == "1"){
            if(requestType == "DO_EMAIL_PHONE_VERIFY"){
                
                //                let message = dict.get("message")
                //                if(message != nil){
                let message_str = dict.get("message")
                if(message_str != ""){
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: message_str))
                }else {
                    let msg_sms = dict.get("message_sms")
                    let msg_email = dict.get("message_email")
                    
                    if(msg_sms == "LBL_MOBILE_VERIFICATION_FAILED_TXT" && msg_email == "LBL_EMAIL_VERIFICATION_FAILED_TXT"){
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACC_VERIFICATION_FAILED"))
                        return
                    }
                    if(message_str != "LBL_MOBILE_VERIFICATION_FAILED_TXT" && msg_sms != "LBL_MOBILE_VERIFICATION_FAILED_TXT"){
                        smsVerificationCode = dict.get("message_sms")
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: msg_sms))
                    }
                    
                    if(message_str != "LBL_EMAIL_VERIFICATION_FAILED_TXT" && msg_email != "LBL_EMAIL_VERIFICATION_FAILED_TXT"){
                        emailVerificationCode = dict.get("message_email")
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: msg_email))
                    }
                }
                //                }
            }else if(requestType == "DO_EMAIL_VERIFY"){
                emailVerificationCode = dict.get("message")
            }else if(requestType == "DO_PHONE_VERIFY"){
                smsVerificationCode = dict.get("message")
            }else if(requestType == "PHONE_VERIFIED"){
                DispatchQueue.main.async {
                    
                    self.mobileNumVerified = true
                    
                    
                    let userDetails = dict.getObj("userDetails")
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: userDetails.convertToJson() as AnyObject)
                    
                    if(self.emailIdVerified == true){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                            if(btnClickedId == 0){
                                if(self.isSignUpPage == true){
                                    self.performSegue(withIdentifier: "unwindToSignUp", sender: self)
                                }else if(self.isEditProfile == true){
                                    self.performSegue(withIdentifier: "unwindToEditProfile", sender: self)
                                }else if(self.isAccountInfo == true){
                                    self.performSegue(withIdentifier: "unwindToAccountInfo", sender: self)
                                }else if(self.isMainPage == true){
                                    self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
                                }else{
                                    self.closeCurrentScreen()
                                }
                            }
                        })
                    }else{
                        self.smsView.isHidden = true
                        self.smsViewHeight.constant = 0
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dict.get("message")))
                    }
                }
                
            }else if(requestType == "EMAIL_VERIFIED"){
                DispatchQueue.main.async {
                    
                    self.emailIdVerified = true
                    
                    let userDetails = dict.getObj("userDetails")
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: userDetails.convertToJson() as AnyObject)
                    
                    
                    if(self.mobileNumVerified == true){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                            if(btnClickedId == 0){
                                
                                if(self.isSignUpPage == true){
                                    self.performSegue(withIdentifier: "unwindToSignUp", sender: self)
                                }else if(self.isEditProfile == true){
                                    self.performSegue(withIdentifier: "unwindToEditProfile", sender: self)
                                }else if(self.isAccountInfo == true){
                                    self.performSegue(withIdentifier: "unwindToAccountInfo", sender: self)
                                }else if(self.isMainPage == true){
                                    self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
                                }else{
                                    self.closeCurrentScreen()
                                }
                                
                            }
                        })
                    }else{
                        self.emailView.isHidden = true
                        self.emailViewHeight.constant = 0
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dict.get("message")))
                    }
                }
                //                self.buildErrorMsg("", content: self.getLabelValue((dict.valueForKey("message") as! String)))
            }
        }else{
            self.generalFunc.setError(uv: self)
        }
        
    }
    
    
    @IBAction func unwindToAccountVerificationScreen(_ segue:UIStoryboardSegue) {
        //        unwindToSignUp
        
        if(segue.source.isKind(of: ManageProfileUV.self)){
            if(isFirstLaunch == false && (mainScreenUv != nil || menuScreenUv != nil)){
                setUserData()
            }
        }else if(segue.source.isKind(of: CountryListUV.self)){
            if(isFirstLaunch == false && (mainScreenUv != nil || menuScreenUv != nil)){
                let sourceViewController = segue.source as? CountryListUV
                let selectedPhoneCode:String = sourceViewController!.selectedCountryHolder!.vPhoneCode
                let selectedCountryCode = sourceViewController!.selectedCountryHolder!.vCountryCode
                
                self.selectedCountryCode = selectedCountryCode
                self.selectedPhoneCode = selectedPhoneCode
                //            self.countryTxtField.getTextField()!.text = "+\(selectedPhoneCode)"
                
                self.countryLbl.text = "+\(selectedPhoneCode)"
                
                let countryLblWidth = self.countryLbl.text!.width(withConstrainedHeight: 21, font: UIFont(name: Fonts().light, size: 17)!)
                if(Configurations.isRTLMode() == true){
                    self.editBoxTxtField.textPadding = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: countryLblWidth + 27)
                }else{
                    self.editBoxTxtField.textPadding = UIEdgeInsets.init(top: 0, left: countryLblWidth + 27, bottom: 0, right: 0)
                }
            }
        }
    }
}
