//
//  MixJuice.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/23.
//

import Foundation


struct MixJuice {
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



extension MixJuice{
    init(name: String) {
        self.init(id: .init(rawValue: UUID()))
    }

    init?(object: RealmMixJuice) {
        guard let uuid = UUID(uuidString: object.uuidString) else {
            return nil
        }
        self.init(
            id: .init(rawValue: uuid),
            name: object.name
        )
    }
}
