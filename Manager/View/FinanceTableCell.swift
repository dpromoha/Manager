//
//  FinanceTableCell.swift
//  Manager
//
//  Created by Daria Pr on 23.10.2020.
//

import UIKit

class FinanceTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    var finance = [Finance]()
    static let identifier = "FinanceTableCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FinanceTableCell", bundle: nil)
    }
    
    func configure(with finance: [Finance]) {
        self.finance = finance
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(FinanceCollectionViewCell.nib(), forCellWithReuseIdentifier: FinanceCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        finance.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinanceCollectionViewCell.identifier, for: indexPath) as! FinanceCollectionViewCell
        cell.configure(finance: finance[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
