//
//  SettingViewController.swift
//  reamlRememberTools
//
//  Created by 洪立德 on 2019/2/7.
//  Copyright © 2019 洪立德. All rights reserved.
//

import UIKit
import RealmSwift

enum Mode{
    case systemDefault
    case pink
    case purple
    case blue
}

var current: Mode = .systemDefault
class SettingViewController: UIViewController {

    let realmAction = RealmAction()
    var recordBG = UserDefaults().string(forKey: "BG"){
        didSet{
            switch current {
            case .purple:
                UIView.animate(withDuration: 1.5) {
                    self.view.backgroundColor = UIColor.init(displayP3Red: 204/255, green: 204/255, blue: 255/255, alpha: 1)
                }
            case .pink:
                UIView.animate(withDuration: 1.5) {
                    self.view.backgroundColor = UIColor.init(displayP3Red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
                }
            case .blue:
                UIView.animate(withDuration: 1.5) {
                    self.view.backgroundColor = UIColor.init(displayP3Red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
                }
            case .systemDefault:
                UIView.animate(withDuration: 1.5) {
                    self.view.addVerticalGradientLayer(topColor: .white, bottomColor: .clear)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        switch current {
        case .purple:
            view.backgroundColor = UIColor.init(displayP3Red: 204/255, green: 204/255, blue: 255/255, alpha: 1)
        case .pink:
            view.backgroundColor = UIColor.init(displayP3Red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        case .blue:
            view.backgroundColor = UIColor.init(displayP3Red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        case .systemDefault:
            view.addVerticalGradientLayer(topColor: .white, bottomColor: .clear)
        }
    }
    
    @IBAction func bgAtn(_ sender: UIButton) {
                switch sender.tag {
                case 0:
                    current = .systemDefault ; UserDefaults().set("0", forKey: "BG") ; recordBG = "0"
                case 1:
                    current = .pink          ; UserDefaults().set("1", forKey: "BG") ; recordBG = "1"
                case 2:
                    current = .purple        ; UserDefaults().set("2", forKey: "BG") ; recordBG = "2"
                case 3:
                    current = .blue          ; UserDefaults().set("3", forKey: "BG") ; recordBG = "3"
                default:
                    return
                }
    }
    
    @IBAction func cleanUp(_ sender: UIButton) {
        addAlert(infoTitle: "System Prompt", infoMessage: "Do you want to clean up the data in you database ?", action: realmAction.cleanUp())
    }
    

    func addAlert( infoTitle: String, infoMessage: String, action: () ){
        let alertController = UIAlertController(title: infoTitle, message: infoMessage, preferredStyle: .actionSheet)
        
        let setAction = UIAlertAction(title: "sure", style: .default) { (alertAction) in
            action
            self.delayDismiss()
        }
        
        let setBction = UIAlertAction(title: "no", style: .cancel) { (alertAction) in
            self.delayDismiss()
        }
        
        alertController.addAction(setAction)
        alertController.addAction(setBction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func delayDismiss(){
        UIView.animate(withDuration: 2, animations: {
            self.view.alpha = 0
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
