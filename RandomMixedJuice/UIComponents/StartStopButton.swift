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
        setTitle("スタート", for: .normal)
        setTitle("ストップ", for: .selected)
        setTitleColor(UIColor(displayP3Red: 79/255, green: 172/255, blue: 254/255, alpha: 1.0), for: .normal)
        setTitleColor(UIColor(displayP3Red: 79/255, green: 172/255, blue: 254/255, alpha: 1.0), for: .selected)
        backgroundColor = UIColor.white
        // この下記の、FontSizeの調整が反映されないのは、なぜか？
        // レイアウト・デザインの成り立ち？が理解できていないと考えている。
        // このファイルからでは、文字サイズの調整ができないのか。。
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
    }

    private func updateLayer() {
        layer.cornerRadius = 15.0
        layer.borderColor =  UIColor(displayP3Red: 79/255, green: 172/255, blue: 254/255, alpha: 1.0).cgColor
        layer.borderWidth = 2
    }
}
