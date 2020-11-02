//
//  SaveFinanceVC.swift
//  Manager
//
//  Created by Daria Pr on 08.10.2020.
//

import UIKit
import Firebase

class SaveFinanceVC: UIViewController {
    
    let saveFinance = SaveFinance()
    var selectedCategory: String?
    
    @IBOutlet weak var earnedTextField: UITextField!
    @IBOutlet weak var spentTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var finalAmount: Int = 0
    var expensesArr = [Expenses]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        checkInitDocument()
        selectedCategory = saveFinance.categoryArr[0]
    }
    
    @IBAction func toWalletBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toWallet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? FinanceVC {
            forFinanceLoad()
            print("prepare \(expensesArr)")
            destinationVC.initExpenses(expArr: expensesArr, balance: finalAmount)
        }
    }
    
    @IBAction func saveEarned(_ sender: UIButton) {
        if earnedTextField.text != "" {
            let earn: Int = saveFinance.countEarned(earn: earnedTextField.text ?? "0", amountBefore: finalAmount)
            finalAmount = earn
            
            saveFinance.updateBalance(spent: earn)
            self.earnedTextField.text = ""
            self.takeData()
        } else {
            let alert = UIAlertController(title: "EMPTY", message: "Сan you please write your amount of income", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveSpent(_ sender: UIButton) {
        takeData()
        if spentTextField.text != "" {
            let spent: Int = saveFinance.countSpent(spent: spentTextField.text ?? "0", amountBefore: finalAmount)
            
            saveFinance.updateBalance(spent: spent)
            saveFinance.updateWallet(spent: spentTextField.text ?? "0", category: selectedCategory)
            self.spentTextField.text = ""
            self.takeData()
            self.forFinanceLoad()
        } else {
            let alert = UIAlertController(title: "EMPTY", message: "Сan you please write your amount of expense", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

extension SaveFinanceVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return saveFinance.categoryArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return saveFinance.categoryArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = saveFinance.categoryArr[row]
    }
    
}

extension SaveFinanceVC {
    
    func checkBalanceDocument() {
        let docRefSecond = saveFinance.db.collection(saveFinance.user!).document("Balance")
        
        docRefSecond.getDocument { (doc, error) in
            if let doc = doc {
                if doc.exists {
                    self.takeData()
                } else {
                    self.saveFinance.initFinance()
                }
            }
        }
    }
    
    func checkInitDocument() {
        checkBalanceDocument()
        let docRef = saveFinance.db.collection(saveFinance.user!).document("Wallet")
        
        docRef.getDocument { (doc, error) in
            if let doc = doc {
                if doc.exists {
                    self.forFinanceLoad()
                } else {
                    self.saveFinance.initFinance()
                }
            }
        }
    }
    
    func takeData() {
        saveFinance.db.collection(saveFinance.user!)
            .addSnapshotListener { (querySnapshot, error) in

                if let e = error {
                    print("Problem with retrieving data \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let amount = data["balance"] as? Int {
                                self.finalAmount = amount
                            }
                        }
                    }
                }
            }
    }
    
    func forFinanceLoad() {
        saveFinance.db.collection(saveFinance.user!)
            .addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("Problem with retrieving data \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let food = data["Food"] as? Int, let tr = data["Transport"] as? Int, let housing = data["Housing"] as? Int, let cl = data["Clothing and footwear"] as? Int, let cafe = data["Cafe or Restaurant"] as? Int, let h = data["Health"] as? Int, let ent = data["Entertainment"] as? Int, let pr = data["Presents"] as? Int, let ot = data["Other"] as? Int {
                                DispatchQueue.main.async {
                                    let newExpenses = Expenses(food: food, transport: tr, housing: housing, clothing: cl, cafe: cafe, health: h, entertainment: ent, presents: pr, other: ot)
                                    self.expensesArr.append(newExpenses)
                                }
                            }
                        }
                    }
                }
            }
    }
}
