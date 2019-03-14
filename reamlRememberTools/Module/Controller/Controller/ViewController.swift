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
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var okOrEditBtn: UIButton!
    @IBOutlet weak var okEditBtn: UIButton!
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
    
    var profileDataIEdit = false
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
        
        if (Bundle.main.loadNibNamed("profile", owner: self, options: nil)?.first as? profile) != nil{
            
            let viewF = view.frame
            profileView.frame = CGRect(x: -Double(viewF.width)/1.2, y: Double(viewF.height)/6, width: Double(viewF.width)/1.2, height: Double(viewF.height)/1.5)
            profileView.getCorner(cornerItem: profileView, myCorner: 15, cornerBG: .yellow)
            view.addSubview(profileView)
            
            littleNameTxt.delegate = self
            duringDateTxt.delegate = self
            putInMoneyTxt.delegate = self
            hadInMoneyTxt.delegate = self
            tradeTimesTxt.delegate = self
            winOrzloseTxt.delegate = self
            
        }
        
        littleNameTxt.text = "jimmy"
        
        nextPageBtn.getCorner(cornerItem: nextPageBtn, myCorner: 15, cornerBG: .lightGray)
        useSwipeGesture(addView: view)
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
        
        let viewF = view.frame

        if recognizer.direction == .left{
            if profileView.frame.origin.x == 0 {
                UIView.animate(withDuration: 0.5) {
                    self.profileView.frame = CGRect(x: -Double(viewF.width)/1.2, y: Double(viewF.height)/6, width: Double(viewF.width)/1.2, height: Double(viewF.height)/1.5)
                    self.nextPageBtn.frame.origin.x = self.view.center.x - self.nextPageBtn.frame.width/2
                    self.settingBtn.frame.origin.x = self.view.center.x - self.settingBtn.frame.width/2
                }
            }
        }else{
            if profileView.frame.origin.x < 0 {
                UIView.animate(withDuration: 0.5) {
                    self.profileView.frame = CGRect(x: 0, y: Double(viewF.height)/6, width: Double(viewF.width)/1.2, height: Double(viewF.height)/1.5)
                    self.nextPageBtn.frame.origin.x += 100
                    self.settingBtn.frame.origin.x += 100
                }
            }
        }
        
    }
    
    @objc func tapGesture(){
        view.endEditing(true)
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        profileView.addGestureRecognizer(tapGesture)
        insertProfiletoUserdefault()
    }
    
    @IBAction func settingAtn(_ sender: UIButton) {
        checkBG += 1
    }
    
    func insertProfiletoUserdefault(){
        littleNameTxt.text = UserDefaults().string(forKey: "littleName")
        duringDateTxt.text = UserDefaults().string(forKey: "duringDate")
        putInMoneyTxt.text = UserDefaults().string(forKey: "putInMoney")
        hadInMoneyTxt.text = UserDefaults().string(forKey: "hadInMoney")
        tradeTimesTxt.text = UserDefaults().string(forKey: "tradeTimes")
        winOrzloseTxt.text = UserDefaults().string(forKey: "winOrzlose")
    }
    
    @IBAction func okOrEditAtn(_ sender: UIButton) {
        
        profileDataIEdit = true
        okOrEditBtn.isEnabled = false
        okEditBtn.isEnabled = true
        
    }
    
    @IBAction func okEditAtn(_ sender: UIButton) {
        
        okEditBtn.isEnabled = false
        okOrEditBtn.isEnabled = true
        profileDataIEdit = false
        insertProfiletoUserdefault()
    }
    
}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if profileDataIEdit && textField.tag == 0 || profileDataIEdit && textField.tag == 1 || profileDataIEdit && textField.tag == 2{
            return true
        }else{
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            UserDefaults().set(littleNameTxt.text, forKey: "littleName")
        case 1:
            if !(UserDefaults().string(forKey: "duringDate")?.contains("天") ?? true){
                UserDefaults().set((duringDateTxt.text ?? "幾") + " 天", forKey: "duringDate")
            }else{
                UserDefaults().set(duringDateTxt.text, forKey: "duringDate")
            }
        case 2:
            UserDefaults().set(putInMoneyTxt.text, forKey: "putInMoney")
        case 3:
            UserDefaults().set(hadInMoneyTxt.text, forKey: "hadInMoney")
        case 4:
            UserDefaults().set(tradeTimesTxt.text, forKey: "tradeTimes")
        case 5:
            UserDefaults().set(winOrzloseTxt.text, forKey: "winOrzlose")
        default:
            break
        }
        insertProfiletoUserdefault()
        return true
    }
    
}

/*
 insertProfiletoUserdefault()
 switch sender.tag {
 case 0: UserDefaults().set(littleNameTxt.text, forKey: "littleName")
 case 1: UserDefaults().set(duringDateTxt.text, forKey: "duringDate")
 case 2: UserDefaults().set(putInMoneyTxt.text, forKey: "putInMoney")
 case 3: UserDefaults().set(hadInMoneyTxt.text, forKey: "hadInMoney")
 case 4: UserDefaults().set(tradeTimesTxt.text, forKey: "tradeTimes")
 case 5: UserDefaults().set(winOrzloseTxt.text, forKey: "winOrzlose")
 default:
 return
 
 
 switch textField.tag {
 case 0:
 littleNameTxt.text = UserDefaults().string(forKey: "littleName")
 case 1:
 duringDateTxt.text = UserDefaults().string(forKey: "duringDate")
 case 2:
 putInMoneyTxt.text = UserDefaults().string(forKey: "putInMoney")
 case 3:
 hadInMoneyTxt.text = UserDefaults().string(forKey: "hadInMoney")
 case 4:
 tradeTimesTxt.text = UserDefaults().string(forKey: "tradeTimes")
 case 5:
 winOrzloseTxt.text = UserDefaults().string(forKey: "winOrzlose")
 default:
 break
 }

 }
 */


