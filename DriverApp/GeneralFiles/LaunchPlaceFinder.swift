//
//  LaunchPlaceFinder.swift
//  DriverApp
//
//  Created by ADMIN on 29/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
//import GooglePlaces

class LaunchPlaceFinder: NSObject, OnPlaceSelectDelegate { // GMSAutocompleteViewControllerDelegate, 
    typealias CompletionHandler = (_ address:String, _ latitude:Double, _ longitude:Double) -> Void
    
//    var autocompleteController:GMSAutocompleteViewController?
    
    let generalFunc = GeneralFunctions()
    
    var sourceLocationPlaceLatitude = 0.0
    var sourceLocationPlaceLongitude = 0.0
    
    var viewControllerUV:UIViewController?
    
    var completeBlock:CompletionHandler?
    
    var currInst:LaunchPlaceFinder!
    var currentTransition:JTMaterialTransition!
    
    var isForDriverDestinations = false
    var searchPlaceUv:SearchPlacesUV!
    
    init(viewControllerUV:UIViewController) {
        self.viewControllerUV = viewControllerUV
        super.init()
    }
    
    func setBiasLocation(sourceLocationPlaceLatitude:Double, sourceLocationPlaceLongitude:Double){
        self.sourceLocationPlaceLatitude = sourceLocationPlaceLatitude
        self.sourceLocationPlaceLongitude = sourceLocationPlaceLongitude
    }
    
    func initializeFinder(completionHandler: @escaping CompletionHandler){
        
        self.completeBlock = completionHandler
        
//        autocompleteController = GMSAutocompleteViewController()
//        autocompleteController!.delegate = currInst
//        autocompleteController!.configureRTLView()
        
        searchPlaceUv = (GeneralFunctions.instantiateViewController(pageName: "SearchPlacesUV") as! SearchPlacesUV)
        
        if(sourceLocationPlaceLongitude != 0.0 && sourceLocationPlaceLatitude != 0.0){
            
//            let neBoundsCorner = CLLocationCoordinate2D(latitude: sourceLocationPlaceLatitude,
//                                                        longitude: sourceLocationPlaceLongitude)
//            let swBoundsCorner = CLLocationCoordinate2D(latitude: sourceLocationPlaceLatitude,
//                                                        longitude: sourceLocationPlaceLongitude)
//            let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
//                                             coordinate: swBoundsCorner)
//
//            autocompleteController!.autocompleteBounds = bounds
            
            searchPlaceUv.locationBias = CLLocation(latitude: sourceLocationPlaceLatitude, longitude: sourceLocationPlaceLongitude)
        }
        
//        let searchBarTextAttributes = [NSForegroundColorAttributeName: UIColor.UCAColor.AppThemeTxtColor]
        
        let attributedPlaceholder = NSAttributedString(string: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Search"))
        
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
        
        let navController = UINavigationController(rootViewController: searchPlaceUv)
        navController.navigationBar.isTranslucent = false
        
//        if(self.currentTransition != nil){
//            autocompleteController!.modalPresentationStyle = .custom
//            autocompleteController!.transitioningDelegate = currentTransition
//        }
        
        searchPlaceUv.modalPresentationStyle = .custom
        searchPlaceUv.placeSelectDelegate = self
        searchPlaceUv.isForDriverDestinations = self.isForDriverDestinations
//        self.viewControllerUV!.present(searchPlaceUv, animated: true, completion: nil)
        
        self.viewControllerUV!.present(navController, animated: true, completion: nil)
        
//        self.viewControllerUV!.pushToNavController(uv: autocompleteController!)
    }
    
    func onPlaceSelectCancel(searchBar: UISearchBar, searchPlaceUv: SearchPlacesUV) {
        searchPlaceUv.placeSelectDelegate = nil
        searchPlaceUv.closeCurrentScreen()
    }
    
    func onPlaceSelected(location: CLLocation, address: String, searchBar: UISearchBar, searchPlaceUv: SearchPlacesUV) {
        searchPlaceUv.placeSelectDelegate = nil
        searchPlaceUv.closeCurrentScreen()
        
        if(self.completeBlock != nil){
            self.completeBlock!(address, location.coordinate.latitude, location.coordinate.longitude)
        }
    }
    
    /*func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if(place.coordinate.latitude == 0.0 || place.coordinate.latitude == -180.0 || place.coordinate.longitude == 0.0 || place.coordinate.longitude == -180.0){
            self.generalFunc.setError(uv: self.viewControllerUV!, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
            return
        }
        
        if(self.completeBlock != nil){
            self.completeBlock!(place.formattedAddress!, place.coordinate.latitude, place.coordinate.longitude)
        }

        autocompleteController!.closeCurrentScreen()
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        autocompleteController!.dismiss(animated: true, completion: nil)
        autocompleteController!.closeCurrentScreen()
    }
    
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }*/
    
}
