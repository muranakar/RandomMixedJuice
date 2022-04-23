//
//  RealmMixJuice+Repository.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/23.
//

import Foundation
import RealmSwift

final class RealmMixJuice: Object {
    @Persisted(primaryKey: true)
    var uuidString = ""
    @Persisted
    var fruit1: String?
    @Persisted
    var fruit2: String?
    @Persisted
    var fruit3: String?
    @Persisted
    var fruit4: String?
    @Persisted
    var fruit5: String?
    @Persisted
    var createdAt: Date = Date()
}

protocol MixJuiceRepositoryProtocol {
    func allLoadMixJuice(sortKey: String, ascending: Bool) -> [MixJuice]
    func addMixJuice(mixJuice: MixJuice)
    func updateMixJuice(mixJuice: MixJuice)
    func removeMixJuice(mixJuice: MixJuice)
}
