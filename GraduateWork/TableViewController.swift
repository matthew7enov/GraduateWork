//
//  TableViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 2.04.23.
//

import UIKit

class TableViewController: UIViewController {

    var storage = Source.makeStorage()
    let tableView: UITableView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
//        descriptionButtonPressed()
        tableView.register(StorageCell.self, forCellReuseIdentifier: "StorageCell")
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorageCell", for: indexPath) as? StorageCell else { fatalError() }
        
        cell.configure(contact: storage[indexPath.row])
        
        cell.tapAction = {[weak self] in
            let controller = StorageDetailsViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        storage.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ProductListViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
//extension TableViewController {
//    @objc func descriptionButtonPressed() {
//        let controller = UserAccountViewController()
//        navigationController?.pushViewController(controller, animated: true)
//    }
//}

extension TableViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    }
}
