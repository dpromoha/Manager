//
//  LoginVC.swift
//  Manager
//
//  Created by Daria Pr on 24.09.2020.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.overrideUserInterfaceStyle = .light
        passwTextField.overrideUserInterfaceStyle = .light
        
        let registerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        registerBtn.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.1176470588, blue: 0.3529411765, alpha: 1)
        registerBtn.setTitle("Sign In", for: .normal)
        registerBtn.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        registerBtn.addTarget(self, action: #selector(LoginVC.login), for: .touchUpInside)
        
        emailTextField.inputAccessoryView = registerBtn
        passwTextField.inputAccessoryView = registerBtn
    }
    
    @objc func login() {
        if let email = emailTextField.text, let password = passwTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e)
                    let alert = UIAlertController(title: "ERROR", message: "Incorrect email address or password", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    }
                    alert.addAction(action)
                    
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    self?.performSegue(withIdentifier: "loginToMenu", sender: self)
                }
            }
        }
    }
    
}
