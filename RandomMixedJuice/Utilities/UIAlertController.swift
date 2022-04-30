//
//  UIAlertController.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/26.
//

import Foundation
import UIKit

extension UIAlertController {
    static func addingCompletedFruit() -> Self {
        let title = "ついか"
        let message = "フルーツのついかが\nできました！"
        let controller = self.init(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "はい", style: .default, handler: nil))
        return controller
    }
    static func resetFruit(reset:@escaping (UIAlertAction) -> Void) -> Self {
        let title = "リセットしますか？"
        let message = "初期設定に戻ります。\n入力したフルーツは\nすべて削除されます。"
        let controller = self.init(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "リセット", style: .cancel, handler: reset))
        controller.addAction(UIAlertAction(title: "キャンセル", style: .default))
        return controller
    }
}
