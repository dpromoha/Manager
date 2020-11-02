//
//  FocusVC.swift
//  Manager
//
//  Created by Daria Pr on 12.10.2020.
//

import UIKit
import Firebase

class FocusVC: UIViewController {
    
    @IBOutlet weak var motivationLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var initFirebase = InitFirebase()
    var focusArr = [Focus]()
    var timer = Timer()
    
    var focusSession: Bool = false
    var minutesFocus: Int = 15
    var secondsPassed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
        
        checkInitDocument()
    }
    
    @IBAction func statisticBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "focusToStatistic", sender: self)
    }
    
    @IBAction func timeChoose(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            minutesFocus = 15
        } else if sender.selectedSegmentIndex == 1 {
            minutesFocus = 25
        } else if sender.selectedSegmentIndex == 2 {
            minutesFocus = 35
        }
    }
    
    @IBAction func startBtn(_ sender: UIButton) {
        if focusSession == false {
            focusSession = true
            startBtn.setImage(#imageLiteral(resourceName: "pause (1)"), for: .normal)
            motivationLbl.text = initFirebase.motivationArr.randomElement()
            startTimer()
        }
    }
    
    @IBAction func giveUpBtn(_ sender: UIButton) {
        if focusSession == true {
            startBtn.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            timer.invalidate()
            minutesFocus = 15
            progressView.progress = 0
            
            let alert = UIAlertController(title: "Fail", message: "Don`t worry!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            initFirebase.updateIncomplete(focus: focusArr[0].incomplete + 1)
            takeData()
            focusSession = false
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo:nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsPassed < minutesFocus {
            secondsPassed += 1
            progressView.progress = Float(secondsPassed) / Float(minutesFocus)
        } else {
            timer.invalidate()
            
            let alert = UIAlertController(title: "Success", message: "Good job!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
            updateComplete()
            startBtn.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            secondsPassed = 0
            progressView.progress = 0
            focusSession = false
        }
    }
    
    func updateComplete() {
        focusArr[0].amount += 1
        if minutesFocus == 15 {
            focusArr[0].completeSmall += 1
        } else if minutesFocus == 25 {
            focusArr[0].completeMedium += 1
        } else if minutesFocus == 35 {
            focusArr[0].completeLarge += 1
        }
        
        initFirebase.updateCompleteFocus(focusArr: focusArr)
        takeData()
    }
}

extension FocusVC {
    func takeData() {
        initFirebase.db.collection(initFirebase.user!)
            .addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("Problem with retrieving data \(e)")
                } else {
                    
                    self.focusArr = []
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let amount = data["amount"] as? Int, let inc = data["incomplete"] as? Int, let small = data["completeSmall"] as? Int, let med = data["completeMedium"] as? Int, let lar = data["completeLarge"] as? Int {
                                let newFocus = Focus(amount: amount, incomplete: inc, completeSmall: small, completeMedium: med, completeLarge: lar)
                                self.focusArr.append(newFocus)
                            }
                        }
                    }
                }
            }
    }
    
    func initDoc() {
        initFirebase.db.collection(initFirebase.user!).document("Focus").setData(["amount": 0, "incomplete": 0, "completeSmall": 0, "completeMedium": 0, "completeLarge": 0]) { (error) in
            if let e = error {
                print("Problem with saving focus, \(e)")
            } else {
                let newFocus = Focus(amount: 0, incomplete: 0, completeSmall: 0, completeMedium: 0, completeLarge: 0)
                self.focusArr.append(newFocus)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? StatisticVC {
            destinationVC.initFocusStatistic(arr: focusArr)
        }
    }
    
    func checkInitDocument() {
        let docRef = initFirebase.db.collection(initFirebase.user!).document("Focus")
        
        docRef.getDocument { (doc, error) in
            if let doc = doc {
                if doc.exists {
                    self.takeData()
                } else {
                    self.initDoc()
                }
            }
        }
    }
}

