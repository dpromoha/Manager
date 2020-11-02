//
//  FinanceVC.swift
//  Manager
//
//  Created by Daria Pr on 01.10.2020.
//

import UIKit
import Charts
import Firebase

class FinanceVC: UIViewController {
    
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var initFirebase = InitFirebase()
    var finance = [Finance]()
    var copyExpens = [Expenses]()
    var procentCategories = [Double]()
    var finalBalance: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FinanceTableCell.nib(), forCellReuseIdentifier: FinanceTableCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        amountLbl.text = "Balance: \(String(describing: finalBalance))"
        
        if copyExpens.count != 0 {
            customizeChart(dataPoints: initFirebase.categories, values: procentCategories.map{ Double($0) })
        }
    }
    
    @IBAction func clearBtn(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete all data about expenses", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [self] (action) in
            
            initFirebase.initWallet()
            initFirebase.initBalance()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension FinanceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FinanceTableCell.identifier, for: indexPath) as! FinanceTableCell
        cell.configure(with: finance)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

extension FinanceVC {
    func customizeChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        pieChartView.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            colors.append(#colorLiteral(red: 0.4901960784, green: 0.5490196078, blue: 0.7333333333, alpha: 1))
            colors.append(#colorLiteral(red: 0.8549019608, green: 0.7137254902, blue: 0.7843137255, alpha: 1))
            colors.append(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
            colors.append(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
            colors.append(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
            colors.append(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
            colors.append(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
            colors.append(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
            colors.append(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        }
        return colors
    }

    func initExpenses(expArr: [Expenses], balance: Int) {
        let count = expArr.count-1
        copyExpens = expArr
        finalBalance = balance
        
        if copyExpens.count != 0 {
            finance = [Finance(category: "Food", spent: copyExpens[count].food), Finance(category: "Transport", spent: copyExpens[count].transport), Finance(category: "Housing", spent: copyExpens[count].housing), Finance(category: "Clothing", spent: copyExpens[count].clothing), Finance(category: "Cafe", spent: copyExpens[count].cafe), Finance(category: "Health", spent: copyExpens[count].health), Finance(category: "Relax", spent: copyExpens[count].entertainment), Finance(category: "Presents", spent: copyExpens[count].presents), Finance(category: "Other", spent: copyExpens[count].other)]
            
            procentCategories = [Double(copyExpens[count].food), Double(copyExpens[count].transport), Double(copyExpens[count].housing), Double(copyExpens[count].clothing), Double(copyExpens[count].cafe), Double(copyExpens[count].health), Double(copyExpens[count].entertainment), Double(copyExpens[count].presents), Double(copyExpens[count].other)]
            
        }
        
    }
}
