//
//  HomeScreenContainerUV.swift
//  DriverApp
//
//  Created by ADMIN on 27/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class HomeScreenContainerUV: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var mainScreenUV:MainScreenUV!
    var driverStatesUV:DriverStatesUV!
    var accountSuspendUV:AccountSuspendUV!
    
    var isPageLoad = false
    
    let panRec = UIPanGestureRecognizer()
    let panRec_view = UIPanGestureRecognizer()
    
    override func viewWillAppear(_ animated: Bool) {
        if(Configurations.isRTLMode()){
           self.navigationDrawerController?.isRightPanGestureEnabled = true
        }else{
            self.navigationDrawerController?.isLeftPanGestureEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(Configurations.isRTLMode()){
            self.navigationDrawerController?.isRightPanGestureEnabled = false
        }else{
            self.navigationDrawerController?.isLeftPanGestureEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GeneralFunctions.saveValue(key: "IS_LIVE_TASK_AVAILABLE", value: "false" as AnyObject)
        GeneralFunctions.saveValue(key: "IS_DRIVER_ONLINE", value: "false" as AnyObject)
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        let navHeight = self.navigationController!.navigationBar.frame.height
        let width = ((navHeight * 350) / 119)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: ((width * 119) / 350)))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "ic_your_logo")
        imageView.image = image
        
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_all")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openMenu))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightButton
        
        let eStatus = userProfileJson.get("eStatus")

        if(eStatus == "inactive"){
            self.navigationItem.titleView = imageView
            
            driverStatesUV = (GeneralFunctions.instantiateViewController(pageName: "DriverStatesUV") as! DriverStatesUV)
            driverStatesUV.view.frame = self.containerView.frame
            self.addChild(driverStatesUV)
            self.addSubview(subView: driverStatesUV.view, toView: self.containerView)
            
        }else if(eStatus == "Suspend"){
            self.navigationItem.titleView = imageView
            
            accountSuspendUV = (GeneralFunctions.instantiateViewController(pageName: "AccountSuspendUV") as! AccountSuspendUV)
            accountSuspendUV.view.frame = self.containerView.frame
            self.addChild(accountSuspendUV)
            self.addSubview(subView: accountSuspendUV.view, toView: self.containerView)
            
            let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
            self.navigationItem.leftBarButtonItem = leftButton
            
            
            let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nav_logout")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.logOutTapped))
            self.navigationItem.rightBarButtonItem = rightButton
            
            panRec.addTarget(self, action: #selector(self.panguster(sender:)))
            panRec_view.addTarget(self, action: #selector(self.panguster(sender:)))
            
            
            self.navigationController?.navigationBar.addGestureRecognizer(panRec)
            self.view.addGestureRecognizer(panRec_view)
            
        }else{
            
            mainScreenUV = (GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV)
            if(userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX){
                self.navigationItem.titleView = imageView
            }else{
                
                let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nav_refresh")!, style: UIBarButtonItem.Style.plain, target: mainScreenUV, action: #selector(mainScreenUV.onRefreshCalled))
                self.navigationItem.rightBarButtonItem = rightButton
            }
            
            mainScreenUV.view.frame = self.containerView.frame
            mainScreenUV.navItem = self.navigationItem
            self.addChild(mainScreenUV)
            self.addSubview(subView: mainScreenUV.view, toView: self.containerView)
        }
        
        /* Load AdvertisementView */
        let advDataDic = userProfileJson.get("advertise_banner_data")
        let dataDict = advDataDic.getJsonDataDict()
        if (userProfileJson.get("ENABLE_RIDER_ADVERTISEMENT_BANNER").uppercased() == "YES" && dataDict.get("image_url") != ""){
            
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            let advDataDic = userProfileJson.get("advertise_banner_data")
            let dataDict = advDataDic.getJsonDataDict()
            var width:CGFloat = 0.0
            let wi = GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("vImageWidth"))
            width = CGFloat.init(wi) / UIScreen.main.scale
            
            var height:CGFloat = 0.0
            let hi = GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("vImageHeight"))
            height = CGFloat.init(hi) / UIScreen.main.scale
            
            if(width < 100){
                width = 100.0
            }
            
            if (height < 100){
                height = 100
            }
            let bgView = UIView()
            bgView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: Application.screenSize.height)
            bgView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            Application.keyWindow!.addSubview(bgView)
            Application.keyWindow!.addSubview(AdvertisementView.init(withImgUrlString: dataDict.get("image_url"), withRedirectUrlString: dataDict.get("tRedirectUrl"), vImageWidth: width, vImageHeight: height, bgView: bgView))
        }
        /* Load AdvertisementView */
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
    }
    
    @objc func releaseAllTask(){
        
        if(driverStatesUV != nil){
            driverStatesUV.releaseAllTask()
            driverStatesUV.view.removeFromSuperview()
            driverStatesUV.removeFromParent()
            driverStatesUV.dismiss(animated: true, completion: nil)
            
            driverStatesUV = nil
            
            GeneralFunctions.removeObserver(obj: self)
            
            self.navigationDrawerController?.dismiss(animated: true, completion: nil)
        }
        
        if(mainScreenUV == nil){
            return
        }
        mainScreenUV.gMapView?.clear()
        mainScreenUV.gMapView?.removeFromSuperview()
        mainScreenUV.gMapView = nil
        
        mainScreenUV.releaseAllTask()
        mainScreenUV.view.removeFromSuperview()
        mainScreenUV.removeFromParent()
        mainScreenUV.dismiss(animated: true, completion: nil)
        
        mainScreenUV = nil
        
        GeneralFunctions.removeObserver(obj: self)
        
        self.navigationDrawerController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func openMenu(){
        if(Configurations.isRTLMode()){
            //            self.navigationDrawerController?.setRightViewOpened(isRightViewOpened: false)
            self.navigationDrawerController?.toggleRightView()
            
            //            self.navigationDrawerController?.setRightViewOpened(isRightViewOpened: true)
        }else{
            self.navigationDrawerController?.toggleLeftView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoad == false){
            mainScreenUV?.view.frame = self.containerView.frame
            driverStatesUV?.view.frame = self.containerView.frame
            
            isPageLoad = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        
        subView.frame = parentView.frame
        subView.center = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        
        parentView.addSubview(subView)
    }
    
    @objc func logOutTapped(){
        let window = Application.window
        GeneralFunctions.logOutUser()
        GeneralFunctions.restartApp(window: window!)
    }
    
    @objc func panguster(sender: UIPanGestureRecognizer) {
        
    }
}
