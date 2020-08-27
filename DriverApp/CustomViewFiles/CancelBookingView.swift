//
//  CancelBookingView.swift
//  PassengerApp
//
//  Created by ADMIN on 06/06/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class CancelBookingView: UIView, MyLabelClickDelegate {

    typealias OptionClickHandler = (_ view:UIView) -> Void
    typealias CompletionHandler = (_ isViewRemoved:Bool, _ view:UIView, _ isPositiveBtnClicked:Bool, _ reason:String) -> Void
    
    @IBOutlet weak var cancelBookingHLbl: MyLabel!
    @IBOutlet weak var enterReason: MyTextField!
    @IBOutlet weak var positiveLbl: MyLabel!
    @IBOutlet weak var negativeLbl: MyLabel!
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet weak var optionLbl: MyLabel!
    @IBOutlet weak var optionView: UIView!
    
    var view: UIView!
    var handler:CompletionHandler!
    
    var optionClickHandler:OptionClickHandler!
    
    let generalFunc = GeneralFunctions()
    
    var bookingType = ""
    var PAGE_TYPE = ""
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func setViewHandler(handler: @escaping CompletionHandler){
        self.handler = handler
    }
    
    func setOptionClickHandler(optionClickHandler: @escaping OptionClickHandler){
        self.optionClickHandler = optionClickHandler
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        //        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        self.enterReason.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_REASON"))
        self.positiveLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES")
        self.negativeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO")
        
        self.positiveLbl.setClickDelegate(clickDelegate: self)
        self.negativeLbl.setClickDelegate(clickDelegate: self)
        
        optionView.isUserInteractionEnabled = true
        let optionTapGue = UITapGestureRecognizer()
        optionTapGue.addTarget(self, action: #selector(self.optionViewTapped))
        optionView.addGestureRecognizer(optionTapGue)
        
         self.cancelBookingHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: bookingType == Utils.cabGeneralType_Deliver ? "LBL_CANCEL_DELIVERY" : (bookingType == Utils.cabGeneralType_UberX ?  ( self.PAGE_TYPE == "PENDING" ? "LBL_DECLINE_JOB" : "LBL_CANCEL_JOB") : "LBL_CANCEL_TRIP"))
    }
    
    @objc func optionViewTapped(){
        if(optionClickHandler != nil){
            optionClickHandler(self.optionView)
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        
        if(sender == positiveLbl){
            
            let reasonEntered = Utils.checkText(textField: self.enterReason.getTextField()!) ? true : Utils.setErrorFields(textField: self.enterReason.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD_ERROR_TXT"))
            
            if(handler != nil && ((reasonEntered == false && self.tag != -1) || (reasonEntered == true && self.tag == -1))){
                self.handler(true, view, true, self.tag == -1 ? Utils.getText(textField: self.enterReason.getTextField()!) : "")
            }else{
                return
            }
            
        }else if(sender == negativeLbl){
            if(handler != nil){
                self.handler(true, view, false, Utils.getText(textField: self.enterReason.getTextField()!))
            }
        }
        
        self.view.frame = CGRect(x:0,y:0, width:0,height:0)
        self.view.isHidden = true
        self.view.removeFromSuperview()
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CancelBookingView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
}

