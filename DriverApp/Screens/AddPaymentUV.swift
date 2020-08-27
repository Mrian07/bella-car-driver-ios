//
//  AddPaymentUV.swift
//  DriverApp
//
//  Created by ADMIN on 19/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData
import Stripe

class AddPaymentUV: UIViewController, MyBtnClickDelegate, UIWebViewDelegate, STPPaymentCardTextFieldDelegate, MyTxtFieldOnTextChangeDelegate, CardIOPaymentViewControllerDelegate {
    
    var PAGE_HEIGHT:CGFloat = 595
    
    @IBOutlet weak var cardImgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var creditCardNumView: UIView!
    @IBOutlet weak var creditCardTxtField: MyTextField!
    @IBOutlet weak var cardNameAreaView: UIView!
    @IBOutlet weak var cardNameTxtField: MyTextField!
    @IBOutlet weak var expiryView: UIView!
    @IBOutlet weak var monthTxtField: MyTextField!
    @IBOutlet weak var yearTxtField: MyTextField!
    @IBOutlet weak var cvvView: UIView!
    @IBOutlet weak var cvvTxtField: MyTextField!
    @IBOutlet weak var configCardBtn: MyButton!
    @IBOutlet weak var stripeCardTxtField: STPPaymentCardTextField!
    
    let generalFunc = GeneralFunctions()
    
    var paymentUv:PaymentUV!
    
    var payMentMethod = ""
    var PAGE_MODE = "ADD"
    var isPageLoad = false
    
    var required_str = ""
    var invalid_str = ""
    
    var cntView:UIView!
    var loadingDialog:NBMaterialLoadingDialog!
    var payMayaToken = ""
    
    var userProfileJson:NSDictionary!
    
    override func viewWillAppear(_ animated: Bool){
        self.configureRTLView()
        self.addBackBarBtn()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.addBackBarBtn()
        
        cntView = self.generalFunc.loadView(nibName: "AddPaymentScreenDesign", uv: self, contentView: scrollView)
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
        self.scrollView.addSubview(cntView)
        self.scrollView.bounces = false
        
        setData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(self.navigationController != nil){
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
       
        if(("CardIOCreditCardInfo").classFromString()){
            let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_camera_nav")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openCardScanner))
            if(self.navigationController != nil){
                self.navigationItem.rightBarButtonItem = rightButton
            }
        }
    }
    
    func setData(){
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: self.PAGE_MODE == "ADD" ? "LBL_ADD_CARD" : "LBL_CHANGE_CARD")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: self.PAGE_MODE == "ADD" ? "LBL_ADD_CARD" : "LBL_CHANGE_CARD")
        
