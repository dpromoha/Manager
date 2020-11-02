//
//  RegistrationVC.swift
//  Manager
//
//  Created by Daria Pr on 24.09.2020.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.overrideUserInterfaceStyle = .light
        passwordTextField.overrideUserInterfaceStyle = .light
        let registerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        registerBtn.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.1176470588, blue: 0.3529411765, alpha: 1)
        registerBtn.setTitle("Sign Up", for: .normal)
        registerBtn.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        registerBtn.addTarget(self, action: #selector(RegistrationVC.register), for: .touchUpInside)
        
        loginTextField.inputAccessoryView = registerBtn
        passwordTextField.inputAccessoryView = registerBtn
        
    }
    
    @objc func register() {
        if let email = loginTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let _ = error {
                    let alert = UIAlertController(title: "ERROR", message: "Email address or password is badly formatted", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    }
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "registerToMenu", sender: self)
                }
            }
        }
    }
    
}
