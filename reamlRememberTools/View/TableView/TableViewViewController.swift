//
//  TableViewViewController.swift
//  rememberTool
//
//  Created by 洪立德 on 2018/11/15.
//  Copyright © 2018 洪立德. All rights reserved.
//

// 價差 = (賣出價格 - 買進價格) * 張數
// edn_price = ([6] - [5]) * [2]


import UIKit
import RealmSwift

class TableViewViewController: UIViewController {
    
    @IBOutlet var addDataView: UIView!
    @IBOutlet var addNumberView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var tradMYearLb: UILabel!
    @IBOutlet weak var tradTimesLB: UILabel!
    @IBOutlet weak var sumLB: UILabel!
    
    let vc = ViewController()
    let realmAction = RealmAction()
    let monthArray = ["一"," 二","三","四","五","六","七","八","九","十","十一","十二"]
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var addNumText: UITextField!
    @IBOutlet weak var addNameText: UITextField!
    @IBOutlet weak var addCountText: UITextField!
    @IBOutlet weak var addBDateText: UITextField!
    @IBOutlet weak var addSDateText: UITextField!
    @IBOutlet weak var addBPriceText: UITextField!
    @IBOutlet weak var addSPricrText: UITextField!
    
    @IBOutlet var collectLB: [UILabel]!
    var clearView = false
    var recordYear = ""
    var recordMonth = ""
    
    let addCropView = UIView()
    @IBOutlet var addGestureBtn: UITapGestureRecognizer!
    @IBOutlet weak var sureBtn: UIButton!
    
    var transition = false
    var buy_sell_date = 0
    
    var infoDataYear:Results<Stock>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 顯示 realm dataBase 路徑位置
        print(Realm.Configuration.defaultConfiguration.fileURL)

        // 設置委任對象
        myTableView.delegate = self
        myTableView.dataSource = self
        
        // 分隔線的樣式
        myTableView.separatorStyle = .none
        
        myTableView.getCorner(cornerItem: myTableView, myCorner: 20, cornerBG: .white)
        myTableView.backgroundColor = UIColor.clear
        view.addVerticalGradientLayer(topColor: .blue, bottomColor: .white)
        
