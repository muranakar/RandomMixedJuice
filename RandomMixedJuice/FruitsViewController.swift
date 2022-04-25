//
//  FruitsViewController.swift
//  RandomMixedJuice
//
//  Created by 村中令 on 2022/04/25.
//

import UIKit

class FruitsViewController: UIViewController {
    private let repository: FruitRepositoryProtocol = RealmFruitRepository()
    @IBOutlet weak private var tableView: UITableView!
    private var fruits: [Fruit] {
        repository.allLoadFruit(sortKey: "createdAt", ascending: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FruitsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fruits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FruitsTableViewCell
        let fruitNames = fruits.map { $0.name }
        cell.configureLabelText(text: fruitNames[indexPath.row])
        return cell
    }
}
extension FruitsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let fruit = fruits[indexPath.row]
        repository.removeFruit(fruit: fruit)
        tableView.reloadData()
    }
}
