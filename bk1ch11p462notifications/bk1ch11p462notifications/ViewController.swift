
import UIKit
import MediaPlayer

let which = 1 // 1 or 2

class ViewController: UIViewController {
    
    var observers = Set<NSObject>()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.singleTap(self)
        
        let mp = MPMusicPlayerController.systemMusicPlayer()
        mp.beginGeneratingPlaybackNotifications()
        
        switch which {
        case 1:
            
            NotificationCenter.default().addObserver(self,
                selector: #selector(nowPlayingItemChanged),
                name: Notification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
                object: nil)
            
        case 2:
            
            let ob = NotificationCenter.default()
                .addObserver(forName:
                    Notification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
                    object: nil, queue: nil) {
                        _ in
                        print("changed")
            }
            self.observers.insert(ob as! NSObject)

            
        default:break
        }
        
    }
    
    func nowPlayingItemChanged (_ n:Notification) {
        print("changed")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch which {
        case 1:
            
            NotificationCenter.default().removeObserver(self)
            
        case 2:
            
            for ob in self.observers {
                NotificationCenter.default().removeObserver(ob)
            }
            self.observers.removeAll()
            
        default:break
        }
        
        let mp = MPMusicPlayerController.systemMusicPlayer()
        mp.endGeneratingPlaybackNotifications()
    }
    
    func singleTap(_:AnyObject) {
        NotificationCenter.default()
            .post(name: "cardTapped" as Notification.Name, object: self)
    }



}

