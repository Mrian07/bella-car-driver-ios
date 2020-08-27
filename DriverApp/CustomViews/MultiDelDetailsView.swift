//
//  MultiDelDetailsView.swift
//  DriverApp
//
//  Created by Admin on 6/9/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class MultiDelDetailsView: UIView {

    
    @IBOutlet weak var hLbl: MyLabel!
   
    @IBOutlet weak var valLbl: MyLabel!
    
    var view: UIView!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: coder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIStackView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MultiDelDetailsView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIStackView
        
        return view
    }

}
