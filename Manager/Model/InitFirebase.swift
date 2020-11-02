//
//  InitFirebase.swift
//  Manager
//
//  Created by Daria Pr on 01.11.2020.
//

import Foundation
import Firebase

class InitFirebase {
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    let id = Auth.auth().currentUser!.uid
    
    var motivationArr: [String] = ["“Everything you can imagine is real.”― Pablo Picasso", "“Do one thing every day that scares you.”― Eleanor Roosevelt", "“Impossible is just an opinion.” – Paulo Coelho", "“If something is important enough, even if the odds are stacked against you, you should still do it.” – Elon Musk", "“Everything comes to him who hustles while he waits.”― Thomas Edison", "“How wonderful it is that nobody need wait a single moment before starting to improve the world.” – Anne Frank", "“Work hard in silence, let your success be the noise.” – Frank Ocean"]
    
    let categories: [String] = ["Food", "Transport", "Housing", "Clothing", "Cafe", "Health", "Relax", "Presents", "Other"]

    func deleteDoc(task: String) {
        db.collection(user!).document(task).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func changePassword(oldPassword: String) {
        Auth.auth().currentUser?.updatePassword(to: oldPassword) { (error) in
            if let e = error {
                print(e)
            } else {
                print("change password")
            }
        }
    }
    
    func changeEmail(email: String) {
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if let e = error {
                print(e)
            } else {
                print("CHANGE EMAIL")
            }
        })
    }
    
    func initWallet() {
        let initWallet = db.collection(user!).document("Wallet")
        
        initWallet.updateData([
            "Food" : 0, "Transport" : 0, "Housing" : 0, "Clothing and footwear" : 0, "Cafe or Restaurant" : 0, "Health" : 0, "Entertainment" : 0, "Presents" : 0, "Other" : 0
        ]) { err in
            if let err = err {
                print("Error updating document after cleaning: \(err)")
            } else {
                print("Document successfully updated after cleaning")
            }
        }
    }
    
    func initBalance() {
        let initBalance = db.collection(user!).document("Balance")
        
        initBalance.updateData(["balance": 0]) { err in
            if let err = err {
                print("Error updating document after cleaning: \(err)")
            } else {
                print("Document successfully updated after cleaning")
            }
        }
    }
    
    func updateIncomplete(focus: Int) {
        let focusDoc = db.collection(user!).document("Focus")
        
        focusDoc.updateData(["incomplete": focus]) { (error) in
            if let err = error {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func updateCompleteFocus(focusArr: [Focus]) {
        let focus = db.collection(user!).document("Focus")
        
        focus.updateData(["amount": focusArr[0].amount, "completeSmall": focusArr[0].completeSmall, "completeMedium": focusArr[0].completeMedium, "completeLarge": focusArr[0].completeLarge]) { (error) in
            if let err = error {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
