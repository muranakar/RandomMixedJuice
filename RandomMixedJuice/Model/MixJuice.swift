//
//  MixJuice.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/23.
//

import Foundation

struct MixJuice {
    // swiftlint:disable:next type_name
    struct ID: RawRepresentable {
        let rawValue: UUID

        var uuidString: String {
            rawValue.uuidString
        }
    }
    var id: ID
    var fruit1: String?
    var fruit2: String?
    var fruit3: String?
    var fruit4: String?
    var fruit5: String?
    var createdAt: Date = Date()
}

extension MixJuice {
    init(
        fruit1: String,
        fruit2: String,
        fruit3: String,
        fruit4: String,
        fruit5: String,
        createdAt: Date
    ) {
        self.init(id: .init(rawValue: UUID()))
        self.fruit1 = fruit1
        self.fruit2 = fruit2
        self.fruit3 = fruit3
        self.fruit4 = fruit4
        self.fruit5 = fruit5
        self.createdAt = createdAt
    }

    init?(object: RealmMixJuice) {
        guard let uuid = UUID(uuidString: object.uuidString) else {
            return nil
        }
        self.init(
            id: .init(rawValue: uuid),
            fruit1: object.fruit1,
            fruit2: object.fruit2,
            fruit3: object.fruit3,
            fruit4: object.fruit4,
            fruit5: object.fruit5,
            createdAt: object.createdAt
        )
    }
}
