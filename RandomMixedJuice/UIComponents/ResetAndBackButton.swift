//
//  StartStopButton.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/27.
//

import Foundation
import UIKit

@IBDesignable
class ResetAndBackButton: UIButton {
override init(frame: CGRect) {
    super.init(frame: frame)
    customDesign()
  }
required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    customDesign()
  }

  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    customDesign()
  }

  private func customDesign() {
      backgroundColor = UIColor.white
      setTitleColor(.black, for: .normal)
      titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
      layer.cornerRadius = 20
      layer.borderColor =  UIColor(hex: "FFBD2F")?.cgColor
      layer.borderWidth = 2
  }
}
