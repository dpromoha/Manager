//
//  CurrencyExchangeVC.swift
//  Manager
//
//  Created by Daria Pr on 08.10.2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class CurrencyExchangeVC: UIViewController {
    
    var network = Network()
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyResult: UILabel!
    @IBOutlet weak var currencyImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        fetchCurrency(currencyFirst: network.currencyArr[0], currencySecond: network.currencyArr[0])
        currentDate()
    }
    
    func currentDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        dateLbl.text = formatter.string(from: date)
    }
}

extension CurrencyExchangeVC {
    func fetchCurrency(currencyFirst: String, currencySecond: String) {

        let convertTo: String = "\(currencyFirst)_\(currencySecond)"

        AF.request(network.baseUrl+convertTo+network.apiKey, method: .get).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let rate: Double = json[convertTo].double!

                DispatchQueue.main.async {
                    self.currencyResult.text = String(rate)
                    self.currencyImage.image = self.network.imageCurrency(currency: currencySecond)
                }
            case .failure(let error):
                print(error)
                self.alertFail(title: "Server 503", message: "No server is available to handle this request")
            }
        })
    }

    func alertFail(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
}

extension CurrencyExchangeVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return network.currencyArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return network.currencyArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var firstComponent: String = network.currencyArr[0]
        var secondComponent: String = network.currencyArr[0]
        
        if component == 0 {
            firstComponent = network.currencyArr[row]
        } else if component == 1 {
            secondComponent = network.currencyArr[row]
        }
        fetchCurrency(currencyFirst: firstComponent, currencySecond: secondComponent)
    }
}
