//
//  Advertisement.swift
//  PassengerApp
//
//  Created by Apple on 26/12/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class AdvertisementView: UIView {

    @IBOutlet weak var imgView: FLAnimatedImageView!
    @IBOutlet weak var imgCancelView: UIControl!
    @IBOutlet weak var cancelImg: UIImageView!
    
    var setImageURL = ""
    var redirectURL = ""
    var view: UIView!
    
    var BGView:UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(withImgUrlString:String, withRedirectUrlString:String, vImageWidth:CGFloat, vImageHeight:CGFloat, bgView:UIView){
       
        self.BGView = bgView
        super.init(frame: CGRect(x: (Application.screenSize.width / 2) - (vImageWidth / 2), y: (Application.screenSize.height / 2) - (vImageHeight / 2) + (GeneralFunctions.getSafeAreaInsets().top / UIScreen.main.scale) , width: vImageWidth, height: vImageHeight))
        xibSetup(withImgUrlString: withImgUrlString, withRedirectUrlString: withRedirectUrlString)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func xibSetup(withImgUrlString:String, withRedirectUrlString:String) {
        
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        
        
        view.frame = bounds
       
        // Make the view stretch with containing view
        //        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 20
        clipsToBounds = false
        
        
        GeneralFunctions.setImgTintColor(imgView: self.cancelImg, color: UIColor.white)
        self.imgCancelView.backgroundColor = UIColor.black
        
        let cancelTapGue = UITapGestureRecognizer()
        cancelTapGue.addTarget(self, action: #selector(self.cancelViewTapped))
        imgCancelView.addGestureRecognizer(cancelTapGue)
        
        let advTapGue = UITapGestureRecognizer()
        advTapGue.addTarget(self, action: #selector(self.advTapped))
        self.imgView.addGestureRecognizer(advTapGue)
        

        setImageURL = withImgUrlString
        redirectURL = withRedirectUrlString
        
        self.imgView.sd_setShowActivityIndicatorView(true)
        self.imgView.sd_setIndicatorStyle(.gray)
        self.imgView.sd_setImage(with: URL(string: setImageURL), placeholderImage: nil) { (image: UIImage?, error: Error?, cacheType:SDImageCacheType!, imageURL: URL?) in}
      
    }
    
    @objc func advTapped(){
        
        guard let url = URL(string: redirectURL) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url)
        }
        
    }
    
    @objc func cancelViewTapped(){
        
        
        self.view.frame = CGRect(x:0,y:0, width:0,height:0)
        self.view.isHidden = true
        self.BGView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AdvertisementView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    

}
