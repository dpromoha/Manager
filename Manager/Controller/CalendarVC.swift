//
//  CalendarVC.swift
//  Manager
//
//  Created by Daria Pr on 28.09.2020.
//

import UIKit
import FSCalendar
import Firebase

class CalendarVC: UIViewController {
    
    @IBOutlet weak var calendarLbl: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var initFirebase = InitFirebase()
    var calendarArr: [Calendar] = []
    var events: [Calendar] = []
    
    lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        calendarLbl.delegate = self
        calendarLbl.dataSource = self
        
        calendarLbl.appearance.todayColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        calendarLbl.appearance.selectionColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        calendarLbl.appearance.titleWeekendColor = #colorLiteral(red: 0.5221586823, green: 0.1243738011, blue: 0.09732303768, alpha: 1)
        calendarLbl.appearance.headerTitleColor = #colorLiteral(red: 0.1529411765, green: 0.2745098039, blue: 0.5176470588, alpha: 1)
        calendarLbl.appearance.weekdayTextColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        calendarLbl.firstWeekday = 2
        
        loadCalendar()
    }

}

extension CalendarVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as? MainCell else {return UITableViewCell()}
        
        let rowItem = calendarArr[indexPath.row]
        
        cell.dateLbl.text = rowItem.date
        cell.descrDate.text = rowItem.descrDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            initFirebase.deleteDoc(task: calendarArr[indexPath.row].date)
            calendarArr.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .medium
        let eventDate: String? = formatter1.string(from: date)
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new event", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            if textField.text != "" {
                if let eventDate = eventDate, let eventDescr = textField.text, let email = self.initFirebase.user {
                    self.initFirebase.db.collection(self.initFirebase.user!).document(eventDate).setData(["eventDate" : eventDate, "eventDescr": eventDescr, "e-mail": email, "date" : Date().timeIntervalSince1970, "celebr": true]) { (error) in
                        if let e = error {
                            print("Problem with saving data, \(e)")
                        } else {
                            print("SAVE DATA")
                        }
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "New Event"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        
        for d in events {
            let date = d.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let datenew = dateFormatter.string(from: dateFromString as Date)
            if datenew.contains(dateString) {
                return 1
            }
        }
        return 0
        
    }
    
}

extension CalendarVC {
    func loadCalendar() {
        initFirebase.db.collection(initFirebase.user!)
            .order(by: "eventDate")
            .addSnapshotListener { (querySnapshot, error) in
                
                self.calendarArr = []
                
                if let e = error {
                    print("Problem with retrieving data \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let date = data["eventDate"] as? String, let eventDescr = data["eventDescr"] as? String, let _ = data["e-mail"] as? String {
                                let newEvent = Calendar(date: date, descrDate: eventDescr)
                                self.calendarArr.append(newEvent)
                                DispatchQueue.main.async {
                                    self.events = self.calendarArr
                                    self.tableView.reloadData()
                                    self.calendarLbl.reloadData()
                                }
                            }
                        }
                    }
                }
            }
    }
}
