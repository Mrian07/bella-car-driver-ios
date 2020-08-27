//
//  SelectedDayRideHistoryUV.swift
//  DriverApp
//
//  Created by ADMIN on 24/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class SelectedDayRideHistoryUV: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ratingViewWidth: NSLayoutConstraint!
    @IBOutlet weak var tripDataContainerStackView: UIStackView!
    @IBOutlet weak var tripDataContainerStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalFareHLbl: MyLabel!
    @IBOutlet weak var totalFareVLBl: MyLabel!
    @IBOutlet weak var avgRatingHLbl: UILabel!
    @IBOutlet weak var ratingBar: RatingView!
    @IBOutlet weak var completedTripsHLbl: UILabel!
    @IBOutlet weak var completedTripsVLbl: MyLabel!
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var verticleSeperatorView: UIView!
    @IBOutlet weak var horizontalSeperatorView: UIView!
    @IBOutlet weak var tripEarningLbl: MyLabel!
    
    var loaderView:UIView!
    
    let generalFunc = GeneralFunctions()
    
    var selectedDate = ""
    
    var dataArrList = [NSDictionary]()
    
    var isPageLoad = false
    var cntView:UIView!
    
    var APP_TYPE = ""
    
    var PAGE_HEIGHT:CGFloat = 550
    
    var appTypeFilterArr:NSArray!
    var vFilterParam = ""
    var currentWebTask:ExeServerUrl!
    
    var msgLbl:MyLabel!
    
    var userProfileJson:NSDictionary!

    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        self.navigationController?.navigationBar.layer.zPosition = -1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "SelectedDayRideHistoryScreenDesign", uv: self, contentView: scrollView)
        
        self.scrollView.addSubview(cntView)
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        APP_TYPE = userProfileJson.get("APP_TYPE")
        
        scrollView.backgroundColor = UIColor(hex: 0xF2F2F4)
        self.addBackBarBtn()
        
        self.cntView.isHidden = true
        
        
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoad == false){
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
            self.scrollView.bounces = false
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            
            isPageLoad = true
            
            getData()
        }
    }

    func setData(){
        self.navigationItem.title = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: selectedDate, dateFormate: "yyyy-MM-dd"), toDateFormate: Utils.dateFormateInHeaderBar)
        self.title = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: selectedDate, dateFormate: "yyyy-MM-dd"), toDateFormate: Utils.dateFormateInHeaderBar)
