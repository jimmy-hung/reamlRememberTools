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
    @IBOutlet weak var tradTimesLB: UILabel!
    @IBOutlet weak var sumLB: UILabel!
    
    let vc = ViewController()
    let monthArray = ["一"," 二","三","四","五","六","七","八","九","十","十一","十二"]
    
    @IBOutlet weak var addNumText: UITextField!
    @IBOutlet weak var addNameText: UITextField!
    @IBOutlet weak var addCountText: UITextField!
    @IBOutlet weak var addBDateText: UITextField!
    @IBOutlet weak var addSDateText: UITextField!
    @IBOutlet weak var addBPriceText: UITextField!
    @IBOutlet weak var addSPricrText: UITextField!
    
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var monthLB: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 顯示 realm dataBase 路徑位置
        print(Realm.Configuration.defaultConfiguration.fileURL)

        view.backgroundColor = .lightGray

        // 設置委任對象
        myTableView.delegate = self
        myTableView.dataSource = self
        
        // 分隔線的樣式
        myTableView.separatorStyle = .none
        
        myTableView.getCorner(cornerItem: myTableView, myCorner: 20, cornerBG: .lightGray)
        
        countSumTrade()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let realm = try! Realm()
        
        let myData = realm.objects(Stock.self)
        
        let indexPath = myTableView.indexPathForSelectedRow ?? []
        let index = [myData[indexPath.row]]

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
            self.view.addSubview(addDataView)
        }
    }

    
    @IBAction func selectMonthAtn(_ sender: UIButton) {
        
        // insert xib
        if (Bundle.main.loadNibNamed("addNumber", owner: self, options: nil)?.first as? addNumber) != nil
        {
            addNumberView.frame.size.width = view.frame.size.width * 0.8
            addNumberView.frame.size.height = view.frame.size.height * 0.6
            addNumberView.frame.origin.x = self.view.frame.size.width * 0.2 / 2
            addNumberView.frame.origin.y = self.view.frame.size.height * 0.4 / 2
            
            addNumberView.getCorner(cornerItem: addNumberView, myCorner: 60, cornerBG: .yellow)
            self.view.addSubview(addNumberView)

        }
        
    }
    
    @IBAction func sureMonthAtn(_ sender: UIButton) {
        switch sender.tag {
        default:
            checkoutBtn(sender: sender)
        }
    }
    
    func checkoutBtn(sender: UIButton){
        sender.getCorner(cornerItem: sender, myCorner: 30, cornerBG: .white)
        sender.backgroundColor = .white
        
        monthLB.text = String(sender.tag)
        UIView.animate(withDuration: 3) {
            self.addNumberView.alpha = 0
        }
    }
    
    
    
    @IBAction func sureAtn(){
        
        let stock = Stock()
        
        stock.year = Int(yearText.text!)!
        stock.month = Int(monthLB.text!)!
        stock.number = addNumText.text!
        stock.name = addNameText.text!
        stock.count = addCountText.text!
        stock.buy_date = addBDateText.text!
        stock.sell_date = addSDateText.text!
        stock.buy_price = addBPriceText.text!
        stock.sell_price = addSPricrText.text!
        
        
        
        writteInRealm(stock: stock)
        
        myTableView.reloadData()
        
        countSumTrade()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 2, animations: {
                self.addDataView.removeFromSuperview()
            })
        }
    }
    
    // 計算總交易次數 = 總共幾筆資料
    func countSumTrade(){
        let realm = try! Realm()
        let stock = realm.objects(Stock.self)
        tradTimesLB.text = String(stock.count)
        
        var sum : Double = 0
        
        if stock.count != 0 {
            for i in  0 ... (stock.count - 1) {
                let endPrice = Double(stock[i].count)! * ((Double(stock[i].sell_price)!) - (Double(stock[i].buy_price)!))
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
    
    func writteInRealm(stock: Stock){
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(stock)
        }
    }
    
    func showTheSumTrad(){
        
    }
    
    @IBAction func dissmissViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension TableViewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let realm = try! Realm()
        
        let stock = realm.objects(Stock.self)
        
        return stock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCellViewController
        
        // 設置 Accessory 按鈕樣式
        cell.accessoryType = .disclosureIndicator
        
        let realm = try! Realm()

        let stock = realm.objects(Stock.self)

        // 顯示的內容
        let index = stock[indexPath.row]
        if cell.textLabel != nil {

            let count = Double(index.count)!
            let sell_price = Double(index.sell_price)!
            let buy_price = Double(index.buy_price)!

            let endPrice = count * (sell_price - buy_price)

            cell.nameLB.text = "\(index.name)" //"\(index[0])"
            cell.numberLB.text = "\(index.number)" //"\(index[1])"
            cell.countLB.text = "\(index.count)" //"\(index[2])"
            cell.end_priceLB.text = "\(endPrice.roundTo(places: 2))" //"\(index[3])"
        }
        
        return cell

    }
    
    // 點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)

        let realm = try! Realm()

        let myData = realm.objects(Stock.self)

        let name = myData[indexPath.row].name
//        let name = info[indexPath.section][indexPath.row]
        print("選擇的是 \(name)")
    }

    // 點選 Accessory 按鈕後執行的動作
    // 必須設置 cell 的 accessoryType
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        let realm = try! Realm()

        let stock = realm.objects(Stock.self)

        let name = stock[indexPath.row].name
        print("按下的是 \(name) 的 detail")
    }

    // 有幾組 section
    func numberOfSections(in tableView: UITableView) -> Int {
        let realm = try! Realm()
        let stock = realm.objects(Stock.self)

        var yearSum = 1
        if stock.count != 0 {
            for i in  0 ... (stock.count - 1) {
                if stock[0].year != stock[i].year{
                    yearSum += 1
                }
            }
        }
        
        return yearSum
    }

    // 每個 section 的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let realm = try! Realm()
//        let stock = realm.objects(Stock.self)
        
        let title = section == 0 ? "DOG" : "CAT"
        
        return title
    }
    
}
