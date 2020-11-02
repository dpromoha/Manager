//
//  RegistrationButton.swift
//  Manager
//
//  Created by Daria Pr on 01.10.2020.
//

import UIKit

class RegistrationButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderWidth = 2.0
        layer.cornerRadius = 10
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
