//
//  SinchCallingUV.swift
//  PassengerApp
//
//  Created by Admin on 10/13/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class SinchCallingUV: UIViewController, MyLabelClickDelegate, SinchCallingProtocol {
    
    

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var speakerImgview: UIImageView!
    @IBOutlet weak var muteImgView: UIImageView!
    
    @IBOutlet weak var profileName: MyLabel!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var endcallLbl: MyLabel!
    @IBOutlet weak var answerLbl: MyLabel!
    @IBOutlet weak var bottomSatckView: UIStackView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var topcallingLbl: MyLabel!
    
    var mueTapped = false
    var speakerTapped = false
    
    var cntView:UIView!
    
    var isCallReceiving = false
    
    let generalFunc = GeneralFunctions()
    var assignedData:NSDictionary!
    
    var callingCount = 0
    weak var callingTimer:Timer?
    weak var timer: Timer?
    
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cntView = self.generalFunc.loadView(nibName: "SinchCallingScreenDesign", uv: self, contentView: containerView)
        self.containerView.addSubview(cntView)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if isCallReceiving == false{
            answerLbl.isHidden = true
        }
        
        SinchCalling.getInstance().delegate = self
        
        self.profileName.text = assignedData.get("Name")
        if(assignedData.get("type") == "Company"){
            self.profileImgView.sd_setImage(with: URL(string: "\(CommonUtils.restauarant_image_url)\(assignedData!.get("Id"))/\(assignedData!.get("PImage"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        }else{
            self.profileImgView.sd_setImage(with: URL(string: "\(CommonUtils.passenger_image_url)\(assignedData!.get("Id"))/\(assignedData!.get("PImage"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        }
        
        
        self.backBtn.isHidden = true
        self.backBtn.image = backBtn.image?.addImagePadding(x: 20, y: 20)
        let backTappGes = UITapGestureRecognizer()
        backTappGes.addTarget(self, action: #selector(self.backTapped))
        backBtn.isUserInteractionEnabled = true
        self.backBtn.addGestureRecognizer(backTappGes)
        
        let muteTappGes = UITapGestureRecognizer()
        muteTappGes.addTarget(self, action: #selector(self.muteTapped))
        muteImgView.isUserInteractionEnabled = true
        self.muteImgView.addGestureRecognizer(muteTappGes)
        
        let speakerTappGes = UITapGestureRecognizer()
        speakerTappGes.addTarget(self, action: #selector(self.speaTapped))
        speakerImgview.isUserInteractionEnabled = true
        self.speakerImgview.addGestureRecognizer(speakerTappGes)
        
        self.endcallLbl.setClickDelegate(clickDelegate: self)
        self.answerLbl.setClickDelegate(clickDelegate: self)

        self.endcallLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_CALL")
        self.answerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ANSWER")
        
        self.muteImgView.image = self.muteImgView.image?.addImagePadding(x: 30, y: 30)
        self.speakerImgview.image = self.speakerImgview.image?.addImagePadding(x: 30, y: 30)
      
        callingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.callingAnimation), userInfo: nil, repeats: true)
        
        if isCallReceiving == true{
            self.muteImgView.isHidden = true
            self.speakerImgview.isHidden = true
        }
    }
    
    @objc func callingAnimation(){
        callingCount = callingCount + 1
        if callingCount == 1{
            self.topcallingLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALLING") + "."
        }else if callingCount == 2{
            self.topcallingLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALLING") + ".."
        }else if callingCount == 3{
            self.topcallingLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALLING") + "..."
        }else{
            callingCount = 0
            self.topcallingLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALLING")
        }
        
    }
    
    @objc func backTapped(){
        
        callingTimer?.invalidate()
        callingTimer = nil
        timer?.invalidate()
        timer = nil
        if UserDefaults.standard.object(forKey: "SINCHCALLING") != nil && GeneralFunctions.getValue(key: "SINCHCALLING") as! Bool == true{
            GeneralFunctions.saveValue(key: "SINCHCALLING", value: false as AnyObject)
            let window = Application.window
            GeneralFunctions.restartApp(window: window!)
            return
        }
        self.closeCurrentScreen()
    }

    @objc func muteTapped(){
        if  mueTapped == true{
            self.muteImgView.backgroundColor = UIColor.clear
            GeneralFunctions.setImgTintColor(imgView: self.muteImgView, color: UIColor.white)
            SinchCalling.getInstance().sinAudioController.unmute()
            mueTapped = false
        }else{
            self.muteImgView.backgroundColor = UIColor.white
            GeneralFunctions.setImgTintColor(imgView: self.muteImgView, color: UIColor.black)
            SinchCalling.getInstance().sinAudioController.mute()
            mueTapped = true
        }
        
    }
    
    @objc func speaTapped(){
        
        if  speakerTapped == true{
            self.speakerImgview.backgroundColor = UIColor.clear
            GeneralFunctions.setImgTintColor(imgView: self.speakerImgview, color: UIColor.white)
            SinchCalling.getInstance().sinAudioController.disableSpeaker()
            speakerTapped = false
        }else{
            SinchCalling.getInstance().sinAudioController.enableSpeaker()
            self.speakerImgview.backgroundColor = UIColor.white
            GeneralFunctions.setImgTintColor(imgView: self.speakerImgview, color: UIColor.black)
            speakerTapped = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func myLableTapped(sender: MyLabel) {
        if answerLbl == sender{
            if SinchCalling.getInstance().callFromSynch != nil{
                SinchCalling.getInstance().client.audioController().stopPlayingSoundFile()
                SinchCalling.getInstance().callFromSynch.answer()
            }
            callingTimer?.invalidate()
            callingTimer = nil
            startTime = Date().timeIntervalSinceReferenceDate - elapsed
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            self.muteImgView.alpha = 0
            self.speakerImgview.alpha = 0
            self.muteImgView.isHidden = false
            self.speakerImgview.isHidden = false
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.muteImgView.alpha = 1
                            self.speakerImgview.alpha = 1
                            self.answerLbl.transform = .init(scaleX: 0.97, y: 0.97)
            },  completion: { finished in
                self.answerLbl.transform = .identity
                self.answerLbl.isHidden = true
                
            })
            
        }else if endcallLbl == sender{
            if SinchCalling.getInstance().callFromSynch != nil{
                SinchCalling.getInstance().callFromSynch.hangup()
                SinchCalling.getInstance().callFromSynch = nil
            }
            
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.endcallLbl.transform = .init(scaleX: 0.97, y: 0.97)
            },  completion: { finished in
                self.endcallLbl.transform = .identity
                self.backTapped()
            })
            
        }
    }
    
    func callDidEnd() {
        callingTimer?.invalidate()
        callingTimer = nil
        timer?.invalidate()
        timer = nil
        self.topcallingLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_ENDED")
        self.perform(#selector(self.backTapped), with: self, afterDelay: 2)
    }
    
    func callDidEstablish(){
        
        if timer == nil{
            callingTimer?.invalidate()
            callingTimer = nil
            startTime = Date().timeIntervalSinceReferenceDate - elapsed
            self.updateCounter()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
        
        if mueTapped == true{
            SinchCalling.getInstance().sinAudioController.mute()
        }else{
            SinchCalling.getInstance().sinAudioController.unmute()
        }
        
        if speakerTapped == true{
            SinchCalling.getInstance().sinAudioController.enableSpeaker()
        }else{
            SinchCalling.getInstance().sinAudioController.disableSpeaker()
        }
    }
    
    @objc func updateCounter() {
        
        if timer == nil{
            return
        }
        
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        let hours = Int(time / 3600)
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        
        // Format time vars with leading zero
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        UIView.transition(with: self.topcallingLbl,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.topcallingLbl.text = "\(strHours):\(strMinutes):\(strSeconds)"
                            self?.topcallingLbl.text = Configurations.convertNumToAppLocal(numStr: (self?.topcallingLbl.text!)!)
            }, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func clientDidStart() {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
