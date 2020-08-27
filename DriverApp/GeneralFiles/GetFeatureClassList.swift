//
//  GetFeatureClassList.swift
//  PassengerApp
//
//  Created by Apple on 01/03/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class GetFeatureClassList: NSObject {

    static func getAllGeneralClasses() -> [String:String]{
    
/*************         VOIP SERVICE     **************/
        let VoipModule = NSMutableDictionary()
        VoipModule["VOIP_SERVICE"] = "No"
        
        var checkPodExsists = false
        let voipClassList = NSMutableArray()      // Class List
        voipClassList.add("SINLocalNotification.h")
        voipClassList.add("Screens/SinchCallingUV.swift")
        voipClassList.add("GeneralFiles/SinchCalling.swift")
        for value in voipClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    
                    if(String(substring) == "SINLocalNotification"){
                        checkPodExsists = true
                    }
                    VoipModule["VOIP_SERVICE"] = "Yes"
                    break
                }
            }
        }
        
        if(checkPodExsists == true){
            voipClassList.add("Remove From Pod")
        }
        VoipModule["classNameList"] = voipClassList
        
        let voipXibList = NSMutableArray()     // Xib List
        voipXibList.add("ScreenDesigns/SinchCallingScreenDesign.xib")
        VoipModule["xibList"] = voipXibList
        for value in voipXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    VoipModule["VOIP_SERVICE"] = "Yes"
                    break
                }
            }
        }
        
/*************         ADVERTISEMENT     **************/
        let AdvertisementModule = NSMutableDictionary()
        AdvertisementModule["ADVERTISEMENT_MODULE"] = "No"
        
        let advertisementClassList = NSMutableArray() // Class List
        advertisementClassList.add("CustomViewFiles/AdvertisementView.swift")
        AdvertisementModule["classNameList"] = advertisementClassList
        for value in advertisementClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    AdvertisementModule["ADVERTISEMENT_MODULE"] = "Yes"
                    break
                }
            }
        }
        
        let advertisementXibList = NSMutableArray()     // Xib List
        advertisementXibList.add("CustomViewDesigns/AdvertisementView.xib")
        AdvertisementModule["xibList"] = advertisementXibList
        for value in advertisementXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    AdvertisementModule["ADVERTISEMENT_MODULE"] = "Yes"
                    break
                }
            }
        }
        
/*************         Live Chat     **************/
        let LiveChatModule = NSMutableDictionary()
        LiveChatModule["LIVE_CHAT"] = "No"
        
        let livechatClassList = NSMutableArray() // Class List
        livechatClassList.add("ExternalLibraries/Frameworks/LiveChatSource.framework")
        LiveChatModule["classNameList"] = livechatClassList
        for value in livechatClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    LiveChatModule["LIVE_CHAT"] = "Yes"
                    break
                }
            }
        }
        
        let livechatXibList = NSMutableArray()    // Xib List
        LiveChatModule["xibList"] = livechatXibList
        

/*************         CARD IO     **************/
        let CardIOModule = NSMutableDictionary()
        CardIOModule["CARD_IO"] = "No"
        
        let cardIoClassList = NSMutableArray() // Class List
        cardIoClassList.add("CardIOCreditCardInfo.h")
        CardIOModule["classNameList"] = cardIoClassList
        for value in cardIoClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    CardIOModule["CARD_IO"] = "Yes"
                    break
                }
            }
        }
        
        let cardIoXibList = NSMutableArray()    // Xib List
        CardIOModule["xibList"] = cardIoXibList
        
        
/*************         LINKEDIN MODULE     **************/
        let LinkedinModule = NSMutableDictionary()
        LinkedinModule["LINKEDIN_MODULE"] = "No"
        
        let linkedinClassList = NSMutableArray() // Class List
        linkedinClassList.add("GeneralFiles/OpenLinkedinLogin.swift")
        LinkedinModule["classNameList"] = linkedinClassList
        for value in linkedinClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    LinkedinModule["LINKEDIN_MODULE"] = "Yes"
                    break
                }
            }
        }
        
        let linkedinXibList = NSMutableArray()    // Xib List
        LinkedinModule["xibList"] = linkedinXibList
        
        
