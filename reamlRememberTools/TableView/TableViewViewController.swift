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
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var tradTimesLB: UILabel!
    @IBOutlet weak var sumLB: UILabel!
    
    let vc = ViewController()
    
//    let app = UIApplication.shared.delegate as! AppDelegate
//    var viewCotext: NSManagedObjectContext!
    @IBOutlet weak var addNumText: UITextField!
    @IBOutlet weak var addNameText: UITextField!
    @IBOutlet weak var addCountText: UITextField!
    @IBOutlet weak var addBDateText: UITextField!
    @IBOutlet weak var addSDateText: UITextField!
    @IBOutlet weak var addBPriceText: UITextField!
    @IBOutlet weak var addSPricrText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)

        view.backgroundColor = .lightGray
        
        // 設置委任對象
        myTableView.delegate = self
        myTableView.dataSource = self
        
        // 分隔線的樣式
        myTableView.separatorStyle = .none
        
        myTableView.getCorner(cornerItem: myTableView, myCorner: 20, cornerBG: .lightGray)
        
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
    
    @IBAction func addAtn(_ sender: UIBarButtonItem) {
        print("here is bar button")
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
    
    @IBAction func sureAtn(){
        
        let stock = Stock()
        
        stock.number = addNumText.text!
        stock.name = addNameText.text!
        stock.count = addCountText.text!
        stock.buy_date = addBDateText.text!
        stock.sell_date = addSDateText.text!
        stock.buy_price = addBPriceText.text!
        stock.sell_price = addSPricrText.text!
        
        writteInRealm(stock: stock)
        
        addDataView.removeFromSuperview()
    }
    
    func writteInRealm(stock: Stock){
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(stock)
        }
    }
    
}

extension TableViewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let realm = try! Realm()
        
        let myData = realm.objects(Stock.self)
        
        return myData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCellViewController
        
        // 設置 Accessory 按鈕樣式
        cell.accessoryType = .disclosureIndicator
        
        let realm = try! Realm()
        
        let result = realm.objects(Stock.self)

        // 顯示的內容
        let index = result[indexPath.row]
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
        
        let myData = realm.objects(Stock.self)
        
        let name = myData[indexPath.row].name
        print("按下的是 \(name) 的 detail")
    }
    
    // 有幾組 section
    func numberOfSections(in tableView: UITableView) -> Int {
        let realm = try! Realm()
        
        let myData = realm.objects(Stock.self)
        
        return myData.count
    }
    
    // 每個 section 的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = section == 0 ? "籃球" : "棒球"
        return title
    }
    
}
