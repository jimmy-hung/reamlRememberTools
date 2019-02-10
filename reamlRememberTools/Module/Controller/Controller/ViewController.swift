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
    var checkSecret = UserDefaults().string(forKey: "secret") ?? "nothing"
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
    
    let addView = UIView()
    let inputLb = UILabel()
    let inputTxt = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if checkSecret != "nothing" {
            addView.frame = view.frame ; addView.backgroundColor = .lightGray ; addView.alpha = 0.6
            
            inputLb.text = "請輸入密碼"
            inputLb.frame = CGRect(x: view.frame.width/3, y: view.frame.height/4, width: view.frame.width/3, height: view.frame.height/20)
            
            inputTxt.keyboardType = .phonePad ; inputTxt.backgroundColor = .white
            inputTxt.frame = CGRect(x: view.frame.width/3, y: view.frame.height/2.5, width: view.frame.width/3, height: view.frame.height/20)
            
            view.addSubview(addView)
            addView.addSubview(inputLb) ; addView.addSubview(inputTxt)
        }
        
        nextPageBtn.getCorner(cornerItem: nextPageBtn, myCorner: 15, cornerBG: .lightGray)
    }
    
    @IBAction func gestureAtn(_ sender: UITapGestureRecognizer) {
        if inputTxt.text != "" {
            if inputTxt.text == checkSecret{
                UIView.animate(withDuration: 2.5) {
                    self.addView.alpha = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
                    self.addView.removeFromSuperview()
                }
                view.endEditing(true)
            }
        }
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
