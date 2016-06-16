

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /*
    It's important to study the storyboard:
    we have the setup you'd expect: 
    the storyboard has relationships to the nav controllers,
    ...which have root view controller relationships to the master view and detail view
    But the master's table has a Replace (detail) segue to the second nav controller!
    Thus, every time the segue is performed from a table row, 
    we get a _new_ second nav controller with a _new_ detail view.
    This was not necessary on iPad alone where the second nav controller is always present...
    but on iPhone it must be created freshly every time.
*/

    var window: UIWindow?

    // basically, this is pure template code
    // I have neatened it up, shortened some names, and commented on it (and added logging)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let svc = self.window!.rootViewController as! UISplitViewController
        // place button in detail controller's nav bar
        let nav = svc.viewControllers.last as! UINavigationController
        // new in iOS 8, split v.c. vends the button with a method
        // note duplication!
        // the button will be added when the user taps a row in the master v.c....
        // but what if the split view appears _originally_ in portrait so there is no master?
        // then if we don't also added the button here, there is no button
        // the user can summon with swipe but might not realize that
        nav.topViewController?.navigationItem.leftBarButtonItem = svc.displayModeButtonItem()
        svc.delegate = self
        return true
    }
}

extension AppDelegate: UISplitViewControllerDelegate {

    // on iPhone, the split v.c. will be "collapsed"
    // this means the second view controller is "merged" onto the first in appropriate way
    // with a nav interface, what's appropriate is:
    // discard the 2nd nav controller, push 2nd v.c. onto 1st nav controller
    
    func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
        print("delegate primary view for collapsing, returning nil")
        return nil // means just do what you would normally do
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary vc2:UIViewController, onto vc1:UIViewController) -> Bool {
        print("begin delegate collapse")
        if let vc2 = vc2 as? UINavigationController {
            if let detail = vc2.topViewController as? DetailViewController {
                if detail.detailItem == nil {
                    // Return true to indicate "do nothing with vc2"
                    // try changing it to false!
                    // the svc will do its default behavior, which is to push the detail onto the stack
                    // so that we will launch showing it!
                    print("end delegate collapse, returning true")
                    return true
                }
            }
        }
        print("end delegate collapse, returning false")
        return false
    }
    

    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        print("mode?")
        return .automatic
    }
    
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        print("changing to mode: \(displayMode.rawValue)")
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: AnyObject?) -> Bool {
        print("svc show vc")
        return false
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: AnyObject?) -> Bool {
        print("svc show detail vc")
        return false
    }


}

