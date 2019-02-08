//
//  DetailViewController.swift
//  rememberTool
//
//  Created by 洪立德 on 2018/11/16.
//  Copyright © 2018 洪立德. All rights reserved.


import UIKit
import RealmSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var numberLB: UILabel!
    @IBOutlet weak var countLB: UILabel!
    @IBOutlet weak var end_priceLB: UILabel!
    @IBOutlet weak var buy_dateLB: UILabel!
    @IBOutlet weak var sell_dateLB: UILabel!
    @IBOutlet weak var buy_priceLB: UILabel!
    @IBOutlet weak var sell_priceLB: UILabel!
    @IBOutlet weak var resultLB: UILabel!
    
    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var editNumber: UITextField!
    @IBOutlet weak var editCount: UITextField!
    @IBOutlet weak var editBuy_price: UITextField!
    @IBOutlet weak var editBuy_date: UITextField!
    @IBOutlet weak var editSell_price: UITextField!
    @IBOutlet weak var editSell_date: UITextField!
    @IBOutlet var editView: UIView!
    @IBOutlet var editNumberView: editNumber!
    @IBOutlet weak var changedDateBtn: UIDatePicker!
    let addCropView = UIView()
    let realmAction = RealmAction()
    
    var infoData:[Stock]! = []
    
    let realm = try! Realm()
    
    let uponView = TableViewViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        showMyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        
        let a = formatter.date(from: infoData[0].sell_date)!  // 賣出日期
        let b = formatter.date(from: infoData[0].buy_date)!  // 買入日期
        
        let days = b.daysBetweenDate(toDate: a)
        
        resultLB.adjustsFontSizeToFitWidth = true
        resultLB.text = "經過 \(String(describing: days)) 天，總共獲取 \((Int(spread() * 1000))) 金額"
    }
        
    func showMyData(){
        
        nameLB.text = infoData[0].name
        numberLB.text = infoData[0].number
        countLB.text = infoData[0].count
        end_priceLB.text = String(spread())
        buy_dateLB.text = infoData[0].buy_date
        sell_dateLB.text = infoData[0].sell_date
        buy_priceLB.text = infoData[0].buy_price
        sell_priceLB.text = infoData[0].sell_price
    }
    
    func spread() -> Double{
        
        let a = Double(infoData[0].sell_price)  // 賣出價格
        let b = Double(infoData[0].buy_price)   // 買入價格
        let c = Double(infoData[0].count)       // 張數
        
        let spread = (( a! - b! ) * c!).roundTo(places: 2)
        
        return spread
    }
    
    @IBAction func backAtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.8) {
            self.view.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func editAtn(_ sender: UIButton) {
       
        if (Bundle.main.loadNibNamed("editData", owner: self, options: nil)?.first as? editData) != nil {
            
            editView.frame.size.width = view.frame.size.width * 0.8
            editView.frame.size.height = view.frame.size.height * 0.6
            editView.frame.origin.x = self.view.frame.size.width * 0.2 / 2
            editView.frame.origin.y = self.view.frame.size.height * 0.4 / 2
            editView.getCorner(cornerItem: editView, myCorner: 30, cornerBG: .white)
            
            self.view.addSubview(editView)
            showEditData()
            
            editName.delegate = self
            editNumber.delegate = self
            editSell_date.delegate = self
            editBuy_date.delegate = self
        }
    }
    
    @IBAction func checkoutTxt(_ sender: UITextField) {
        
        switch sender.tag {
        case 1:
            checkLong(sender: sender, howLong: 4)
            if Int(sender.text!) == nil{addAlert(titleContent: "錯誤", messageContent: "請輸入四位數股號") ; sender.text = "" }
        case 3:
            if Int(sender.text!) == nil{addAlert(titleContent: "錯誤", messageContent: "請輸入股票張數") ; sender.text = "" }
        case 6:
            if Float(sender.text!) == nil{addAlert(titleContent: "錯誤", messageContent: "請確認資料內容") ; sender.text = "" }
        case 7:
            if Float(sender.text!) == nil{addAlert(titleContent: "錯誤", messageContent: "請確認資料內容") ; sender.text = "" }
        default:
            print("")
        }
    }
    
    func showEditData(){
        editName.text = nameLB.text
        editNumber.text = numberLB.text
        editCount.text = countLB.text
        editBuy_price.text = buy_priceLB.text
        editBuy_date.text = buy_dateLB.text
        editSell_price.text = sell_priceLB.text
        editSell_date.text = sell_dateLB.text
    }
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        addAlert(titleContent: "系統提示", messageContent: "確定要提前結束編輯嗎")
    
    }
    
    func addAlert (titleContent: String, messageContent: String){
       
        let alertController = UIAlertController(title: titleContent, message: messageContent, preferredStyle: .alert)
        
        let firAction = UIAlertAction(title: "no", style: .default, handler: nil)
        let secAction = UIAlertAction(title: "sure", style: .cancel) { (alertAction) in
                if messageContent == "確定要提前結束編輯嗎" {
                    UIView.animate(withDuration: 0.8, animations: {
                        self.editView.alpha = 0
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.editView.removeFromSuperview()
                    })
                }
            }
        
            alertController.addAction(secAction)
            alertController.addAction(firAction)
            self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editSureAtn(_ sender: UIButton) {
        
        let realm = try! Realm()
        let editMyData = realm.objects(Stock.self).filter("buy_date = '\(buy_dateLB.text!)' AND number = '\(numberLB.text!)'")
        
        let editData = Stock()
        editData.name = "\(editName.text!)"
        editData.number = "\(editNumber.text!)"
        editData.count = "\(editCount.text!)"
        editData.buy_date = "\(editBuy_date.text!)"
        editData.sell_date = "\(editSell_date.text!)"
        editData.buy_price = "\(editBuy_price.text!)"
        editData.sell_price = "\(editSell_price.text!)"
        editData.year = infoData[0].year
        editData.month = infoData[0].month
        editData.id = "\(editMyData[0].id)"
        
        realmAction.upDate(data: editData)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.editView.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.25) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func addDateAtn(_ sender: UIButton) {
        if ((Bundle.main.loadNibNamed("editNumber", owner: self, options: nil)?.first as? editNumber) != nil) {
            editNumberView.frame.size.width = view.frame.size.width * 0.8
            editNumberView.frame.size.height = view.frame.size.height * 0.6
            editNumberView.frame.origin.x = self.view.frame.size.width * 0.2 / 2
            editNumberView.frame.origin.y = self.view.frame.size.height * 0.4 / 2
            editNumberView.getCorner(cornerItem: editNumberView, myCorner: 30, cornerBG: .white)
            
            self.view.addSubview(editNumberView)
        }
    }
    
    @IBAction func addDateCanlander(_ sender: UIDatePicker) {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "YYYY.MM.dd"
        editSell_date.text = dateValue.string(from: changedDateBtn.date)
    }
    
    @IBAction func sureDateAtn(_ sender: UIButton){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
            self.editNumberView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.editNumberView.removeFromSuperview()
        }
    }
}

extension DetailViewController: UITextFieldDelegate {
    
    func checkLong (sender: UITextField, howLong: Int) {
        sender.delegate = self
        if (sender.text?.count)! <= howLong{  }
        else if (sender.text?.count)! > howLong {
            sender.text = ""
            addAlert(titleContent: "注意", messageContent: "不可超過四位數")
        }
    }
    
    // 限制不讓編輯日期格式
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag{
        case 1:
            return false
        case 2:
            return false
        case 4:
            return false
        case 5:
            return false
        default:
            return true
        }
    }
}
