//
//  StartStopButton.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/27.
//

import Foundation
import UIKit

@IBDesignable
class StartStopButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeContent()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeContent()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initializeContent()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayer()
    }
    private func initializeContent() {
        setTitle("", for: .highlighted)
        setTitleColor(.black, for: .normal)
        setTitleColor(.black, for: .selected)
        backgroundColor = UIColor(hex: "FFBD2F")
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    }

    private func updateLayer() {
        layer.cornerRadius = 40.0
        layer.borderColor =  UIColor(hex: "FFBD2F")?.cgColor
        layer.borderWidth = 2
    }
}
