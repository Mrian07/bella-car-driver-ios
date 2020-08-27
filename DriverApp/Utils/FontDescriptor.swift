//
//  Constants.swift

//
//  Copyright © 2017 V3Cube. All rights reserved.
//

//******************* SET DEFAULT FONT FAMILY ************************//

import Foundation

// *  This will overide All System Fonts including Storboard, ScreenDesign, CellDesign, CustomViewDesign etc.
// *  IF you want to change font family for particular object, than you need to set it by programtically.
// *  You can change font weight like Medium OR Semibold, Bold, Regular, Light from Attribute Inspector & Name of the Attribute is           "FontFamilyWeight".

struct Fonts {
    
    var light:String = ""
    var regular:String = ""
    var semibold:String = ""
    var bold:String = ""
    
    init() {
        if(UserDefaults.standard.object(forKey: "FONTFAMILY") != nil){
            self.light = (GeneralFunctions.getValue(key: "FONTFAMILY") as! NSArray)[0] as! String
            self.regular = (GeneralFunctions.getValue(key: "FONTFAMILY") as! NSArray)[1] as! String
            self.semibold = (GeneralFunctions.getValue(key: "FONTFAMILY") as! NSArray)[2] as! String
            self.bold = (GeneralFunctions.getValue(key: "FONTFAMILY") as! NSArray)[3] as! String
        }
    }
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .bold, .heavy, .black:
            return UIFont(name: Fonts().light, size: ofSize)! //. .Fonts.Weight.bold, size: ofSize)!
            
        case .medium:
            return UIFont(name: Fonts().semibold, size: ofSize)!
        case .regular:
            return UIFont(name: Fonts().regular, size: ofSize)!
            
        default:
            return UIFont(name: Fonts().light, size: ofSize)!
        }
    }
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Fonts().light, size: size)!
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Fonts().semibold, size: size)!
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Fonts().bold, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = Fonts().regular
        case "CTFontEmphasizedUsage","CTFontMediumUsage", "CTFontSemiboldUsage", "CTFontBlackUsage":
            fontName = Fonts().semibold
        case "CTFontBoldUsage","CTFontHeavyUsage":
            fontName = Fonts().bold
        default:
            fontName = Fonts().light
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    class func overrideDefaultTypography() {
        
        guard self == UIFont.self else { return }
        
        if let systemFontMethodWithWeight = class_getClassMethod(self, #selector(systemFont(ofSize: weight:))),
            let mySystemFontMethodWithWeight = class_getClassMethod(self, #selector(mySystemFont(ofSize: weight:))) {
            method_exchangeImplementations(systemFontMethodWithWeight, mySystemFontMethodWithWeight)
        }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
    
    var weight: UIFont.Weight {
        guard let weightNumber = traits[.weight] as? NSNumber else { return .regular }
        let weightRawValue = CGFloat(weightNumber.doubleValue)
        let weight = UIFont.Weight(rawValue: weightRawValue)
        return weight
    }
    
    private var traits: [UIFontDescriptor.TraitKey: Any] {
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
            ?? [:]
    }
    
    var isItalic: Bool {
        return (fontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) > 0
    }
}
