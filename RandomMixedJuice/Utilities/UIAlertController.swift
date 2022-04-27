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
        let title = "追加完了"
        let message = "フルーツの追加が\n完了しました。"
        let controller = self.init(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return controller
    }
    static func resetFruit(reset:@escaping (UIAlertAction) -> Void) -> Self {
        let title = "リセットしますか？"
        let message = "初期設定に戻ります。\n入力したフルーツは削除されます。"
        let controller = self.init(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "リセット", style: .cancel, handler: reset))
        controller.addAction(UIAlertAction(title: "キャンセル", style: .default))
        return controller
    }
}
