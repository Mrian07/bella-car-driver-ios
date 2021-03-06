//
//  ManageProfileUV.swift
//  DriverApp
//
//  Created by ADMIN on 13/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class ManageProfileUV: UIViewController, MyLabelClickDelegate {
    
    
    var MENU_VIEW_PROFILE = "0"
    var MENU_CHANGE_PASSWORD = "1"

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    let generalFunc = GeneralFunctions()
    
    var currentViewController:UIViewController!
    
    var currentPageMode = "VIEW_PROFILE"
    
    var isFirstLaunch = true
    
    var menu:BTNavigationDropdownMenu!
    var rightButton: UIBarButtonItem!
    
    var SITE_TYPE_DEMO_MSG = ""
    
    var isOpenEditProfile = false
    var isFromAccountVerifyScreen = false
    
//    var Driver_Password_decrypt = ""
    var vPassword = ""
    
    var userProfileJson:NSDictionary!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.contentView.addSubview(self.generalFunc.loadView(nibName: "ManageProfileScreenDesign", uv: self, contentView: contentView))

        self.addBackBarBtn()
        
        setData()
        
        rightButton = UIBarButtonItem(image: UIImage(named: "ic_menu")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.menuClicked))
        self.navigationItem.rightBarButtonItem = rightButton
        
        openViewProfileUv()
        
