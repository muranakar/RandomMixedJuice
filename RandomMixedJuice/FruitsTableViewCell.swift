//
//  FruitsTableViewCell.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/25.
//

import UIKit

class FruitsTableViewCell: UITableViewCell {


    @IBOutlet private weak var fruitLabel: UILabel!

    func configureLabelText(text: String) {
        fruitLabel.text = text
    }
}
