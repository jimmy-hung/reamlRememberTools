//
//  YearTableViewController.swift
//  reamlRememberTools
//
//  Created by 洪立德 on 2019/1/11.
//  Copyright © 2019 洪立德. All rights reserved.
//

import UIKit
import RealmSwift

class YearTableViewController: UIViewController {
    
    @IBOutlet weak var yearTableView: UITableView!
    var myDataArray : [Int] = []
    @IBOutlet weak var totalTradeLb: UILabel!
    @IBOutlet weak var sumLb: UILabel!
    
    var transitionView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // 設置委任對象
        yearTableView.delegate = self
        yearTableView.dataSource = self
        
        yearTableView.getCorner(cornerItem: yearTableView, myCorner: 30, cornerBG: .white)
        
        // 分隔線的樣式
        yearTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        
        countSumTrade()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if transitionView == true {
            yearTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        transitionView = true
    }
    
    @IBAction func addAtn(_ sender: UIBarButtonItem) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "TableView") as! TableViewViewController
        self.present(nextVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let realm = try! Realm()
        
        let myData = realm.objects(Stock.self)
        
        // 按年份排列資料
        let results = myData.sorted(byKeyPath: "year")
        
        let indexPath = yearTableView.indexPathForSelectedRow ?? []
        let index = results.filter("year = \(results[indexPath.row].year)")    //  [results[indexPath.row]]
        
        if segue.identifier == "goTable"{
            if myDataArray.count != 0 {
                if let nextVC = segue.destination as? TableViewViewController{
                    nextVC.infoDataYear = index.sorted(byKeyPath: "month")
                }
            }
        }
    }
    
    // 計算總交易次數 = 總共幾筆資料
    func countSumTrade(){
        let realm = try! Realm()
        let stock = realm.objects(Stock.self)
        totalTradeLb.text = String(stock.count)
        
        var sum : Double = 0
        
        if stock.count != 0 {
            for i in  0 ... (stock.count - 1) {
                let endPrice = Double(stock[i].count)! * ((Double(stock[i].sell_price)!) - (Double(stock[i].buy_price)!))
                sum = sum + endPrice
            }
            sum = sum * 1000
            
            if sum > 0{
                sumLb.textColor = .red
            }else if sum < 0{
                sumLb.textColor = .green
            }
        }
        sumLb.text = String(Int(sum.roundTo(places: 2)))
    }
    
}


extension YearTableViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let stock = realm.objects(Stock.self)
        
        // 重新獲取資料確保完整性
        myDataArray = []
        if stock.count != 0{
            myDataArray = [stock[0].year]
        }
        
        // 接出realm裡 年 的資料
        if stock.count != 0 {
            for i in 0 ... (stock.count - 1){
                if stock[0].year != stock[i].year{
                    myDataArray.append(stock[i].year)
                }
                // 將陣列從小排到大 ( reverse() 大 - 小 )
                myDataArray.sort()
            }
        }
        
        countSumTrade() // 重置交易次數
        
        // 計算不同年份的數量，列出cell
        var yearSum = 1
        if stock.count != 0 {
            for i in  0 ... (stock.count - 1) {
                if stock[0].year != stock[i].year{
                    yearSum += 1
                }
            }
        }else{
            yearSum = 0
        }
        return yearSum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 取得 tableView 目前使用的 cell
        let yearCell = tableView.dequeueReusableCell(withIdentifier: "YearCell", for: indexPath) as! YearTableViewCell
        
        // 設置 Accessory 按鈕樣式
        yearCell.accessoryType = .disclosureIndicator
    
        // 只顯示有購買記錄的年份
        if myDataArray.count != 0 {
            if indexPath.row == 0{
                yearCell.textLabel?.text = String(myDataArray[0])
                 yearCell.detailTextLabel?.text = ""
            }else{
                yearCell.textLabel?.text = String(myDataArray[indexPath.row])
                 yearCell.detailTextLabel?.text = ""
            }
        }
        return yearCell
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
    
}
