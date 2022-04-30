//
//  ExtentionUIColor.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/05/01.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        var rValue: CGFloat = 0.0
        var gValue: CGFloat = 0.0
        var bValue: CGFloat = 0.0
        var aValue: CGFloat = 1.0

        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            rValue = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            gValue = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            bValue = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            rValue = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            gValue = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            bValue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            aValue = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: rValue, green: gValue, blue: bValue, alpha: aValue)
    }

    func toHexString() -> String {
        var red: CGFloat     = 1.0
        var green: CGFloat   = 1.0
        var blue: CGFloat    = 1.0
        var alpha: CGFloat   = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rValue = Int(String(Int(floor(red*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let gValue = Int(String(Int(floor(green*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let bValue = Int(String(Int(floor(blue*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let aValue = Int(String(Int(floor(alpha*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!

        let result = String(rValue, radix: 16)
            .leftPadding(toLength: 2, withPad: "0") + String(gValue, radix: 16)
            .leftPadding(toLength: 2, withPad: "0") + String(bValue, radix: 16)
            .leftPadding(toLength: 2, withPad: "0") + String(aValue, radix: 16)
            .leftPadding(toLength: 2, withPad: "0")
        return result
    }
}

extension String {
    // 左から文字埋めする
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