//        if(isOpenEditProfile == true){
//            openEditProfileUv()
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if(isOpenEditProfile == true){
            self.openEditProfileUv()
            isOpenEditProfile = false
        }
    }
    
    override func closeCurrentScreen(){
        
        if(menu != nil){
            menu.hideMenu()
        }
        
        if(self.currentPageMode != "VIEW_PROFILE"){
            self.openViewProfileUv()
            return
        }
        if (self.navigationController?.viewControllers.count == 1) {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func menuClicked(){
        openPopUpMenu()
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_TITLE_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_TITLE_TXT")
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        vPassword = userProfileJson.get("vPassword")
        SITE_TYPE_DEMO_MSG = userProfileJson.get("SITE_TYPE_DEMO_MSG")
    }
    
    func openViewProfileUv(){
        currentPageMode = "VIEW_PROFILE"
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_TITLE_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_TITLE_TXT")
        
        let viewProfileUV = GeneralFunctions.instantiateViewController(pageName: "ViewProfileUV") as! ViewProfileUV
        viewProfileUV.containerViewHeight = self.containerView.frame.height
        viewProfileUV.view.frame = self.containerView.frame
        
        if(isFirstLaunch == true){
            self.addChild(viewProfileUV)
            self.addSubview(subView: viewProfileUV.view, toView: self.containerView)
            
            isFirstLaunch = false
        }else{
//            viewProfileUV.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: viewProfileUV)
        }
        
        currentViewController = viewProfileUV
        
       
    }
    
    func openEditProfileUv(){
        currentPageMode = "EDIT_PROFILE"
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_PROFILE_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_PROFILE_TXT")
        
        let editProfileUV = GeneralFunctions.instantiateViewController(pageName: "EditProfileUV") as! EditProfileUV
        editProfileUV.containerViewHeight = self.containerView.frame.height
        editProfileUV.view.frame = self.containerView.frame
        editProfileUV.manageProfileUv = self
        
//        editProfileUV.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: editProfileUV)
        
        currentViewController = editProfileUV
    }

    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        
//        oldViewController.willMove(toParentViewController: nil)
//        oldViewController.view.removeFromSuperview()
//        oldViewController.removeFromParentViewController()
//        
//        self.addChildViewController(newViewController)
//        self.addSubview(subView: newViewController.view, toView: self.containerView)
//        newViewController.didMove(toParentViewController: self)
        
        oldViewController.willMove(toParent: nil)
        self.addChild(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.containerView)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParent()
                                    newViewController.didMove(toParent: self)
        })
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        
        subView.frame = parentView.frame
        subView.center = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        
        parentView.addSubview(subView)
    }
    
    
    func initializeMenu(){
        
        var items = [NSDictionary]()
        
        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: self.currentPageMode == "VIEW_PROFILE" ? "LBL_EDIT_PROFILE_TXT" : "LBL_VIEW_PROFILE_TXT"),"ID" : MENU_VIEW_PROFILE] as NSDictionary)

        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE_PASSWORD_TXT"),"ID" : MENU_CHANGE_PASSWORD] as NSDictionary)
        
        if(self.menu == nil){
            menu = BTNavigationDropdownMenu(navigationController: self.navigationController, title: "", items: items)

            menu.cellHeight = 65
            menu.cellBackgroundColor = UIColor.UCAColor.AppThemeColor.lighter(by: 10)
            menu.cellSelectionColor = UIColor.UCAColor.AppThemeColor
            menu.cellTextLabelColor = UIColor.UCAColor.AppThemeTxtColor
            menu.cellTextLabelFont = UIFont(name: Fonts().light, size: 20)
            menu.cellSeparatorColor = UIColor.UCAColor.AppThemeColor
            
            if(Configurations.isRTLMode()){
                menu.cellTextLabelAlignment = NSTextAlignment.right
            }else{
                menu.cellTextLabelAlignment = NSTextAlignment.left
            }
            menu.arrowPadding = 15
            menu.animationDuration = 0.5
            menu.maskBackgroundColor = UIColor.black
            menu.maskBackgroundOpacity = 0.5
            menu.menuStateHandler = { (isMenuOpen: Bool) -> () in
                
//                if(isMenuOpen){
//                    self.rightButton.setBackgroundImage(nil, for: .normal, barMetrics: .default)
//
//                }else{
//                    self.rightButton.setBackgroundImage(UIImage(color : UIColor.UCAColor.AppThemeColor.lighter(by: 10)!), for: .normal, barMetrics: .default)
//                }
            
            }
            menu.didSelectItemAtIndexHandler = {(indexID: String) -> () in
                
                if(indexID == self.MENU_VIEW_PROFILE){
                    if(self.currentPageMode == "VIEW_PROFILE"){
                        
                        if(self.userProfileJson.get("ONLYDELIVERALL") == "Yes" || self.userProfileJson.get("DELIVERALL") == "Yes")
                        {
                            if (UserDefaults.standard.object(forKey: "IS_LIVE_TASK_AVAILABLE") != nil && GeneralFunctions.getValue(key: "IS_LIVE_TASK_AVAILABLE") as! String == "true")
                            {
                                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_PROFILE_BLOCK"))
                                return
                            }
                            //else if let IS_DRIVER_ONLINE = GeneralFunctions.getValue(key: "IS_DRIVER_ONLINE") as? String{
                               // if(IS_DRIVER_ONLINE == "true"){
                                 //   self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_PROFILE_BLOCK_DRIVER"))
                               // }else{
                               //    self.openEditProfileUv()
                               // }
                            //}else{
                                self.openEditProfileUv()
                           // }
                            
                        }else
                        {
                            //if let IS_DRIVER_ONLINE = GeneralFunctions.getValue(key: "IS_DRIVER_ONLINE") as? String{
                               // if(IS_DRIVER_ONLINE == "true"){
                                 //   self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_PROFILE_BLOCK_DRIVER"))
                               // }else{
                                 //   self.openEditProfileUv()
                               // }
                            //}else{
                                self.openEditProfileUv()
                           // }
                        }
                     
                    }else{
                        self.openViewProfileUv()
                    }
                }else if(indexID == self.MENU_CHANGE_PASSWORD){
                    self.openChangePassword()
                }
            }
        }else{
            menu.updateItems(items)
        }
    }
    
    func openPopUpMenu(){
        
        initializeMenu()
        
        if(menu.isShown){
            menu.hideMenu()
            return
        }else{
            menu.showMenu()
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        
        
    }
    
    func openChangePassword(){
//        ChangePasswordView
        
        let openChangePassword = OpenChangePassword(uv: self, containerView: self.contentView, vPassword: self.vPassword, userProfileJson: self.userProfileJson, SITE_TYPE_DEMO_MSG: self.SITE_TYPE_DEMO_MSG)
        openChangePassword.show()
        openChangePassword.setViewHandler { (isPasswordCange) in
            if(isPasswordCange == true){
                self.setData()
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INFO_UPDATED_TXT"), uv: self)
            }
        }
    }
}