/*************         WAYBILL MODULE    **************/
        let WayBillModule = NSMutableDictionary()
        WayBillModule["WAYBILL_MODULE"] = "No"
        
        let wayBillClassList = NSMutableArray() // Class List
        wayBillClassList.add("Screens/WayBillMultiUV.swift")
        wayBillClassList.add("Screens/WayBillUV.swift")
        WayBillModule["classNameList"] = wayBillClassList
        for value in linkedinClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    WayBillModule["WAYBILL_MODULE"] = "Yes"
                    break
                }
            }
        }
        
        let wayBillXibList = NSMutableArray()// Xib List
        wayBillXibList.add("ScreenDesigns/WayBillMultiScreenDesign.xib")
        wayBillXibList.add("ScreenDesigns/WayBillScreenDesign.xib")
        WayBillModule["xibList"] = wayBillXibList
        for value in wayBillXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    WayBillModule["WAYBILL_MODULE"] = "Yes"
                    break
                }
            }
        }
        
    
/*************         MULTI DELIVERY     **************/
        let MultiDeliveryModule = NSMutableDictionary()
        MultiDeliveryModule["MULTI_DELIVERY"] = "No"
        
        let multiDelClassList = NSMutableArray() // Class List
        multiDelClassList.add("Screens/ViewMultiDeliveryDetailsUV.swift")
        multiDelClassList.add("Screens/WayBillMultiUV.swift")
        multiDelClassList.add("Screens/RideMultiDetailUV.swift")
        multiDelClassList.add("CustomViewFiles/FareDetailsViewForMulti.swift")
        multiDelClassList.add("GeneralFiles/YPDrawSignatureView.swift")
        
        MultiDeliveryModule["classNameList"] = multiDelClassList
        for value in multiDelClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    MultiDeliveryModule["MULTI_DELIVERY"] = "Yes"
                    break
                }
            }
        }
        
        let multiDelXibList = NSMutableArray()     // Xib List
        multiDelXibList.add("ScreenDesigns/AskForPayScreenDesign.xib")
        multiDelXibList.add("ScreenDesigns/ViewMultiDeliveryDetailsScreenDesign.xib")
        multiDelXibList.add("ScreenDesigns/WayBillMultiScreenDesign.xib")
        multiDelXibList.add("ScreenDesigns/RideMultiDetailScreenDesign.xib")
        multiDelXibList.add("CustomViewDesigns/FareDetailsViewForMulti.xib")
        multiDelXibList.add("CustomViewDesigns/MultiDelDetailsView.xib")
        multiDelXibList.add("CustomViewDesigns/SignatureDisplayView.xib")
        
        MultiDeliveryModule["xibList"] = multiDelXibList
        for value in multiDelXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    MultiDeliveryModule["MULTI_DELIVERY"] = "Yes"
                    break
                }
            }
        }
        
        
/*************         DELIVERY MODULE     **************/
        let DeliveryModule = NSMutableDictionary()
        DeliveryModule["DELIVERY_MODULE"] = "No"
        
        let deliveryClassList = NSMutableArray() // Class List
        deliveryClassList.add("Screens/ViewDeliveryDetailsUV.swift")
        deliveryClassList.add("GeneralFiles/OpenEnterDeliveryCode.swift")
        deliveryClassList.add("CustomViewFiles/EnterDeliveryCodeView.swift")
        DeliveryModule["classNameList"] = deliveryClassList
        for value in deliveryClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    DeliveryModule["DELIVERY_MODULE"] = "Yes"
                    break
                }
            }
        }
        
        let deliveryXibList = NSMutableArray()     // Xib List
        deliveryXibList.add("ScreenDesigns/ViewDeliveryDetailsScreenDesign.xib")
        deliveryXibList.add("CustomViewDesigns/EnterDeliveryCodeView.xib")
        DeliveryModule["xibList"] = deliveryXibList
        for value in deliveryXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    DeliveryModule["DELIVERY_MODULE"] = "Yes"
                    break
                }
            }
        }
        
        
