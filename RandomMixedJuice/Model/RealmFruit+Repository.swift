//
//  RealmFruit.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/24.
//

import Foundation
import RealmSwift

final class RealmFruit: Object {
    @Persisted(primaryKey: true)
    var uuidString = ""
    @Persisted
    var name: String = ""
    @Persisted
    var createdAt: Date = Date()
}

protocol FruitRepositoryProtocol {
    func allLoadFruit(sortKey: String, ascending: Bool) -> [Fruit]
    func addFruit(fruit: Fruit)
    func updateFruit(fruit: Fruit)
    func removeFruit(fruit: Fruit)
}

struct RealmFruitRepository: FruitRepositoryProtocol {
    private let realm = try! Realm()
    func allLoadFruit(sortKey: String, ascending: Bool) -> [Fruit] {
        let allRealmFruit = realm.objects(RealmFruit.self)
            .sorted(byKeyPath: sortKey, ascending: ascending)
        let realmFruitArray = Array(allRealmFruit)
        let allFruit = realmFruitArray.map {Fruit(object: $0)! }
        return allFruit
    }

    func addFruit(fruit: Fruit) {
        try! realm.write {
            realm.add(fruit.managedObject())
        }
    }

    func updateFruit(fruit: Fruit) {
        try! realm.write {
            let realmFruit = realm.object(ofType: RealmFruit.self, forPrimaryKey: fruit.id.uuidString)
            realmFruit?.name = fruit.name
            realmFruit?.createdAt = fruit.createdAt
        }
    }

    func removeFruit(fruit: Fruit) {
        guard  let realmFruit = realm.object(
            ofType: RealmFruit.self,
            forPrimaryKey: fruit.id.uuidString
        ) else { return }
        try! realm.write {
            realm.delete(realmFruit)
        }
    }
}