//        EEE, MMM d, yyyy  yyyy-MM-dd
        self.topHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.completedTripsVLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.totalFareVLBl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.completedTripsHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOTAL_SERVICES").uppercased()
        self.totalFareHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Total_Fare").uppercased()
        self.avgRatingHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AVG_RATING").uppercased()
        self.tripEarningLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_EARNING")
        
        verticleSeperatorView.backgroundColor = UIColor.UCAColor.AppThemeColor.lighter(by: 20)
        horizontalSeperatorView.backgroundColor = UIColor.UCAColor.AppThemeColor.lighter(by: 20)
        
        if(ratingViewWidth.constant > 150){
            ratingViewWidth.constant = 150
        }
        
    }
    
    func resetPageData(){
        self.dataArrList.removeAll()
        tripDataContainerStackView.subviews.forEach({ $0.removeFromSuperview() })
        
        let dataHeight = CGFloat(dataArrList.count * 80)
        self.PAGE_HEIGHT = self.topHeaderView.frame.height + dataHeight + 80
        
        self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
        
        self.tripDataContainerStackViewHeight.constant = dataHeight
    }
    
    func getData(){
        if(loaderView != nil){
            loaderView.removeFromSuperview()
            loaderView = nil
        }
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        
        self.cntView.isHidden = true
        
        if(self.msgLbl != nil){
            self.msgLbl.removeFromSuperview()
            self.msgLbl = nil
        }
        
        resetPageData()
      
        if(currentWebTask != nil){
            currentWebTask.cancel()
            currentWebTask = nil
        }
        
        let parameters = ["type":"getDriverRideHistory", "UserType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd(), "date": selectedDate, "vFilterParam": vFilterParam]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        currentWebTask = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                let appTypeFilterArr = dataDict.getArrObj("AppTypeFilterArr")
                if(appTypeFilterArr.count > 0){
                    self.appTypeFilterArr = appTypeFilterArr
                    let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_filter_list_history")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.filterDataTapped))
                    self.navigationItem.rightBarButtonItem = rightButton
                }else{
                    self.navigationItem.rightBarButtonItem = nil
                }
                
                
                let currencySymbol = dataDict.get("CurrencySymbol")
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        self.dataArrList += [dataTemp]
                        
                        let tripItemView = self.generalFunc.loadView(nibName: "SelectedDayHistoryListItemView")
                        tripItemView.tag = i
                        
                        tripItemView.subviews[0].layer.shadowOpacity = 0.5
                        tripItemView.subviews[0].layer.shadowOffset = CGSize(width: 0, height: 3)
                        tripItemView.subviews[0].layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
//                        (tripItemView.subviews[0].subviews[0] as! MyLabel).text = Configurations.convertNumToAppLocal(numStr: dataTemp.get("TripTime"))
                        
                        (tripItemView.subviews[0].subviews[0] as! MyLabel).text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: dataTemp.get("tTripRequestDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateTimeOnly)
                        
                        
                        (tripItemView.subviews[0].subviews[1] as! MyLabel).text = dataTemp.get("vServiceTitle")
                        
                        if(self.APP_TYPE.uppercased() == "DELIVERY"){
                             tripItemView.subviews[0].subviews[1].isHidden = true
                        }
                        tripItemView.subviews[0].layer.shadowOpacity = 0.5
                        tripItemView.subviews[0].layer.shadowOffset = CGSize(width: 0, height: 3)
                        tripItemView.subviews[0].layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
                        Utils.createRoundedView(view: tripItemView.subviews[0], borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 2)
                        
                        (tripItemView.subviews[0].subviews[2] as! MyLabel).text = "\(currencySymbol)\(Configurations.convertNumToAppLocal(numStr: dataTemp.get("iFare")))"
                        (tripItemView.subviews[0].subviews[2] as! MyLabel).textColor = UIColor.UCAColor.AppThemeColor
                        
                        GeneralFunctions.setImgTintColor(imgView: (tripItemView.subviews[0].subviews[3] as! UIImageView), color: UIColor(hex: 0x323232))
                        self.tripDataContainerStackView.addArrangedSubview(tripItemView)
                        
                        if(Configurations.isRTLMode()){
                            (tripItemView.subviews[0].subviews[3] as! UIImageView).transform = CGAffineTransform(scaleX: -1, y: 1)
                        }
                        
                        let detailTapGue = UITapGestureRecognizer()
                        detailTapGue.addTarget(self, action: #selector(self.openDetail(sender:)))
                        
                        tripItemView.isUserInteractionEnabled = true
                        tripItemView.addGestureRecognizer(detailTapGue)
                    }
                    
                    self.tripDataContainerStackView.distribution  = UIStackView.Distribution.fillEqually
                    self.tripDataContainerStackView.frame.size = CGSize(width: Application.screenSize.width, height: CGFloat(dataArr.count * 80))
                    
                    let dataHeight = CGFloat(dataArr.count * 80)
                    self.PAGE_HEIGHT = self.topHeaderView.frame.height + dataHeight + 80
                    
                    self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
                    
                    self.tripDataContainerStackViewHeight.constant = dataHeight
                    
                    self.scrollView.setContentViewSize(offset: 20)
                    
                }else{
                    
                    self.ratingBar.rating = 0
                    self.completedTripsVLbl.text = "0"
                    self.totalFareVLBl.text = "0"
                    
                    let msgStr = dataDict.get(Utils.message_str)
                    let yOffset1 = Application.screenSize.height / 2
                    let yOffset2 = Application.screenSize.height / 2
                    let yOffset = yOffset1 - yOffset2
                    
                    self.msgLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: msgStr, key: msgStr), xOffset: 0, yOffset: yOffset / 2)
                    
                }
                
                //                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                self.completedTripsVLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("TripCount"))
                
                
                self.totalFareVLBl.text = "\(currencySymbol)\(Configurations.convertNumToAppLocal(numStr: dataDict.get("TotalEarning")))"
                
                self.ratingBar.rating = Float(dataDict.get("AvgRating") == "" ? "0" : dataDict.get("AvgRating"))!
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            self.cntView.isHidden = false
            self.loaderView.isHidden = true
            
        })
    }
    
    @objc func filterDataTapped(){
        if(appTypeFilterArr == nil){
            return
        }
        
        var filterDataTitleList = [String]()
        
        for i in 0..<appTypeFilterArr.count{
            let data_tmp = appTypeFilterArr[i] as! NSDictionary
            filterDataTitleList.append(data_tmp.get("vTitle"))
        }
        
        let openListView = OpenListView(uv: self, containerView: self.view)
        openListView.show(listObjects: filterDataTitleList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TYPE"), currentInst: openListView, handler: { (selectedItemId) in
            self.vFilterParam = (self.appTypeFilterArr[selectedItemId] as! NSDictionary).get("vFilterParam")
            
            self.getData()
        })
    }
    
    @objc func openDetail(sender:UITapGestureRecognizer){
        
        let item = dataArrList[sender.view!.tag]
       
        if item.get("eType") == "Multi-Delivery"
        {
        }else
        {
            let rideDetailUV = GeneralFunctions.instantiateViewController(pageName: "RideDetailUV") as! RideDetailUV
            rideDetailUV.tripDetailDict = self.dataArrList[sender.view!.tag]
            self.pushToNavController(uv: rideDetailUV)
        }
        
    }
}