/*************         END OF DAY TRIP MODULE     **************/
        let EODModule = NSMutableDictionary()
        EODModule["END_OF_DAY_TRIP_SECTION"] = "No"
        
        let eodClassList = NSMutableArray() // Class List
        eodClassList.add("CustomViewFiles/RecentLocationView.swift")
        eodClassList.add("Cells/RecentLocationTVCell.swift")
        EODModule["classNameList"] = eodClassList
        for value in eodClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    EODModule["END_OF_DAY_TRIP_SECTION"] = "Yes"
                    break
                }
            }
        }
        
        let eodXibList = NSMutableArray()     // Xib List
        eodXibList.add("CustomViewDesigns/RecentLocationView.xib")
        eodXibList.add("CellDesign/RecentLocationTVCell.xib")
        EODModule["xibList"] = eodXibList
        for value in eodXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    EODModule["END_OF_DAY_TRIP_SECTION"] = "Yes"
                    break
                }
            }
        }
        
/*************         STOP OVER POINT MODULE     **************/
        let MSPModule = NSMutableDictionary()
        MSPModule["STOP_OVER_POINT_SECTION"] = "No"
        
        let mspClassList = NSMutableArray() // Class List
        mspClassList.add("Screens/ViewMSPDetailsUV.swift")
        mspClassList.add("Cells/MSPDetailsTVCell.swift")
        MSPModule["classNameList"] = mspClassList
        for value in mspClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    MSPModule["STOP_OVER_POINT_SECTION"] = "Yes"
                    break
                }
            }
        }
        
        let mspXibList = NSMutableArray()     // Xib List
        mspXibList.add("ScreenDesigns/ViewMSPDetailsScreenDesign.xib")
        mspXibList.add("CellDesign/MSPDetailsTVCell.xib")
        MSPModule["xibList"] = mspXibList
        for value in mspXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    MSPModule["STOP_OVER_POINT_SECTION"] = "Yes"
                    break
                }
            }
        }
        
        
/*************         NEWS SECTION     **************/
        let NewsSectionModule = NSMutableDictionary()
        NewsSectionModule["NEWS_SECTION"] = "No"
        
        let newsClassList = NSMutableArray() // Class List
        newsClassList.add("Screens/NotificationsTabUV.swift")
        newsClassList.add("Screens/NotificationDetailUV.swift")
        newsClassList.add("Screens/NotificationsUV.swift")
        newsClassList.add("Cells/NotificationTVCell.swift")
        NewsSectionModule["classNameList"] = newsClassList
        for value in newsClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    NewsSectionModule["NEWS_SECTION"] = "Yes"
                    break
                }
            }
        }
        
        let newsXibList = NSMutableArray()     // Xib List
        newsXibList.add("ScreenDesigns/NotificationDetailScreenDesign.xib")
        newsXibList.add("ScreenDesigns/NotificationsScreenDesign.xib")
        newsXibList.add("CellDesign/NotificationTVCell.xib")
        NewsSectionModule["xibList"] = newsXibList
        for value in newsXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    NewsSectionModule["NEWS_SECTION"] = "Yes"
                    break
                }
            }
        }
        
        
/*************         RENTAL FEATURE    **************/
        let RentalModule = NSMutableDictionary()
        RentalModule["RENTAL_FEATURE"] = "No"
        
        let rentalClassList = NSMutableArray() // Class List
        rentalClassList.add("Screens/RentalFareDetailsUV.swift")
        rentalClassList.add("Screens/RentalPackageDetailsUV.swift")
        RentalModule["classNameList"] = rentalClassList
        for value in rentalClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    RentalModule["RENTAL_FEATURE"] = "Yes"
                    break
                }
            }
        }
        
        let rentalXibList = NSMutableArray()     // Xib List
        rentalXibList.add("ScreenDesigns/RentalFareDetailsScreenDesign.xib")
        rentalXibList.add("ScreenDesigns/RentalPackageDetailsScreenDesign.xib")
        rentalXibList.add("CustomViewDesigns/PackageDataItemView.xib")
        RentalModule["xibList"] = rentalXibList
        for value in rentalXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    RentalModule["RENTAL_FEATURE"] = "Yes"
                    break
                }
            }
        }
        
        
