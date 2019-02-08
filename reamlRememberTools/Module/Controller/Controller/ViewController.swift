//
//  ViewController.swift
//  rememberTool
//
//  Created by 洪立德 on 2018/11/15.
//  Copyright © 2018 洪立德. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nextPageBtn: UIButton!
    var checkBG = 0{
        willSet{
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nextPageBtn.getCorner(cornerItem: nextPageBtn, myCorner: 15, cornerBG: .lightGray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    @IBAction func settingAtn(_ sender: UIButton) {
        checkBG += 1
    }
    
}
