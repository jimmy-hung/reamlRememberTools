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

    @IBOutlet weak var YearTableView: UITableView!
    var myDataArray : [Int] = []
    var enCourageArray : [String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        let stock = realm.objects(Stock.self)
        
        view.backgroundColor = .lightGray
        
        // 設置委任對象
        YearTableView.delegate = self
        YearTableView.dataSource = self
        
        YearTableView.getCorner(cornerItem: YearTableView, myCorner: 30, cornerBG: .white)
        
        // 分隔線的樣式
        YearTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        
        enCourageArray = ["加油","繼續保持","努力","你很利害","投資自己","最對的事","看仔細","用點心","你的成功","我看得見","COOL","WONDERFUL","加油","繼續保持","努力","你很利害","投資自己","最對的事","看仔細","用點心","你的成功","我看得見","COOL","WONDERFUL","加油","繼續保持","努力","你很利害","投資自己","最對的事","看仔細","用點心","你的成功","我看得見","COOL","WONDERFUL","加油","繼續保持","努力","你很利害","投資自己","最對的事","看仔細","用點心","你的成功","我看得見","COOL","WONDERFUL","加油","繼續保持","努力","你很利害","投資自己","最對的事","看仔細","用點心","你的成功","我看得見","COOL","WONDERFUL","加油","繼續保持","努力","你很利害","投資自己","最對的事","看仔細","用點心","你的成功","我看得見","COOL","WONDERFUL"]
        
        if stock.count != 0{
             myDataArray = [stock[0].year]
        }
       
        if stock.count != 0 {
            for i in 0 ... (stock.count - 1){
                if stock[0].year != stock[i].year{
                    myDataArray.append(stock[i].year)
                }
                // 將陣列從小排到大 ( reverse() 大 - 小 )
                myDataArray.sort()
            }
        }
    }
    
    @IBAction func addAtn(_ sender: UIBarButtonItem) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "TableView") as! TableViewViewController
        self.present(nextVC, animated: true, completion: nil)
    }
    
}


extension YearTableViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 取得 tableView 目前使用的 cell
        let yearCell = tableView.dequeueReusableCell(withIdentifier: "YearCell", for: indexPath) as! YearTableViewCell
        
        // 設置 Accessory 按鈕樣式
        yearCell.accessoryType = .disclosureIndicator
    
        // 只顯示有購買記錄的年份
        if myDataArray.count != 0 {
            for i in 0 ... (myDataArray.count - 1){
                if indexPath.row == 0{
                    yearCell.textLabel?.text = String(myDataArray[0])
                    yearCell.detailTextLabel?.text = enCourageArray[i]
                }else{
                    yearCell.textLabel?.text = String(myDataArray[i])
                    yearCell.detailTextLabel?.text = enCourageArray[i]
                }
            }
        }else{
            yearCell.textLabel?.text = "請輸入資料"
            yearCell.detailTextLabel?.text = "現在 立刻 馬上"
        }
        return yearCell
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