/*************         RIDE SECTION     **************/
        let RideModule = NSMutableDictionary()
        RideModule["RIDE_SECTION"] = "No"
        
        let rideClassList = NSMutableArray() // Class List
        rideClassList.add("Screens/TaxiHailUV.swift")
        rideClassList.add("Cells/CabTypeCVCell.swift")
        RideModule["classNameList"] = rideClassList
        for value in rideClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    RideModule["RIDE_SECTION"] = "Yes"
                    break
                }
            }
        }
        
        let rideXibList = NSMutableArray()     // Xib List
        rideXibList.add("ScreenDesigns/TaxiHailScreenDesign.xib")
        rideXibList.add("CellDesign/CabTypeCVCell.xib")
        RideModule["xibList"] = rideXibList
        for value in rideXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    RideModule["RIDE_SECTION"] = "Yes"
                    break
                }
            }
        }
        
 
/*************         RDU SECTION    **************/
        let RDUModule = NSMutableDictionary()
        RDUModule["RDU_SECTION"] = "No"
        
        let RDUClassList = NSMutableArray() // Class List
        RDUClassList.add("Screens/FareBreakDownUV.swift")
        RDUClassList.add("Screens/RideDetailUV.swift")
        RDUClassList.add("Screens/RideHistoryUV.swift")
        RDUClassList.add("Screens/RideHistoryTabUV.swift")
        RDUClassList.add("Screens/RatingUV.swift")
        RDUClassList.add("Screens/HeatViewUV.swift")
        RDUClassList.add("Screens/SetPreferencesUV.swift")
        RDUClassList.add("Screens/ActiveTripUV.swift")
        RDUClassList.add("Screens/CabRequestedUV.swift")
        RDUClassList.add("Screens/SelectedDayRideHistoryUV.swift")
        RDUClassList.add("Screens/AppTypeSelectionUV.swift")
        RDUClassList.add("Screens/DriverArrivedUV.swift")
        RDUClassList.add("Screens/CollectPaymentUV.swift")
        RDUClassList.add("Cells/RideHistoryTVCell.swift")
        RDUClassList.add("Cells/MyOnGoingTripDetailsTVCell.swift")
        RDUClassList.add("CustomViewFiles/AdditionalChargesView.swift")
        RDUClassList.add("GeneralFiles/OpenEnterDeliveryCode.swift")
        RDUClassList.add("GeneralFiles/OpenCancelBooking.swift")
        RDUClassList.add("GeneralFiles/OpenAdditionalChargesView.swift")
        RDUClassList.add("GeneralFiles/OpenTollBox.swift")
        
        RDUModule["classNameList"] = RDUClassList
        for value in RDUClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    RDUModule["RDU_SECTION"] = "Yes"
                    break
                }
            }
        }
        
        let RDUXibList = NSMutableArray()     // Xib List
        RDUXibList.add("ScreenDesigns/FareBreakDownScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/RideDetailScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/RideHistoryScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/RatingScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/SetPreferencesScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/HeatViewScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/ActiveTripScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/CabRequestedScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/SelectedDayRideHistoryScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/AppTypeSelctionScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/DriverArrivedScreenDesign.xib")
        RDUXibList.add("ScreenDesigns/CollectPaymentScreenDesign.xib")
        RDUXibList.add("CellDesign/RideHistoryTVCell.xib")
        RDUXibList.add("CellDesign/MyOnGoingTripDetailsTVCell.xib")
        RDUXibList.add("CustomViewDesigns/AdditionalChargesView.xib")
        RDUXibList.add("CustomViewDesigns/EditServiceAmountView.xib")
        RDUXibList.add("CustomViewDesigns/EditServiceAmountView.xib")
        RDUXibList.add("CustomViewDesigns/SurgePriceView.xib")
        RDUXibList.add("CustomViewDesigns/ActiveSurgePriceView.xib")
    
        RDUModule["xibList"] = RDUXibList
        for value in RDUXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    RDUModule["RDU_SECTION"] = "Yes"
                    break
                }
            }
        }
        
