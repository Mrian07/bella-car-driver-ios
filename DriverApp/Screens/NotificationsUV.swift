//
//  NotificationsUV.swift
//  PassengerApp
//
//  Created by Apple on 27/12/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class NotificationsUV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let generalFunc = GeneralFunctions()
    var userProfileJson:NSDictionary!
    var loaderView:UIView!
    var dataArrList = [NSDictionary]()
    var nextPage_str = 1
    var isLoadingMore:Bool = false
    var isNextPageAvail:Bool = false
    var currentWebTask:ExeServerUrl!
    var msgLbl:MyLabel!
    
    var type = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        self.addBackBarBtn()
        
        self.nextPage_str = 1
        self.isLoadingMore = false
        self.isNextPageAvail = false
        self.dataArrList.removeAll()
        self.tableView.reloadData()
        self.getDtata(isLoadingMore: self.isLoadingMore)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.addSubview(self.generalFunc.loadView(nibName: "NotificationsScreenDesign", uv: self, contentView: containerView))
        // Do any additional setup after loading the view.
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "NotificationTVCell", bundle: nil), forCellReuseIdentifier: "NotificationTVCell")
    }
    

    func getDtata(isLoadingMore:Bool){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }else if(loaderView != nil && isLoadingMore == false){
            loaderView.isHidden = false
        }
        
        if(currentWebTask != nil){
            currentWebTask.cancel()
        }
        
        let parameters = ["type":"getNewsNotification", "UserType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "page": self.nextPage_str.description, "eType": type]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        currentWebTask = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    

                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        self.dataArrList.append(dataTemp)
                       
                    }
                    let NextPage = dataDict.get("NextPage")
                    
                    if(NextPage != "" && NextPage != "0"){
                        self.isNextPageAvail = true
                        self.nextPage_str = Int(NextPage)!
                        
                        self.addFooterView()
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    
                    self.tableView.reloadData()
                    
                    
                    
                }else{
                    if(isLoadingMore == false){
                        if(self.msgLbl != nil){
                            self.msgLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message"))
                            self.msgLbl.isHidden = false
                        }else{
                            self.msgLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                        }
                        
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    
                }
            }else{
                if(isLoadingMore == false){
                    self.generalFunc.setError(uv: self)
                }
            }
            
            self.isLoadingMore = false
            self.loaderView.isHidden = true
        })
    }
    
    // TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
        
        let itemDic = self.dataArrList[indexPath.row]
        cell.titleLbl.text = itemDic.get("vTitle")
        cell.subTitleLbl.text = itemDic.get("tDescription")
        
        if (itemDic.get("vTitle") == ""){
            cell.titleViewHeight.constant = 0
        }else{
            cell.titleViewHeight.constant = 21
        }
        
        cell.selectionStyle = .none
        
        cell.dateLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: itemDic.get("dDateTime"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateInList)
        cell.readMoreLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_READ_MORE")
        
        cell.dateLbl.textColor = UIColor(hex: 0x498eb2)
        cell.readMoreLbl.textColor = UIColor(hex: 0x498eb2)
        
        if (Configurations.isRTLMode() == true){
            cell.dateLbl.textAlignment = .right
            cell.readMoreLbl.textAlignment = .left
        }else{
            cell.dateLbl.textAlignment = .left
            cell.readMoreLbl.textAlignment = .right
            
        }
        
        cell.readMoreLbl.tag = indexPath.row
        cell.readMoreLbl.setClickHandler { (instance) in
            
            let notiDetailUv = GeneralFunctions.instantiateViewController(pageName: "NotificationDetailUV") as! NotificationDetailUV
            notiDetailUv.dataDic = self.dataArrList[instance.tag]
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(notiDetailUv, animated: true)
           
        }

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 15) {
            if(isNextPageAvail==true && isLoadingMore==false){
                
                isLoadingMore=true
                
                getDtata(isLoadingMore: isLoadingMore)
            }
        }
    }
    
    func addFooterView(){
        let loaderView =  self.generalFunc.addMDloader(contentView: self.tableView, isAddToParent: false)
        loaderView.backgroundColor = UIColor.clear
        loaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 80)
        self.tableView.tableFooterView  = loaderView
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func removeFooterView(){
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
