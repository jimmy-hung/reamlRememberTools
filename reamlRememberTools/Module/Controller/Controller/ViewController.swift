//
//  ViewController.swift
//  rememberTool
//
//  Created by 洪立德 on 2018/11/15.
//  Copyright © 2018 洪立德. All rights reserved.
//

import UIKit
import RealmSwift
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
                    self.putInMoneyTxt.text = "0" // 投入金額歸0
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
        getUserdefaultToProfile()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        putInMoneyTxt.keyboardType = .numberPad
        countSumTrade()              // profile 計算基礎資料
        toCountHowLongDurningStock() // profile 計算總共過了多少天
    }
    
    @IBAction func settingAtn(_ sender: UIButton) {
        checkBG += 1
    }
    
    // 將個人基本資料儲存
    func insertProfileToUserdefault(){
        UserDefaults().set(littleNameTxt.text, forKey: "littleName")
        UserDefaults().set(duringDateTxt.text, forKey: "duringDate")
        UserDefaults().set(putInMoneyTxt.text, forKey: "putInMoney")
        UserDefaults().set(hadInMoneyTxt.text, forKey: "hadInMoney")
        UserDefaults().set(tradeTimesTxt.text, forKey: "tradeTimes")
        UserDefaults().set(winOrzloseTxt.text, forKey: "winOrzlose")
    }
    
    // 將顧人基本資料取出
    func getUserdefaultToProfile(){
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
        
        // 儲存設定名稱
        UserDefaults().set(littleNameTxt.text, forKey: "littleName")
        
        // 計算已投入金額
        if Int(hadInMoneyTxt.text!) != nil && Int(putInMoneyTxt.text!) != nil{
            let a = Int(hadInMoneyTxt.text!)! ; let b = Int(putInMoneyTxt.text!)! ; let sum = a + b
            hadInMoneyTxt.text = "\(sum)" ; UserDefaults().set(hadInMoneyTxt.text, forKey: "hadInMoney")
        }else if Int(hadInMoneyTxt.text!) == nil{
            let a = Int(putInMoneyTxt.text!)!
            hadInMoneyTxt.text = "\(a)" ; UserDefaults().set(hadInMoneyTxt.text, forKey: "hadInMoney")
        }else{
            return
        }
        // 將目前輸入的值儲存
        insertProfileToUserdefault()
    }
    
    // 計算第一次交易股票後開始總共過了多久
    func toCountHowLongDurningStock(){
        let realm = try! Realm()
        let stock = realm.objects(Stock.self)
        var dateArray : [Int] = []

        // 接出realm裡 年 的資料
        if stock.count != 0 {
            for i in 0 ... (stock.count - 1){
                dateArray.append(stock[i].year)
            }
            dateArray = dateArray.removingDuplicates()
            // 將陣列從小排到大 ( reverse() 大 - 小 )
            dateArray.sort()
        }
        
        if stock.count != 0 {
            
            // 找出所有符合最早年份的資料
            let aboutEarlyYear = realm.objects(Stock.self).filter("year = \(dateArray[0])")
            dateArray = [] // 重置說取月份
            if aboutEarlyYear.count != 0 {
                for i in 0 ... (aboutEarlyYear.count - 1){
                    dateArray.append(aboutEarlyYear[i].month)
                }
                dateArray = dateArray.removingDuplicates()
                // 將陣列從小排到大 ( reverse() 大 - 小 )
                dateArray.sort()
            }
            
            // 找出所有符合最早月份的資料
            let aboutEarlyMonth = realm.objects(Stock.self).filter("month = \(dateArray[0])")
            dateArray = [] // 重置說取日
            if aboutEarlyMonth.count != 0 {
                for i in 0 ... (aboutEarlyMonth.count - 1){
                    dateArray.append(aboutEarlyMonth[i].month)
                }
                dateArray = dateArray.removingDuplicates()
                // 將陣列從小排到大 ( reverse() 大 - 小 )
                dateArray.sort()
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY.MM.dd"
            
            let now:Date = Date()
            
            let nowTransform = formatter.date(from: formatter.string(from: now))!        // 現在日期
            let firstBuy = formatter.date(from: aboutEarlyMonth[0].buy_date)!            // 第一次購買日期
            
            let days = firstBuy.daysBetweenDate(toDate: nowTransform)                    // 總計多少天過去
            
            duringDateTxt.text = "\(days)" + "天"
            
        }
    }
    
    // 計算總交易次數 = 總共幾筆資料
    func countSumTrade(){
        let realm = try! Realm()
        let stock = realm.objects(Stock.self)
        tradeTimesTxt.text = String(stock.count)
        
        var sum : Double = 0
        
        if stock.count != 0 {
            for i in  0 ... (stock.count - 1) {
                if stock[i].sell_price != "" && stock[i].buy_price != "" {
                    let endPrice = Double(stock[i].count)! * ((Double(stock[i].sell_price)!) - (Double(stock[i].buy_price)!))
                    sum = sum + endPrice
                }
            }
            sum = sum * 1000
            
            // 有獲利顯示紅色，虧損則顯示綠色
            if sum > 0{
                winOrzloseTxt.textColor = .red
            }else if sum < 0{
                winOrzloseTxt.textColor = .green
            }
        }
        winOrzloseTxt.text = String(Int(sum.roundTo(places: 2)))
    }
}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if profileDataIEdit && textField.tag == 0 || profileDataIEdit && textField.tag == 2{
            return true
        }else{
            return false
        }
    }
    
    // 點擊編輯時，自動清空
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            littleNameTxt.text = ""
        case 2:
            putInMoneyTxt.text = ""
        default:
            return
        }
    }
    
    // 結束編輯時設定
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//
//        insertProfiletoUserdefault()
//        return true
//    }
    
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
 
 UserDefaults().set(littleNameTxt.text, forKey: "littleName")
 UserDefaults().set(duringDateTxt.text, forKey: "duringDate")
 UserDefaults().set(putInMoneyTxt.text, forKey: "putInMoney")
 UserDefaults().set(hadInMoneyTxt.text, forKey: "hadInMoney")
 UserDefaults().set(tradeTimesTxt.text, forKey: "tradeTimes")
 UserDefaults().set(winOrzloseTxt.text, forKey: "winOrzlose")
 
 littleNameTxt.text = UserDefaults().string(forKey: "littleName")
 duringDateTxt.text = UserDefaults().string(forKey: "duringDate")
 putInMoneyTxt.text = UserDefaults().string(forKey: "putInMoney")
 hadInMoneyTxt.text = UserDefaults().string(forKey: "hadInMoney")
 tradeTimesTxt.text = UserDefaults().string(forKey: "tradeTimes")
 winOrzloseTxt.text = UserDefaults().string(forKey: "winOrzlose")
 
 */