/*************         UBERX SERVICE     **************/
        let uberXModule = NSMutableDictionary()
        uberXModule["UBERX_SERVICE"] = "No"
        
        let uberXClassList = NSMutableArray() // Class List
        uberXClassList.add("Screens/UFXAdditionalChargesUV.swift")
        uberXClassList.add("Screens/UFXChooseServicePhotoUV.swift")
        uberXClassList.add("Screens/UFXSelectAvailabilityDayUV.swift")
        uberXClassList.add("Screens/UFXUpdateDayAvailabilityUV.swift")
        uberXClassList.add("Screens/UpdateServicesUV.swift")
        uberXClassList.add("Screens/UFXGallaryUV.swift")
        uberXClassList.add("Screens/UFXProviderViewMoreServicesUV.swift")
        uberXClassList.add("Screens/ManageWorkLocationUV.swift")
        uberXClassList.add("Screens/ManageServicesUV.swift")
        uberXClassList.add("Cells/RideHistoryUFXListTVCell.swift")
        uberXClassList.add("Cells/UFXSelectAvailabilityDayCVCell.swift")
        uberXClassList.add("Cells/ManageServicesHeaderTVCell.swift")
        uberXClassList.add("Cells/ManageServicesSubTVCell.swift")
        uberXClassList.add("Cells/UFXUpdateDayAvailabilityCVCell.swift")
        uberXClassList.add("Cells/UpdateServicesTVCell.swift")
        uberXClassList.add("Cells/UFXGalleryCVC.swift")
        uberXClassList.add("Cells/UFXReqServicesTVCell.swift")
        uberXClassList.add("CustomViewFiles/EnterUFXAvailabilityRadiusView.swift")
        uberXClassList.add("GeneralFiles/OpenEnterUFXAvailRadiusView.swift")
        
        uberXModule["classNameList"] = uberXClassList
        for value in uberXClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    uberXModule["UBERX_SERVICE"] = "Yes"
                    break
                }
            }
        }
        
        let uberXXibList = NSMutableArray()     // Xib List
        uberXXibList.add("ScreenDesigns/ManageServicesScreenDesign.xib")
        uberXXibList.add("ScreenDesigns/ActiveTripUFXScreenDesign.xib")
        uberXXibList.add("ScreenDesigns/UFXAdditionalChargesScreenDesign.xib")
        uberXXibList.add("ScreenDesigns/UFXChooseServicePhotoScreenDesign.xib")
        uberXXibList.add("ScreenDesigns/UFXMainScreenDesign.xib")
        uberXXibList.add("ScreenDesigns/UFXSelectAvailabilityDayScreenDesign.xib")
        uberXXibList.add("ScreenDesigns/UFXUpdateDayAvailabilityScreenDesign.xib")
        uberXXibList.add("ScreenDesigns/UpdateServicesScreenDesign.xib")
        uberXXibList.add("ScreenDesigns/UFXGallaryScreenDesign.xib")
        uberXXibList.add("ScreenDesigns/ManageWorkLocationScreenDesign.xib")
        uberXXibList.add("ScreenDesigns/UFXProviderViewMoreServicesScreenDesign.xib")
        uberXXibList.add("CellDesign/RideHistoryUFXListTVCell.xib")
        uberXXibList.add("CellDesign/ManageServicesHeaderTVCell.xib")
        uberXXibList.add("CellDesign/ManageServicesSubTVCell.xib")
        uberXXibList.add("CellDesign/UFXSelectAvailabilityDayCVCell.xib")
        uberXXibList.add("CellDesign/UFXUpdateDayAvailabilityCVCell.xib")
        uberXXibList.add("CellDesign/UpdateServicesTVCell.xib")
        uberXXibList.add("CellDesign/UFXGalleryCVC.xib")
        uberXXibList.add("CellDesign/UFXReqServicesTVCell.xib")
        uberXXibList.add("CustomViewDesigns/EnterUFXAvailabilityRadiusView.xib")
        
        
        uberXModule["xibList"] = uberXXibList
        for value in uberXXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    uberXModule["UBERX_SERVICE"] = "Yes"
                    break
                }
            }
        }
     
