//
//  ProfileVC.swift
//  Manager
//
//  Created by Daria Pr on 24.09.2020.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    var initFirebase = InitFirebase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.overrideUserInterfaceStyle = .light
        ageTextField.overrideUserInterfaceStyle = .light
        takeData()
    }
    
    //MARK: - Firestore
    
    func takeData() {
        initFirebase.db.collection(initFirebase.user!)
            .addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("Problem with retrieving data \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let sender = data["senderName"] as? String, let age = data["age"] as? String, let mail = data["e-mail"] as? String {
                                let newProfile = Profile(profileName: sender, age: age, email: mail)
                                DispatchQueue.main.async {
                                    if newProfile.email == Auth.auth().currentUser?.email ?? "nil" {
                                        self.nameTextField.text = sender
                                        self.ageTextField.text = age
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
    
    
    @IBAction func saveBtn(_ sender: UIButton) {
        if let name = nameTextField.text, let age = ageTextField.text, let email = initFirebase.user {
            initFirebase.db.collection(initFirebase.user!).document("profile").setData(["senderName" : name, "age": age, "e-mail": email, "date": Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("Problem with saving data, \(e)")
                } else {
                    print("SAVE DATA")
                }
            }
        }
    }
    
    //MARK: - Auth
    
    @IBAction func changeEmailBtn(_ sender: UIButton) {
        var email: String?
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Change your email", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { (action) in
            if textField.text != "" {
                email = textField.text
                self.initFirebase.changeEmail(email: email ?? "a@a.com")
                DispatchQueue.main.async {
                    self.takeData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "New Email"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changePass(_ sender: UIButton) {
        var passw: String?
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Change your password", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { (action) in
            if textField.text != "" {
                passw = textField.text
                self.initFirebase.changePassword(oldPassword: passw ?? "123456")
                DispatchQueue.main.async {
                    self.takeData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Write your new Password"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Delete account", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            let user = Auth.auth().currentUser
            
            user?.delete { error in
                if let error = error {
                    print(error)
                } else {
                    self.performSegue(withIdentifier: "outToMenu", sender: self)
                    self.initFirebase.deleteDoc(task: "profile")
                }
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "outToMenu", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

