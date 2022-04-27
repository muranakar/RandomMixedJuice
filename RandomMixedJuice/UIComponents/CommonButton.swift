//
//  StartStopButton.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/27.
//

import Foundation
import UIKit

@IBDesignable
class CommonButton: UIButton {
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
      setTitleColor( UIColor(displayP3Red: 79/255, green: 172/255, blue: 254/255, alpha: 1.0), for: .normal)
      titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
//      contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
      layer.cornerRadius = 15.0
      layer.borderColor =  UIColor(displayP3Red: 79/255, green: 172/255, blue: 254/255, alpha: 1.0).cgColor
      layer.borderWidth = 2
  }
}
