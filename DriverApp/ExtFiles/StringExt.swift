//
//  StringExt.swift
//
//  Created by Chirag on 15/03/16.
//  Copyright © 2016 BBCS. All rights reserved.
//

import Foundation
import Photos

extension String {
    
    func decodeUrl() -> String{
        return self.removingPercentEncoding == nil ? "" : self.removingPercentEncoding!
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex ..< endIndex])
    }

    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: NSString.CompareOptions.caseInsensitive) != nil
    }
    
    func containsOnlyLetters() -> Bool {
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    func isNumeric() -> Bool {
        return Double(self) != nil
    }
    
    func replace(_ target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    var utf8Data: Data? {
        return data(using: String.Encoding.utf8)
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func trimAll() -> String
    {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func isJsonMsg() -> Bool{
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            
            do {
                _ = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                //                if(jsonData != nil && (jsonData as! NSDictionary) != nil){
                return true
                //                }
            }  catch {
                return false
            }
            
        }
        
        return false
    }
    
    func getJsonDataDict() -> NSDictionary{
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let dict = [String:String]()
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                let jsonDataDict = jsonData as! NSDictionary
                
                return jsonDataDict
            }  catch {
                return dict as NSDictionary
            }
            
        } else {
            return dict as NSDictionary
        }
        
    }
    
    
    
    /// To check if the string contains characters other than white space and \n
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    subscript(r: Range<Int>) -> String? {
        get {
            let stringCount = self.count as Int
            if (stringCount < r.upperBound) || (stringCount < r.lowerBound) {
                return nil
            }
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound - r.lowerBound)
            return String(self[(startIndex ..< endIndex)])
        }
    }
    
    func containsAlphabets() -> Bool {
        //Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains( where: {
            guard let unicode = UnicodeScalar($0) else { return false }
            return set.contains(unicode)
        })
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    func charAt (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    func getHTMLString(fontName:String, fontSize:String, textColor:String, text:String) -> NSAttributedString{
        
        var direction = "ltr"
        if(Configurations.isRTLMode()){
            direction = "rtl"
        }
        
        let text = text.replacingOccurrences(of: "\n", with: "<br/>")

        let modifiedFont = NSString(format:"<div dir=\"\(direction)\" style=\"font-family: \(fontName); font-size: \(fontSize); color: \(textColor)\">%@</div>" as NSString, text) as String
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        return attrStr
    }
    
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
            }.joined().dropFirst())
    }
    
    func getStrickString() -> NSMutableAttributedString{
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return  attributeString
        
    }
    
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return boundingBox.width
    }
    
    func getDocumentExtension() ->String {
        var strImgExtension : String!
        let fetchOptions = PHFetchOptions()
        var lastAsset: PHAsset!
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with:.image, options: fetchOptions)
        if fetchResult.count > 0{
            lastAsset = fetchResult.lastObject!
        }
        
        let fileName : String = lastAsset.value(forKey: "filename") as! String
        strImgExtension = ((fileName.components(separatedBy: ".")[1]).lowercased())
        return strImgExtension
    }
    
    func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
            }.joined(separator: separator))
    }
    
    func classFromString() -> Bool {
        
        if(objc_getClass(self) != nil){
            return true
        }
        // get namespace
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
        
        let cls1: AnyClass? = NSClassFromString(self);
        if(cls1 != nil){
            return true
        }
        /// get 'anyClass' with classname and namespace
        let cls: AnyClass? = NSClassFromString("\(namespace).\(self)");
        
        // return AnyClass!
        if(cls == nil){
            
            let frameWorks = Bundle.allFrameworks
            if(frameWorks.count > 0){
                
                for i in 0..<frameWorks.count {
                    var arrayOfPathComp = [String] ()
                    
                    arrayOfPathComp = (frameWorks[i].resourcePath)?.components(separatedBy: "/") ?? [""]
                    
                    var finalArray = [String] ()
                    finalArray = arrayOfPathComp.last?.components(separatedBy: ".") ?? [""]
                    
                    if(finalArray.first == self){
                        return true
                    }
                }
            }else{
                return false
            }
            
            return false
            
        }else{
            return true
        }
    }
    
    func xibFromString() -> Bool{
        if(((Bundle.main).path(forResource: self, ofType: "nib")) != nil){
            return true
        }else{
            return false
        }
    }

}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}
