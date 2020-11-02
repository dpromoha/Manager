//
//  StatisticVC.swift
//  Manager
//
//  Created by Daria Pr on 21.10.2020.
//

import UIKit
import Charts

class StatisticVC: UIViewController {
    
    var copyFocus = [Focus]()
    var session = [Double]()
    var procentSession = [Double]()
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var pieChartViewSecond: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeChart(dataPoints: ["Success" , "Failure"], values: session.map{ Double($0) })
        customizeChartSecond(dataPoints: ["15 min", "25 min", "35 min"], values: procentSession.map{ Double($0) })
    }
    
    func initFocusStatistic(arr: [Focus]) {
        copyFocus = arr
        
        session = [Double(copyFocus[0].amount), Double(copyFocus[0].incomplete)]

        procentSession = [Double(copyFocus[0].completeSmall), Double(copyFocus[0].completeMedium), Double(copyFocus[0].completeLarge)]
    }
    
}

extension StatisticVC {
    func customizeChartSecond(dataPoints: [String], values: [Double]) {

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
         pieChartViewSecond.data = pieChartData
    }

    
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
          let color1 = #colorLiteral(red: 0.4901960784, green: 0.5490196078, blue: 0.7333333333, alpha: 1)
          let color2 = #colorLiteral(red: 0.7803921569, green: 0.4784313725, blue: 0.5490196078, alpha: 1)
          let color3 = #colorLiteral(red: 0.3450980392, green: 0.4235294118, blue: 0.568627451, alpha: 1)
          colors.append(color1)
          colors.append(color2)
          colors.append(color3)
        }
        return colors
    }
}
