//
//  ViewController.swift
//  rememberTool
//
//  Created by 洪立德 on 2018/11/15.
//  Copyright © 2018 洪立德. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var profileView: UIView!
    @IBOutlet weak var nextPageBtn: UIButton!
    @IBOutlet weak var okOrEditBtn: UIButton!
    @IBOutlet weak var littleNameTxt: UITextField! // 小名
    @IBOutlet weak var duringDateTxt: UITextField! // 玩了多久
    @IBOutlet weak var putInMoneyTxt: UITextField! // 投入金額
    @IBOutlet weak var hadInMoneyTxt: UITextField! // 已投入金額
    @IBOutlet weak var tradeTimesTxt: UITextField! // 交易次數
    @IBOutlet weak var winOrzloseTxt: UITextField! // 總獲利金額
    
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
    let lottieAnimationVC = LottieAnimationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        lottieAnimationVC.startLottieAnimation(view: self.view)
        
        if checkSecret != "nothing" {
            addView.frame = view.frame ; addView.backgroundColor = .lightGray ; addView.alpha = 0.6
            
            inputLb.text = "請輸入密碼 ....."
            inputLb.frame = CGRect(x: view.frame.width/3, y: view.frame.height/4, width: view.frame.width/3, height: view.frame.height/20)
            
            inputTxt.keyboardType = .phonePad ; inputTxt.backgroundColor = .white
            inputTxt.frame = CGRect(x: view.frame.width/3, y: view.frame.height/2.5, width: view.frame.width/3, height: view.frame.height/20)
            inputTxt.layer.cornerRadius = 15
            
            view.addSubview(addView)
            addView.addSubview(inputLb) ; addView.addSubview(inputTxt)
        }
        
        if (Bundle.main.loadNibNamed("profile", owner: self, options: nil)?.first as? addData) != nil{
            
            profileView.frame = CGRect(x: <#T##Double#>, y: <#T##Double#>, width: <#T##Double#>, height: <#T##Double#>)
            
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
    
    // MARK: SwipeGesturer
    func useSwipeGesture(addView: UIView){
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(recognizer:)))
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(recognizer:)))
        
        leftGesture.direction = .left ; rightGesture.direction = .right
        
        addView.addGestureRecognizer(leftGesture)
        addView.addGestureRecognizer(rightGesture)
    }
    
    @objc func swipeGesture(recognizer: UISwipeGestureRecognizer){
        
        if recognizer.direction == .left{
            
        }else{
            
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
 
    @IBAction func txtCollection(_ sender: UITextField) {
        
        switch sender.tag {
            case 0: littleNameTxt.text = UserDefaults().string(forKey: "littleName")
            case 1: duringDateTxt.text = UserDefaults().string(forKey: "duringDate")
            case 2: putInMoneyTxt.text = UserDefaults().string(forKey: "putInMoney")
            case 3: hadInMoneyTxt.text = UserDefaults().string(forKey: "hadInMoney")
            case 4: tradeTimesTxt.text = UserDefaults().string(forKey: "tradeTimes")
            case 5: winOrzloseTxt.text = UserDefaults().string(forKey: "winOrzlose")
        default:
            return
        }
    }
    
    @IBAction func okOrEditAtn(_ sender: UIButton) {
        
        if okOrEditBtn.titleLabel?.text == "edit" {
            
            
            okOrEditBtn.titleLabel?.text = "ok"
            
        }else if okOrEditBtn.titleLabel?.text == "ok" {
            
            
            okOrEditBtn.titleLabel?.text = "edit"
            
        }
        
    }
}

extension ViewController: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if okOrEditBtn.titleLabel?.text == "edit" {
            return true
        }else{
            return false
        }
    }
}
