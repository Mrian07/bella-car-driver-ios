//
//  CountryListUV.swift
//  Admin
//
//  Created by ADMIN on 09/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class CountryListUV: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    var fromRegister:Bool = false
    var fromVerifyProfile:Bool = false
    var fromEditProfile = false
    var fromAccountInfo = false
    var fromAccountVerification = false
    
     var loader_IV:UIActivityIndicatorView?
    var selectedCountryHolder:countryHolder?
    
    var countryHolder_arr = [countryHolder()]
    
    var myCountryDict: [Int: [countryHolder]] = [Int: [countryHolder]]()
    
    let generalFunc = GeneralFunctions()
    
    var isSafeAreaSet = false
    
    var cntView:UIView!
    var sectionTitleIndexes = NSMutableArray()
    
    var countryListArr:NSArray!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.closeKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "CountryListScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)

        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = true
//        self.tableView.register(CountryListTVCell.self, forCellReuseIdentifier: "CountryListTVCell")
        self.tableView.register(UINib(nibName: "CountryListTVCell", bundle: nil), forCellReuseIdentifier: "CountryListTVCell")
        self.tableView.register(UINib(nibName: "CountryListHeaderTVCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "CountryListHeaderTVCell")
        self.tableView.bounces = false
        
        self.setDefaultNavBar()
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom, right: 0)
        
        loader_IV = self.addActivityIndicator()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        setData()
        
        loadCountry()
        
    }

    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            
            cntView.frame.size.height = cntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
            isSafeAreaSet = true
        }
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CONTRY")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CONTRY")
    }
    
    func setDefaultNavBar(){
        self.addBackBarBtn()
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_search_nav")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.searchTapped))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.titleView = nil
        
        setData()
        
        self.closeKeyboard()
    }

    @objc func searchTapped(){
        if(countryListArr == nil || (countryListArr != nil && countryListArr.count == 0)){
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            let searchBar = UISearchBar()
            searchBar.sizeToFit()
            searchBar.delegate = self
            searchBar.placeholder = self.generalFunc.getLanguageLabel(origValue: "Search Country", key: "LBL_SEARCH_COUNTRY")
            self.navigationItem.titleView = searchBar
            
            let cancelLbl = MyLabel()
            cancelLbl.font = UIFont(name: Fonts().light, size: 17)!
            cancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
            cancelLbl.setClickHandler { (instance) in
                self.setDefaultNavBar()
                self.setAllCountries()
                self.setCountryData()
            }
            cancelLbl.fitText()
            cancelLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelLbl)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:  UIView())
            
            searchBar.becomeFirstResponder()
            
        })
    }
    
    @objc func keyboardWillDisappear(sender: NSNotification){
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom, right: 0)
    }
    
    @objc func keyboardWillAppear(sender: NSNotification){
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardSize, right: 0)
    }
    
    
    func loadCountry(){
//        countryList
        let parameters = ["type":"countryList"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    let countryListArr = dataDict.getArrObj("CountryList")
                    self.countryListArr = countryListArr
                    
                    if(self.countryListArr.count == 0){
                        _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_COUNTRY_AVAIL")))
                        self.loader_IV?.removeFromSuperview()
                        return
                    }
                    
                    self.setAllCountries()
                    
                    self.setCountryData()
                   
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        self.closeCurrentScreen()
                    })
                }
                
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    self.closeCurrentScreen()
                })
            }
        })
    }
    
    func setAllCountries(){
        self.countryHolder_arr.removeAll()
        for i in 0  ..< countryListArr.count {
            let dict = countryListArr[i] as! NSDictionary
            _ = dict.get("key")
            let totCount = dict.get("TotalCount")
            
            let subListArr = dict.getArrObj("List")
            
            for j in 0  ..< subListArr.count {
                let subDict = subListArr[j] as! NSDictionary
                let vCountry = subDict.get("vCountry")
                let vPhoneCode = subDict.get("vPhoneCode")
                _ = subDict.get("iCountryId")
                let vCountryCode = subDict.get("vCountryCode")
                
                let countryHolderObj:countryHolder = countryHolder()
                countryHolderObj.vPhoneCode = vPhoneCode
                countryHolderObj.countryName = vCountry
                countryHolderObj.vCountryCode = vCountryCode
                countryHolderObj.totalItems = totCount
                
                //                            self.countryHolder_arr += [countryHolderObj]
                self.countryHolder_arr.append(countryHolderObj)
            }
        }
    }
    
    func setCountryData(){
        
        self.countryHolder_arr.sort { $0.countryName.lowercased()  < $1.countryName.lowercased() }
        
        var i = 0, j = 0;
        for val in UnicodeScalar("A").value...UnicodeScalar("Z").value
        {
            let x = String(describing: UnicodeScalar(val));
            
            var cList = [countryHolder]() as Array
            
            for i in 0 ..< self.countryHolder_arr.count {
                
                let countryTitle:NSString = self.countryHolder_arr[i].countryName as NSString
                let first = String(describing: UnicodeScalar(countryTitle.character(at: 0)))
                
                if(x.lowercased() == first.lowercased()){
                    cList.append(self.countryHolder_arr[i])
                }
            }
            
            if cList.count != 0
            {
                self.myCountryDict[i] = cList
                i += 1
                self.sectionTitleIndexes.add(j)
            }
            j += 1
            
        }
        
        self.tableView.allowsSelection = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        self.loader_IV?.removeFromSuperview()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return myCountryDict.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myCountryDict[section]!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListTVCell", for: indexPath) as! CountryListTVCell
        
        let country_holderObj = myCountryDict[indexPath.section]![indexPath.row]
        
        cell.countryLabelTxt.text = country_holderObj.countryName
        cell.countryCodeLbl.text = country_holderObj.vPhoneCode
        cell.countryLabelTxt.removeGestureRecognizer(cell.countryLabelTxt.tapGue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedCountryHolder = myCountryDict[indexPath.section]![indexPath.row]
        
        self.setDefaultNavBar()
        
        if(fromRegister == true){
            performSegue(withIdentifier: "unwindToSignUp", sender: self)
        }else if(fromVerifyProfile == true){
            performSegue(withIdentifier: "setCountryToVFbUnWind", sender: self)
        }else if(fromEditProfile == true){
            performSegue(withIdentifier: "unwindToEditProfile", sender: self)
        }else if(fromAccountInfo == true){
            performSegue(withIdentifier: "unwindToAccountInfo", sender: self)
        }else if(fromAccountVerification == true){
            performSegue(withIdentifier: "unwindToAccountVerification", sender: self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Here, we use NSFetchedResultsController
        // And we simply use the section name as title
      
        var indexTitle = ""
        var i = 0;
        for val in UnicodeScalar("A").value...UnicodeScalar("Z").value
        {
            if self.sectionTitleIndexes[section] as! Int == i
            {
                indexTitle = String(describing: UnicodeScalar(val)!)
            }
            i += 1
        }

        
        // Dequeue with the reuse identifier
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "CountryListHeaderTVCell") as! CountryListHeaderTVCell
        cell.titleLbl.text = indexTitle
        //        cell.backgroundColor = UIColor.UCAColor.AppThemeColor
        cell.titleLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        cell.titleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        cell.subTitleLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        cell.subTitleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        cell.subTitleLbl.text = "\(myCountryDict[section]!.count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return String(describing: UnicodeScalar(65 + section)!)
        var indexTitle = ""
        var i = 0;
        for val in UnicodeScalar("A").value...UnicodeScalar("Z").value
        {
             if self.sectionTitleIndexes[section] as! Int == i
            {
                indexTitle = String(describing: UnicodeScalar(val)!)
            }
            i += 1
        }
        
        return indexTitle
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String,
                            at index: Int) -> Int{
        return index
    }
    
    /* section index titles displayed to the right of the `UITableView` */
     func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        var indexTitle = [String()]
        indexTitle.removeAll()
        var i = 0;
        for val in UnicodeScalar("A").value...UnicodeScalar("Z").value
        {
            if self.sectionTitleIndexes.contains(i)
            {
                let x = String(describing: UnicodeScalar(val)!)
                indexTitle.append(x)
            }
            
            i += 1
        }
//        indexTitle
        return []
    }
    
    func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        Utils.printLog(msgData: "EndEditing")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchQuery = searchText.trim()
        self.countryHolder_arr.removeAll()
        self.myCountryDict.removeAll()
        self.sectionTitleIndexes.removeAllObjects()
        
        if(searchQuery == ""){
            self.setAllCountries()
        }else{
            for i in 0..<countryListArr.count{
                let dict = countryListArr[i] as! NSDictionary
                _ = dict.get("key")
                let totCount = dict.get("TotalCount")
                
                let subListArr = dict.getArrObj("List")
                
                for j in 0  ..< subListArr.count {
                    let subDict = subListArr[j] as! NSDictionary
                    let vCountry = subDict.get("vCountry")
                    let vPhoneCode = subDict.get("vPhoneCode")
                    _ = subDict.get("iCountryId")
                    let vCountryCode = subDict.get("vCountryCode")
                    
                    if(vCountry.uppercased().starts(with: searchQuery.uppercased())){
                        let countryHolderObj:countryHolder = countryHolder()
                        countryHolderObj.vPhoneCode = vPhoneCode
                        countryHolderObj.countryName = vCountry
                        countryHolderObj.vCountryCode = vCountryCode
                        countryHolderObj.totalItems = totCount
                        
                        //                            self.countryHolder_arr += [countryHolderObj]
                        self.countryHolder_arr.append(countryHolderObj)
                    }
                    
                }
            }
        }
        
        self.setCountryData()
    }
}

class countryHolder  {
    var countryName: String = String()
    var vPhoneCode: String = String()
    var vCountryCode: String = String()
    var totalItems: String = String()
}
