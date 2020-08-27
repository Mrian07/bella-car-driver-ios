//
//  AppTypeSelectionUV.swift
//  DriverApp
//
//  Created by Admin on 3/12/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class AppTypeSelectionUV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    
    var cntView:UIView!
    
    var generalFunc = GeneralFunctions()
    
    @IBOutlet weak var rideView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var servicesView: UIView!
    @IBOutlet weak var rideImgView: UIImageView!
    @IBOutlet weak var rideLbl: MyLabel!
    @IBOutlet weak var deliveryImgView: UIImageView!
    @IBOutlet weak var deliveryLbl: MyLabel!
    @IBOutlet weak var servicesImgView: UIImageView!
    @IBOutlet weak var servicesLbl: MyLabel!
    
    var screenToNavigate = ""
    var isFromDriverStatesUV = false
    var userProfileJson:NSDictionary!
    var isFromMainUV = false
    var isViewLoad = false
    
    var totalAddedVehicles = -1
    
    @IBOutlet weak var tableView: UITableView!
//    var dataArrList = [String]()
    var dataArrList = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackBarBtn()
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TYPE")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
      
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.userProfileJson = userProfileJson
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isViewLoad == false{
            cntView = self.generalFunc.loadView(nibName: "AppTypeSelctionScreenDesign", uv: self, contentView: contentView)
            cntView.frame = self.view.bounds
            self.contentView.addSubview(cntView)
            
            self.tableView.register(HelpCategoryListTVCell.self, forCellReuseIdentifier: "HelpCategoryListTVCell")
            self.tableView.register(UINib(nibName: "HelpCategoryListTVCell", bundle: nil), forCellReuseIdentifier: "HelpCategoryListTVCell")
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.bounces = false
            self.tableView.tableFooterView = UIView()
            
            setData()

            self.tableView.reloadData()
            self.isViewLoad = true
        }
        
        if(GeneralFunctions.getValue(key: "IS_VEHICLE_ADDED") != nil && (GeneralFunctions.getValue(key: "IS_VEHICLE_ADDED") as! String).uppercased() == "YES"){
            totalAddedVehicles = 1
            screenToNavigate = "MANAGE_VEHICLE"
            setData()
        }
        
        GeneralFunctions.removeValue(key: "IS_VEHICLE_ADDED")
        
    }
    
    func setData(){
        self.dataArrList.removeAll()
        
        let dict = NSMutableDictionary()
        dict["Title"] = self.totalAddedVehicles != -1 ? (self.totalAddedVehicles > 0 ? "LBL_MANAGE_VEHICLES" : "LBL_ADD_VEHICLES_ALL") : "LBL_MANAGE_VEHICLES"
        dict["Type"] = "VEHICLES_ALL"
        self.dataArrList.append(dict)
        
        
        if (isFromMainUV == false && (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX)){
            let dict = NSMutableDictionary()
            dict["Title"] = "LBL_MANANGE_OTHER_SERVICES"
            dict["Type"] = "UBERX"
            self.dataArrList.append(dict)
        }
        
        
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCategoryListTVCell", for: indexPath) as! HelpCategoryListTVCell
        
        let item = self.dataArrList[indexPath.item]
        
        cell.categoryNameLbl.font = UIFont.systemFont(ofSize: 16)
        cell.categoryNameLbl.sizeToFit()
        cell.categoryNameLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: item.get("Title"))
        cell.categoryNameLbl.removeGestureRecognizer(cell.categoryNameLbl.tapGue)
        
        GeneralFunctions.setImgTintColor(imgView: cell.rightImgView, color: UIColor(hex: 0x9f9f9f))
        
        if(Configurations.isRTLMode()){
            cell.rightImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.dataArrList[indexPath.item]
        
        if(item.get("Type") == "UBERX"){
            
        }else{
            if (screenToNavigate == "ADD_VEHICLE") {
                let addVehiclesUv = GeneralFunctions.instantiateViewController(pageName: "AddVehiclesUV") as! AddVehiclesUV
                addVehiclesUv.isFromDriverStatesUV = self.isFromDriverStatesUV
                self.pushToNavController(uv: addVehiclesUv)
            }else if (screenToNavigate == "MANAGE_VEHICLE") {
                let manageVehiclesUv = GeneralFunctions.instantiateViewController(pageName: "ManageVehiclesUV") as! ManageVehiclesUV
                self.pushToNavController(uv: manageVehiclesUv)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 72
    }
    
    @IBAction func unwindToAppTypeSelection(_ segue:UIStoryboardSegue) {
        
    }

}
