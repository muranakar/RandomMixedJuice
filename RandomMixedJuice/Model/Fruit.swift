//
//  Fruit.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/24.
//

import Foundation

struct Fruit {
    // swiftlint:disable:next type_name
    struct ID: RawRepresentable {
        let rawValue: UUID

        var uuidString: String {
            rawValue.uuidString
        }
    }
    var id: ID
    var name: String
    var createdAt: Date
}

extension Fruit {
    init(
        name: String,
        createdAt: Date
    ) {
        self.init(id: .init(rawValue: UUID()), name: name, createdAt: createdAt)
    }
}
