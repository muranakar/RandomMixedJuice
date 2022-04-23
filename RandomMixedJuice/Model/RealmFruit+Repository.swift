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