        creditCardNumView.layer.shadowOpacity = 0.5
        creditCardNumView.layer.shadowOffset = CGSize(width: 0, height: 3)
        creditCardNumView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
        expiryView.layer.shadowOpacity = 0.5
        expiryView.layer.shadowOffset = CGSize(width: 0, height: 3)
        expiryView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
        cvvView.layer.shadowOpacity = 0.5
        cvvView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cvvView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
        self.creditCardTxtField.textFieldType = "CARD"
        self.creditCardTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Card Number", key: "LBL_CARD_NUMBER_TXT"))
        self.cardNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Card Holder Name", key: "LBL_CARD_HOLDER_NAME_TXT"))
        self.monthTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EXP_MONTH_HINT_TXT"))
        self.yearTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EXP_YEAR_HINT_TXT"))
        self.cvvTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "CVV", key: "LBL_CVV"))
        
        self.cvvTxtField.maxCharacterLimit = 5
        self.creditCardTxtField.maxCharacterLimit = 20
        self.monthTxtField.maxCharacterLimit = 2
        self.yearTxtField.maxCharacterLimit = 4

        self.configCardBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: self.PAGE_MODE == "ADD" ? "LBL_ADD_CARD" : "LBL_CHANGE_CARD"))
        
        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD_ERROR_TXT")
        invalid_str =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVALID")
        
        self.configCardBtn.clickDelegate = self

        self.creditCardTxtField.getTextField()!.keyboardType = .numberPad
        self.monthTxtField.getTextField()!.keyboardType = .numberPad
        self.yearTxtField.getTextField()!.keyboardType = .numberPad
        self.cvvTxtField.getTextField()!.keyboardType = .numberPad
        
        self.cvvTxtField.getTextField()!.isSecureTextEntry = true
        
        cardImgView.image = UIImage(named: "ic_card_unknown")
        
        self.cardNameAreaView.isHidden = true
        self.stripeCardTxtField.isHidden = true
        
        self.creditCardTxtField.onTextChangedDelegate = self
        
        CardIOUtilities.preload()
    }
    
    @objc func openCardScanner(){
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        
        if(cardIOVC != nil){
            cardIOVC!.hideCardIOLogo = true
            
            cardIOVC!.collectCVV = true
            cardIOVC!.languageOrLocale = Configurations.getGoogleMapLngCode()
//            cardIOVC!.navigationBarStyleForCardIO = .black
            cardIOVC!.keepStatusBarStyleForCardIO = true
            cardIOVC!.navigationBarTintColorForCardIO = UIColor.UCAColor.AppThemeColor
//            cardIOVC!.navigationBarTintColor = UIColor.UCAColor.AppThemeColor
//            cardIOVC!.navigationBar.barTintColor = UIColor.UCAColor.AppThemeColor
            
            self.present(cardIOVC!, animated: true, completion: nil)
        }
        
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        
        paymentViewController.dismiss(animated: true, completion: nil)
        
        if let info = cardInfo {
//            let str = NSString(format: "Received card info.\n Cardholders Name: %@ \n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.cardholderName, info.cardNumber, info.expiryMonth, info.expiryYear, info.cvv)
//
//            print(str)
            self.creditCardTxtField.setText(text: info.cardNumber.separate(every: 4, with: " "))
            self.cardNameTxtField.setText(text: info.cardholderName != nil ? info.cardholderName! : "")
            self.monthTxtField.setText(text: "\(info.expiryMonth < 10 ? "0\(info.expiryMonth)" : "\(info.expiryMonth)" )")
            self.yearTxtField.setText(text: "\(info.expiryYear)")
            
            self.cvvTxtField.setText(text: info.cvv)

        }
        
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
        if(sender == self.creditCardTxtField){
            self.setCardImage(text)
        }
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        if(textField.cardNumber != nil){
            self.setCardImage(textField.cardNumber!)
        }
        
//        Utils.printLog(msgData: "CardName:\(STPCardValidator.brand(forNumber: textField.cardNumber!))")
    }
    
    func setCardImage(_ cardNumber:String){
        switch STPCardValidator.brand(forNumber: cardNumber) {
        case STPCardBrand.visa:
//            Utils.printLog(msgData: "Visa")
            cardImgView.image = UIImage(named: "ic_visa")
            break
        case STPCardBrand.amex:
            cardImgView.image = UIImage(named: "ic_amex")
//            Utils.printLog(msgData: "Amex")
            break
        case STPCardBrand.dinersClub:
            cardImgView.image = UIImage(named: "ic_diners")
//            Utils.printLog(msgData: "DinnersClub")
            break
        case STPCardBrand.discover:
            cardImgView.image = UIImage(named: "ic_discover")
//            Utils.printLog(msgData: "Discover")
            break
        case STPCardBrand.JCB:
            cardImgView.image = UIImage(named: "ic_jcb")
//            Utils.printLog(msgData: "JCB")
            break
        case STPCardBrand.masterCard:
            cardImgView.image = UIImage(named: "ic_mastercard")
//            Utils.printLog(msgData: "MasterCard")
            break
        case STPCardBrand.unionPay:
            cardImgView.image = UIImage(named: "ic_unionpay")
//            Utils.printLog(msgData: "UnionPay")
            break
        default:
            cardImgView.image = UIImage(named: "ic_card_unknown")
//            Utils.printLog(msgData: "NotFound")
            break
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.configCardBtn){
            checkData()
        }
    }
    
    func checkData(){
      
        var isCardNameEntered = true
        if(self.cardNameAreaView.isHidden == false){
          isCardNameEntered =  Utils.checkText(textField: creditCardTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.creditCardTxtField.getTextField()!, error: required_str)
        }
        let monthNum = Utils.getText(textField: self.monthTxtField.getTextField()!).isNumeric() ? GeneralFunctions.parseFloat(origValue: 0, data: Utils.getText(textField: self.monthTxtField.getTextField()!)) : 0
        
        let cardNoEntered = Utils.checkText(textField: creditCardTxtField.getTextField()!) ? (STPCardValidator.validationState(forNumber: Utils.getText(textField: self.creditCardTxtField.getTextField()!), validatingCardBrand: true) == .valid ? true : Utils.setErrorFields(textField: self.creditCardTxtField.getTextField()!, error: invalid_str)) : Utils.setErrorFields(textField: self.creditCardTxtField.getTextField()!, error: required_str)
        
        let monthEntered = Utils.checkText(textField: monthTxtField.getTextField()!) ? ((Utils.getText(textField: self.monthTxtField.getTextField()!).isNumeric() == false || Utils.getText(textField: self.monthTxtField.getTextField()!).count < 2) ? Utils.setErrorFields(textField: self.monthTxtField.getTextField()!, error: invalid_str) : ( monthNum > 12 ? Utils.setErrorFields(textField: self.monthTxtField.getTextField()!, error: invalid_str) : true)) : Utils.setErrorFields(textField: self.monthTxtField.getTextField()!, error: required_str)

        let yearEntered = Utils.checkText(textField: yearTxtField.getTextField()!) ? ((Utils.getText(textField: self.yearTxtField.getTextField()!).isNumeric() == false || Utils.getText(textField: self.yearTxtField.getTextField()!).count < 4 || Utils.getText(textField: self.yearTxtField.getTextField()!).count > 4) ? Utils.setErrorFields(textField: self.yearTxtField.getTextField()!, error: invalid_str) : true) : Utils.setErrorFields(textField: self.yearTxtField.getTextField()!, error: required_str)
        
        let cvvEntered = Utils.checkText(textField: cvvTxtField.getTextField()!) ? ((Utils.getText(textField: self.cvvTxtField.getTextField()!).isNumeric() == false || Utils.getText(textField: self.cvvTxtField.getTextField()!).count < 2 || Utils.getText(textField: self.cvvTxtField.getTextField()!).count > 4) ? Utils.setErrorFields(textField: self.cvvTxtField.getTextField()!, error: invalid_str) : true) : Utils.setErrorFields(textField: self.cvvTxtField.getTextField()!, error: required_str)

        if (self.payMentMethod == "ZOOP" && (cardNoEntered == false || cvvEntered == false || monthEntered == false || yearEntered == false || isCardNameEntered == false)) {
            return;
        }
        
        DispatchQueue.main.async() {
            self.createZOOPCustomer()
        }
    }
    
    // FOR ZOOP PAYMENT GATEWAY
    func createZOOPCustomer(){
        
        let ZOOP_MARKETPLACE_ID = self.userProfileJson.get("ZOOP_MARKETPLACE_ID")
        let parameters = ["first_name":self.userProfileJson.get("vName"),"last_name": self.userProfileJson.get("vLastName"), "description": "Customer for \(self.userProfileJson.get("vEmail"))", "email": self.userProfileJson.get("vEmail")] as NSDictionary
        
        var request = URLRequest(url: URL(string: "https://api.zoop.ws/v1/marketplaces/\(ZOOP_MARKETPLACE_ID)/buyers")!)
        
        request.httpMethod = "POST"
        
        let username = self.userProfileJson.get("ZOOP_PUBLISH_KEY")
        let password = ""
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let session = URLSession.shared
        
        loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(self.contentView, isCancelable: false, message: (GeneralFunctions()).getLanguageLabel(origValue: "Loading", key: "LBL_LOADING_TXT"))
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            self.loadingDialog.hideDialog()

            if response != nil{
                let resp = String(data: data!, encoding: String.Encoding.utf8)!
                let data = resp.data(using: String.Encoding.utf8)
                let dataDic = try! JSONSerialization.jsonObject(with: data!) as! NSDictionary
                if dataDic.get("id") == ""{
                    let errorObj = dataDic.getObj("error")
                    if errorObj.get("message") == ""{
                        self.loadingDialog.hideDialog()
                        self.generalFunc.setError(uv: self)
                    }else{
                        self.loadingDialog.hideDialog()
                        self.generalFunc.setError(uv: self, title: "", content: errorObj.get("message"))
                    }
                    return
                }
                self.getZOOPCardToken(customerID: (dataDic.get("id")))
            }else{
                self.loadingDialog.hideDialog()
                self.generalFunc.setError(uv: self)
            }
            
        })
        
        task.resume()
    }
    
    func getZOOPCardToken(customerID:String){
        if customerID != ""{
            
            let ZOOP_MARKETPLACE_ID = self.userProfileJson.get("ZOOP_MARKETPLACE_ID")
            
            let parameters = ["card_number":(Utils.getText(textField: self.creditCardTxtField.getTextField()!)).replace(" ", withString: ""),"holder_name": self.userProfileJson.get("vName") + " " + self.userProfileJson.get("vLastName"), "expiration_month": (Utils.getText(textField: self.monthTxtField.getTextField()!)), "expiration_year": (Utils.getText(textField: self.yearTxtField.getTextField()!)), "security_code":Utils.getText(textField: self.cvvTxtField.getTextField()!)] as NSDictionary
            
            var request = URLRequest(url: URL(string: "https://api.zoop.ws/v1/marketplaces/\(ZOOP_MARKETPLACE_ID)/cards/tokens")!)
            request.httpMethod = "POST"
            
            let username = self.userProfileJson.get("ZOOP_PUBLISH_KEY")
            let password = ""
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
            loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(self.contentView, isCancelable: false, message: (GeneralFunctions()).getLanguageLabel(origValue: "Loading", key: "LBL_LOADING_TXT"))
            
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                self.loadingDialog.hideDialog()
                if response != nil{
                    let resp = String(data: data!, encoding: String.Encoding.utf8)!
                    let data = resp.data(using: String.Encoding.utf8)
                    let dataDic = try! JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    if dataDic.get("id") == ""{
                        let errorObj = dataDic.getObj("error")
                        if errorObj.get("message") == ""{
                            self.loadingDialog.hideDialog()
                            self.generalFunc.setError(uv: self)
                        }else{
                            self.loadingDialog.hideDialog()
                            self.generalFunc.setError(uv: self, title: "", content: errorObj.get("message"))
                        }
                        return
                    }
                    self.genrateZoopCustomer(customerID: customerID, cardTokenID: dataDic.get("id"), CardId: dataDic.getObj("card").get("id"))
                }else{
                    self.loadingDialog.hideDialog()
                    self.generalFunc.setError(uv: self)
                }
                
            })
            
            task.resume()
            
        }else{
            self.generalFunc.setError(uv: self)
        }
    }
    
    func genrateZoopCustomer(customerID:String, cardTokenID:String, CardId:String)
    {
        if customerID != "" && cardTokenID != "" && CardId != ""{
            
            var maskedCreditCardNo = ""
            
            let creditCardNo = Utils.getText(textField: self.creditCardTxtField.getTextField()!).replace(" ", withString: "")
            
            for i in 0 ..< creditCardNo.count {
                if(i < ((creditCardNo.count) - 4)){
                    maskedCreditCardNo = "\(maskedCreditCardNo)X"
                }else{
                    maskedCreditCardNo = "\(maskedCreditCardNo)\(creditCardNo.charAt(i: i))"
                }
            }
            
            let parameters = ["type":"GenerateCustomer","iUserId": GeneralFunctions.getMemberd(), "vZoopToken": cardTokenID, "vZoopCardId":CardId, "vZoopCustId":customerID, "UserType": Utils.appUserType, "CardNo": maskedCreditCardNo]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
            exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
            exeWebServerUrl.currInstance = exeWebServerUrl
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        
                        GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)

                        self.paymentUv!.setData()
                        self.closeCurrentScreen()
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
            })
        }
        
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let url : URL? = request.url
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        let urlString : String = url!.absoluteString
        
        if (urlString.contains(find: "PAYMENT_SUCCESS") || urlString.contains(find: "success") || urlString.contains(find: "success.php")){
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            self.navigationItem.setHidesBackButton(true, animated:false);
            self.view.isUserInteractionEnabled = false
            
        }else if (urlString.contains(find: "PAYMENT_FAILURE") || urlString.contains(find: "failure") || urlString.contains(find: "failure.php")){
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST_FAILED_PROCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
                self.closeCurrentScreen()
            })
        }else{
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}
