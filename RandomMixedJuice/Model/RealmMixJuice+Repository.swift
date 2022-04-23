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

struct RealmMixJuiceRepository: MixJuiceRepositoryProtocol {
    private let realm = try! Realm()

    func allLoadMixJuice(sortKey: String, ascending: Bool) -> [MixJuice] {
        let allRealmMixJuice = realm.objects(RealmMixJuice.self)
            .sorted(byKeyPath: sortKey, ascending: ascending)
        let realmMixJuiceArray = Array(allRealmMixJuice)
        let allMixJuice = realmMixJuiceArray.map {MixJuice(object: $0)! }
        return allMixJuice
    }

    func addMixJuice(mixJuice: MixJuice) {
        try! realm.write {
            realm.add(mixJuice.managedObject())
        }
    }

    func updateMixJuice(mixJuice: MixJuice) {
        try! realm.write {
            let realmMixJuice = realm.object(ofType: RealmMixJuice.self, forPrimaryKey: mixJuice.id.uuidString)
            realmMixJuice?.fruit1 = mixJuice.fruit1
            realmMixJuice?.fruit2 = mixJuice.fruit2
            realmMixJuice?.fruit3 = mixJuice.fruit3
            realmMixJuice?.fruit4 = mixJuice.fruit4
            realmMixJuice?.fruit5 = mixJuice.fruit5
            realmMixJuice?.createdAt = mixJuice.createdAt
        }
    }

    func removeMixJuice(mixJuice: MixJuice) {
        guard  let realmMixJuice = realm.object(
            ofType: RealmMixJuice.self,
            forPrimaryKey: mixJuice.id.uuidString
        ) else { return }
        try! realm.write {
            realm.delete(realmMixJuice)
        }
    }
}
