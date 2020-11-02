//
//  FinanceCollectionViewCell.swift
//  Manager
//
//  Created by Daria Pr on 23.10.2020.
//

import UIKit

class FinanceCollectionViewCell: UICollectionViewCell {

    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet var spentLbl: UILabel!
    
    static let identifier = "FinanceCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FinanceCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(finance: Finance) {
        self.categoryLbl.text = finance.category
        self.spentLbl.text = String(finance.spent)
    }

}