/*************         DeliverAll MODULE     **************/
        let DeliverAllModule = NSMutableDictionary()
        DeliverAllModule["DELIVER_ALL"] = "No"

        let deliverAllClassList = NSMutableArray() // Class List
        deliverAllClassList.add("Screens/DeliverAll/DelAllCabRequestedUV.swift")
        deliverAllClassList.add("Screens/DeliverAll/DelAllStatisticsUV.swift")
        deliverAllClassList.add("Screens/DeliverAll/DelAllWayBillUV.swift")
        deliverAllClassList.add("Screens/DeliverAll/DeliveredOrderRatingUV.swift")
        deliverAllClassList.add("Screens/DeliverAll/LiveTaskUV.swift")
        deliverAllClassList.add("Screens/DeliverAll/NavigateToDestinationUV.swift")
        deliverAllClassList.add("Screens/DeliverAll/OrderDeliveredUV.swift")
        deliverAllClassList.add("Screens/DeliverAll/OrderHistoryDetailsUV.swift")
        deliverAllClassList.add("Screens/DeliverAll/OrderHistoryUV.swift")
        deliverAllClassList.add("Screens/DeliverAll/OrderPickedupUV.swift")
        deliverAllClassList.add("Screens/DeliverAll/RestaurantChoosePhotoUV.swift")
        deliverAllClassList.add("Cells/DeliverAll/LiveTaskDeliverTVCell.swift")
        deliverAllClassList.add("Cells/DeliverAll/LiveTaskPickupTVCell.swift")
        deliverAllClassList.add("Cells/DeliverAll/OrderDetailListTVCell.swift")
        deliverAllClassList.add("Cells/DeliverAll/OrderHistoryItemTVC.swift")
        deliverAllClassList.add("Cells/DeliverAll/OrderPickupListTVCell.swift")
        deliverAllClassList.add("CustomViewFiles/DeliverAll/DeliveredSubmitDetailsView.swift")
        deliverAllClassList.add("CustomViewFiles/DeliverAll/OrderPickedupSubmitDetailsView.swift")
        deliverAllClassList.add("CustomViewFiles/DeliverAll/SubmitDetailsView.swift")
        deliverAllClassList.add("GeneralFiles/DeliverAll/OpenDeliveredSubmitDetailsView.swift")
        deliverAllClassList.add("GeneralFiles/DeliverAll/OpenOrderPickedupSubmitDetailsView.swift")
        deliverAllClassList.add("GeneralFiles/DeliverAll/OpenSubmitDetailsView.swift")
        
        DeliverAllModule["classNameList"] = deliverAllClassList
        for value in deliverAllClassList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).classFromString()){
                    DeliverAllModule["DELIVER_ALL"] = "Yes"
                    break
                }
            }
        }

        let deliverAllXibList = NSMutableArray()     // Xib List
        deliverAllXibList.add("ScreenDesigns/DeliverAll/DelAllCabRequestedScreenDesign.xib")
        deliverAllXibList.add("ScreenDesigns/DeliverAll/DelAllStatisticsScreenDesign.xib")
        deliverAllXibList.add("ScreenDesigns/DeliverAll/DelAllWayBillScreenDesign.xib")
        deliverAllXibList.add("ScreenDesigns/DeliverAll/DeliveredOrderRatingScreen.xib")
        deliverAllXibList.add("ScreenDesigns/DeliverAll/LiveTaskScreenDesign.xib")
        deliverAllXibList.add("ScreenDesigns/DeliverAll/NavigateToDestinationScreenDesign.xib")
        deliverAllXibList.add("ScreenDesigns/DeliverAll/OrderDeliveredScreenDesign.xib")
        deliverAllXibList.add("ScreenDesigns/DeliverAll/OrderHistoryDetailsScreenDesign.xib")
        deliverAllXibList.add("ScreenDesigns/DeliverAll/OrderHistoryScreenDesign.xib")
        deliverAllXibList.add("ScreenDesigns/DeliverAll/OrderPickedupScreenDesign.xib")
        deliverAllXibList.add("ScreenDesigns/DeliverAll/RestaurantChoosePhotoScreenDesign.xib")
        deliverAllXibList.add("CellDesign/DeliverAll/LiveTaskDeliverTVCell.xib")
        deliverAllXibList.add("CellDesign/DeliverAll/LiveTaskPickupTVCell.xib")
        deliverAllXibList.add("CellDesign/DeliverAll/OrderDetailListTVCell.xib")
        deliverAllXibList.add("CellDesign/DeliverAll/OrderHistoryItemTVC.xib")
        deliverAllXibList.add("CellDesign/DeliverAll/OrderPickupListTVCell.xib")
        deliverAllXibList.add("CustomViewDesigns/DeliverAll/DeliveredSubmitDetailsView.xib")
        deliverAllXibList.add("CustomViewDesigns/DeliverAll/OrderDetailView.xib")
        deliverAllXibList.add("CustomViewDesigns/DeliverAll/OrderPickedupSubmitDetailsView.xib")
        deliverAllXibList.add("CustomViewDesigns/DeliverAll/PickUpMarkerView.xib")
        deliverAllXibList.add("CustomViewDesigns/DeliverAll/SubmitDetailsView.xib")
        deliverAllXibList.add("CustomViewDesigns/DeliverAll/TitleHeaderView.xib")
        

        
        DeliverAllModule["xibList"] = deliverAllXibList
        for value in deliverAllXibList{
            let valueStr = (value as! String)
            let array:NSArray = valueStr.components(separatedBy: "/") as NSArray
            if let index = ((array.lastObject) as! String).range(of: ".")?.lowerBound {
                let substring = ((array.lastObject) as! String)[..<index]
                if (String(substring).xibFromString()){
                    DeliverAllModule["DELIVER_ALL"] = "Yes"
                    break
                }
            }
        }
        
        
        var finalDataPara = [String:String]()

        
        if (VoipModule.get("VOIP_SERVICE").uppercased() == "YES"){
            
            finalDataPara["VOIP_SERVICE"] = VoipModule.get("VOIP_SERVICE")
            finalDataPara["VOIP_SERVICE_FILES"] = ((VoipModule["classNameList"] as! NSArray).addingObjects(from: (VoipModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (AdvertisementModule.get("ADVERTISEMENT_MODULE").uppercased() == "YES"){
            
            finalDataPara["ADVERTISEMENT_MODULE"] = AdvertisementModule.get("ADVERTISEMENT_MODULE")
            finalDataPara["ADVERTISEMENT_MODULE_FILES"] = ((AdvertisementModule["classNameList"] as! NSArray).addingObjects(from: (AdvertisementModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (CardIOModule.get("CARD_IO").uppercased() == "YES"){
            
            finalDataPara["CARD_IO"] = CardIOModule.get("CARD_IO")
            finalDataPara["CARD_IO_FILES"] = "Remove From Pod"
        }
        
        if (LiveChatModule.get("LIVE_CHAT").uppercased() == "YES"){
            
            finalDataPara["LIVE_CHAT"] = LiveChatModule.get("LIVE_CHAT")
            finalDataPara["LIVE_CHAT_FILES"] = ((LiveChatModule["classNameList"] as! NSArray).addingObjects(from: (LiveChatModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (RDUModule.get("RDU_SECTION").uppercased() == "YES"){
            
            finalDataPara["RDU_SECTION"] = RDUModule.get("RDU_SECTION")
            finalDataPara["RDU_SECTION_FILES"] = ((RDUModule["classNameList"] as! NSArray).addingObjects(from: (RDUModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (LinkedinModule.get("LINKEDIN_MODULE").uppercased() == "YES"){
            
            finalDataPara["LINKEDIN_MODULE"] = LinkedinModule.get("LINKEDIN_MODULE")
            finalDataPara["LINKEDIN_MODULE_FILES"] = ((LinkedinModule["classNameList"] as! NSArray).addingObjects(from: (LinkedinModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (NewsSectionModule.get("NEWS_SECTION").uppercased() == "YES"){
            
            finalDataPara["NEWS_SECTION"] = NewsSectionModule.get("NEWS_SECTION")
            finalDataPara["NEWS_SERVICE_FILES"] = ((NewsSectionModule["classNameList"] as! NSArray).addingObjects(from: (NewsSectionModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (MultiDeliveryModule.get("MULTI_DELIVERY").uppercased() == "YES"){
            
            finalDataPara["MULTI_DELIVERY"] = MultiDeliveryModule.get("MULTI_DELIVERY")
            finalDataPara["MULTI_DELIVERY_FILES"] = ((MultiDeliveryModule["classNameList"] as! NSArray).addingObjects(from: (MultiDeliveryModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (EODModule.get("END_OF_DAY_TRIP_SECTION").uppercased() == "YES"){
            
            finalDataPara["END_OF_DAY_TRIP_SECTION"] = EODModule.get("END_OF_DAY_TRIP_SECTION")
            finalDataPara["END_OF_DAY_TRIP_SECTION_FILES"] = ((EODModule["classNameList"] as! NSArray).addingObjects(from: (EODModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (MSPModule.get("STOP_OVER_POINT_SECTION").uppercased() == "YES"){
            
            finalDataPara["STOP_OVER_POINT_SECTION"] = MSPModule.get("STOP_OVER_POINT_SECTION")
            finalDataPara["STOP_OVER_POINT_SECTION_FILES"] = ((MSPModule["classNameList"] as! NSArray).addingObjects(from: (MSPModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (DeliveryModule.get("DELIVERY_MODULE").uppercased() == "YES"){
            
            finalDataPara["DELIVERY_MODULE"] = DeliveryModule.get("DELIVERY_MODULE")
            finalDataPara["DELIVERY_MODULE_FILES"] = ((DeliveryModule["classNameList"] as! NSArray).addingObjects(from: (DeliveryModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (WayBillModule.get("WAYBILL_MODULE").uppercased() == "YES"){
            
            finalDataPara["WAYBILL_MODULE"] = WayBillModule.get("WAYBILL_MODULE")
            finalDataPara["WAYBILL_MODULE_FILES"] = ((WayBillModule["classNameList"] as! NSArray).addingObjects(from: (WayBillModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (uberXModule.get("UBERX_SERVICE").uppercased() == "YES"){
            
            finalDataPara["UBERX_SERVICE"] = uberXModule.get("UBERX_SERVICE")
            finalDataPara["UBERX_FILES"] = ((uberXModule["classNameList"] as! NSArray).addingObjects(from: (uberXModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        
        if (RentalModule.get("RENTAL_FEATURE").uppercased() == "YES"){
            
            finalDataPara["RENTAL_FEATURE"] = RentalModule.get("RENTAL_FEATURE")
            finalDataPara["RENTAL_SERVICE_FILES"] = ((RentalModule["classNameList"] as! NSArray).addingObjects(from: (RentalModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        if (RideModule.get("RIDE_SECTION").uppercased() == "YES"){
            
            finalDataPara["RIDE_SECTION"] = RideModule.get("RIDE_SECTION")
            finalDataPara["RIDE_SECTION_FILES"] = ((RideModule["classNameList"] as! NSArray).addingObjects(from: (RideModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        
        if (DeliverAllModule.get("DELIVER_ALL").uppercased() == "YES"){
            
            finalDataPara["DELIVER_ALL"] = DeliverAllModule.get("DELIVER_ALL")
            finalDataPara["DELIVER_ALL_FILES"] = ((DeliverAllModule["classNameList"] as! NSArray).addingObjects(from: (DeliverAllModule["xibList"] as! NSArray) as! [Any]) as NSArray).componentsJoined(by: ",")
        }
        
        
        finalDataPara["PACKAGE_NAME"] = Bundle.main.bundleIdentifier
       
        return finalDataPara
        
    }
}
