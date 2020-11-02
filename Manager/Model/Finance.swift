//
//  Finance.swift
//  Manager
//
//  Created by Daria Pr on 08.10.2020.
//

import Foundation
import Firebase

struct Finance {
    let category: String
    let spent: Int
    
    init(category: String, spent: Int) {
        self.category = category
        self.spent = spent
    }
}

class SaveFinance {
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser?.email
    
    let categoryArr = ["Food", "Transport", "Housing", "Clothing and footwear", "Cafe or Restaurant", "Health", "Entertainment", "Presents", "Other"]
    
    func countEarned(earn: String, amountBefore: Int) -> Int {
        let tmpFirst = earn
        let tmpSecond = amountBefore
        let first: Int = Int(tmpFirst) ?? 0
        return first + tmpSecond
    }
    
    func countSpent(spent: String, amountBefore: Int) -> Int {
        let tmpFirst = spent
        let first: Int = Int(tmpFirst) ?? 0
        return amountBefore - first
    }
    
    func initFinance() {
        db.collection(user!).document("Balance").setData(["balance": 0]) {  (error) in
            if let e = error {
                print("Problem with init balance, \(e)")
            } else {
                print("SAVE DATA (init)")
            }
        }
        
        db.collection(user!).document("Wallet").setData(["\(categoryArr[0])": 0, "\(categoryArr[1])": 0, "\(categoryArr[2])": 0, "\(categoryArr[3])": 0, "\(categoryArr[4])": 0, "\(categoryArr[5])": 0, "\(categoryArr[6])": 0, "\(categoryArr[7])": 0, "\(categoryArr[8])": 0]) { (error) in
            if let e = error {
                print("Problem with init Wallet, \(e)")
            } else {
                print("SAVE DATA (init)")
            }
        }
    }
    
    func updateBalance(spent: Int) {
        let balance = db.collection(user!).document("Balance")
        
        balance.updateData(["balance": spent]) { (error) in
            if let e = error {
                print("Problem with saving earned, \(e)")
            } else {
                print("SAVE DATA (init)")
            }
        }
    }
    
    func updateWallet(spent: String, category: String?) {
        let wallet = db.collection( user!).document("Wallet")
        
        wallet.updateData(["\(category!)" : Int(spent) ?? 0]) { (error) in
            if let err = error {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
