//
//  Network.swift
//  Manager
//
//  Created by Daria Pr on 26.10.2020.
//

import UIKit

class Network {
    let baseUrl: String = "https://free.currconv.com/api/v7/convert?q="
    let apiKey: String = "&compact=ultra&apiKey=fda72d7ccba9b9584b49"
    
    let currencyArr = ["UAH", "EUR", "USD", "BYN", "CHF", "CNY", "ILS", "THB", "INR", "GBP"]

    func imageCurrency(currency: String) -> UIImage {
        switch currency {
        case "UAH":
            return #imageLiteral(resourceName: "uah")
        case "EUR":
            return #imageLiteral(resourceName: "big-euro-symbol")
        case "USD":
            return #imageLiteral(resourceName: "dollar-symbol")
        case "BYN":
            return #imageLiteral(resourceName: "belarus-ruble-currency-symbol (1)")
        case "CHF":
            return #imageLiteral(resourceName: "swiss-franc")
        case "CNY":
            return #imageLiteral(resourceName: "chinese-yuan")
        case "ILS":
            return #imageLiteral(resourceName: "israel-shekel-currency-symbol (1)")
        case "THB":
            return #imageLiteral(resourceName: "thailand-baht (1)")
        case "INR":
            return #imageLiteral(resourceName: "rupee")
        default:
            return #imageLiteral(resourceName: "pound-sterling")
        }
    }
}
