
import UIKit

class NotificationsTabUV: PageTabBarController, PageTabBarControllerDelegate {
    
    let generalFunc = GeneralFunctions()
    
    var isOpenFromMainScreen = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    
    open override func prepare() {
        super.prepare()
        
        delegate = self
        preparePageTabBar()
        
        self.addBackBarBtn()
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS")
        
        
    }
    
    override func closeCurrentScreen() {
        if(isOpenFromMainScreen){
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            super.closeCurrentScreen()
        }
    }
    
    fileprivate func preparePageTabBar() {
        pageTabBar.lineColor = Color.UCAColor.AppThemeColor
    }
    
    func pageTabBarController(pageTabBarController: PageTabBarController, didTransitionTo viewController: UIViewController) {
        //        print("pageTabBarController", pageTabBarController, "didTransitionTo viewController:", viewController)
    }
}