        if infoDataYear != nil{
            countSumTrade()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if transition == true{
            view.alpha = 0
            UIView.animate(withDuration: 0.8) {
                self.view.alpha = 1
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        transition = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = myTableView.indexPathForSelectedRow ?? []
        let index = [infoDataYear[indexPath.row]]
    
        if segue.identifier == "goDetail"{
            if let nextVC = segue.destination as? DetailViewController{
                nextVC.infoData = index
            }
        }
    }
    
    @IBAction func addAtn(_ sender: UIButton) {
        // insert xib
        if (Bundle.main.loadNibNamed("addData", owner: self, options: nil)?.first as? addData) != nil
        {
            addDataView.frame.size.width = view.frame.size.width * 0.8
            addDataView.frame.size.height = view.frame.size.height * 0.6
            addDataView.frame.origin.x = self.view.frame.size.width * 0.2 / 2
            addDataView.frame.origin.y = self.view.frame.size.height * 0.4 / 2
            
            addDataView.getCorner(cornerItem: addDataView, myCorner: 30, cornerBG: .white)
            
            addCropView.frame = view.frame ; addCropView.alpha = 0.6
            addCropView.addVerticalGradientLayer(topColor: .blue, bottomColor: .white)
            self.view.addSubview(addCropView)
            self.view.addSubview(addDataView)
            addCropView.addGestureRecognizer(addGestureBtn)
        }
        
        addBDateText.delegate = self
        addSDateText.delegate = self
        
        for i in 0...collectLB.count-1{
            collectLB[i].adjustsFontSizeToFitWidth = true
        }

        sureBtn.alpha = 0
        clearView = true
    }
    
    @IBAction func selectMonthAtn(_ sender: UIButton) {
        
        // insert xib
        if (Bundle.main.loadNibNamed("addNumber", owner: self, options: nil)?.first as? addNumber) != nil
        {
            addNumberView.frame.size.width = view.frame.size.width * 0.8
            addNumberView.frame.size.height = view.frame.size.height * 0.6
            addNumberView.frame.origin.x = self.view.frame.size.width * 0.2 / 2
            addNumberView.frame.origin.y = self.view.frame.size.height * 0.4 / 2
            
            addNumberView.getCorner(cornerItem: addNumberView, myCorner: 60, cornerBG: .white)
            self.view.addSubview(addNumberView)
        }
        
        if sender.tag == 0 { buy_sell_date = 0 }
        else if sender.tag == 1 { buy_sell_date = 1 }
        
    }
    
    @IBAction func dateDoneAtn(_ sender: UIButton) {
        addNumberView.removeFromSuperview()
    }
    
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        let dateValue = DateFormatter() ; let yearValue = DateFormatter() ; let monthValue = DateFormatter()
        dateValue.dateFormat = "YYYY.MM.dd"
        yearValue.dateFormat = "YYYY"
        monthValue.dateFormat = "MM"
        
        if buy_sell_date == 0 {
            addBDateText.text = dateValue.string(from: datePicker.date)
            recordYear = yearValue.string(from: datePicker.date)
            recordMonth = monthValue.string(from: datePicker.date)
        }else if buy_sell_date == 1 {
            addSDateText.text = dateValue.string(from: datePicker.date)
        }
        
    }
    
    
    @IBAction func sureAtn(){
        
        let stock = Stock()
        stock.year = Int(recordYear)!
        stock.month = Int(recordMonth)!
        stock.number = addNumText.text!
        stock.name = addNameText.text!
        stock.count = addCountText.text!
        stock.buy_date = addBDateText.text!
        stock.sell_date = addSDateText.text!
        stock.buy_price = addBPriceText.text!
        stock.sell_price = addSPricrText.text!
    
        realmAction.writteInRealm(stock: stock)
        
        myTableView.reloadData()
        
        if infoDataYear != nil{
            countSumTrade()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 2, animations: {
                self.addCropView.removeFromSuperview()
                self.addDataView.removeFromSuperview()
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    // 計算總交易次數 = 總共幾筆資料
    func countSumTrade(){
//        let realm = try! Realm()
//        let stock = realm.objects(Stock.self)
        tradMYearLb.text = String(infoDataYear![0].year)
        tradTimesLB.text = String(infoDataYear!.count)
        
        var sum : Double = 0
        
        if infoDataYear!.count != 0 {
            for i in  0 ... (infoDataYear!.count - 1) {
                let endPrice = Double(infoDataYear![i].count)! * ((Double(infoDataYear![i].sell_price)!) - (Double(infoDataYear![i].buy_price)!))
                sum = sum + endPrice
            }
            sum = sum * 1000
            
            if sum > 0{
                sumLB.textColor = .red
            }else if sum < 0{
                sumLB.textColor = .green
            }
        }
        sumLB.text = String(Int(sum.roundTo(places: 2)))
    }

    @IBAction func dissmissViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addGesture(_ sender: UITapGestureRecognizer) {
        if clearView == true{
            addAlert(titleContent: "貼心提醒", messageContent: "是否確定結束編輯", isWhitch: "A")
        }
    }
    
    @IBAction func addGestureCheckData(_ sender: UITapGestureRecognizer) {
        if addNumText.text != "" && addNameText.text != "" && addCountText.text != "" && addBDateText.text != "" && addSDateText.text != "" && addBPriceText.text != "" && addSPricrText.text != "" {
            sureBtn.alpha = 1
        }
    }
    
    
    func addAlert (titleContent: String, messageContent: String, isWhitch: String)
    {
        let alertController = UIAlertController(title: titleContent, message: messageContent, preferredStyle: .alert)

        if isWhitch == "A"{
            let secAction = UIAlertAction(title: "sure", style: .cancel) { (alertAction) in
                self.addDataView.removeFromSuperview()
                self.addCropView.removeFromSuperview()
                self.clearView = false
            }
            
            let setAction = UIAlertAction(title: "no", style: .default) { (alertAction) in
                self.clearView = true
            }
            
            alertController.addAction(secAction)
            alertController.addAction(setAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else if isWhitch == "B" {
            let secAction = UIAlertAction(title: "sure", style: .cancel) { (alertAction) in
                
            }
            alertController.addAction(secAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func checkoutTxt(_ sender: UITextField) {
        
        switch sender.tag {
        case 1:
            checkLong(sender: sender, howLong: 4)
            if Int(sender.text!) == nil{addAlert(titleContent: "錯誤", messageContent: "請輸入四位數股號", isWhitch: "B") ; sender.text = "" }
        case 3:
            if Int(sender.text!) == nil{addAlert(titleContent: "錯誤", messageContent: "請輸入股票張數", isWhitch: "B") ; sender.text = "" }
        case 6:
            if Float(sender.text!) == nil{addAlert(titleContent: "錯誤", messageContent: "請確認資料內容", isWhitch: "B") ; sender.text = "" }
        case 7:
            if Float(sender.text!) == nil{addAlert(titleContent: "錯誤", messageContent: "請確認資料內容", isWhitch: "B") ; sender.text = "" }
        default:
            print("")
        }
        
    }
}

extension TableViewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if infoDataYear != nil{
            return infoDataYear.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCellViewController
        
        // 設置 Accessory 按鈕樣式
        cell.accessoryType = .disclosureIndicator
        
        infoDataYear = infoDataYear.sorted(byKeyPath: "month")
        
        let useInfo = infoDataYear[indexPath.row]
        
        // 顯示的內容
        if cell.textLabel != nil {

            let count = Double(useInfo.count)!
            let sell_price = Double(useInfo.sell_price)!
            let buy_price = Double(useInfo.buy_price)!

            let endPrice = count * (sell_price - buy_price)

            cell.nameLB.text = "\(useInfo.name)" //"\(index[0])"
            cell.numberLB.text = "\(useInfo.number)" //"\(index[1])"
            cell.countLB.text = "\(useInfo.count)" //"\(index[2])"
            cell.end_priceLB.text = "\(endPrice.roundTo(places: 2))" //"\(index[3])"
        }
        
        return cell

    }
    
    // 有幾組 section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // 每個 section 的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = "1.股名        " + "2.股號       " + "3.張數    " + "4.總價差"
        return title
    }
    
    // cell 右滑刪除
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        realmAction.deleteRealm(stock: infoDataYear[indexPath.row])
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}

extension TableViewViewController: UITextFieldDelegate {
 
    func checkLong (sender: UITextField, howLong: Int) {
        sender.delegate = self
        if (sender.text?.count)! <= howLong{  }
        else if (sender.text?.count)! > howLong {
            sender.text = ""
            addAlert(titleContent: "注意", messageContent: "不可超過四位數", isWhitch: "B")
        }
    }
    
    // 限制不讓編輯日期格式
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag{
        case 4:
            return false
        case 5:
            return false
        default:
            return true
        }
    }

}
