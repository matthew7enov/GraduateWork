//
//  TableViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 2.04.23.
//

import UIKit
import SVProgressHUD

class TableViewController: UIViewController {

    let dataProvider = DataProvider.shared
    var storages = [Storage]()
    let tableView: UITableView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(didPressAdd))

        setupTableView()
//        descriptionButtonPressed()
        tableView.register(StorageCell.self, forCellReuseIdentifier: "StorageCell")
        tableView.dataSource = self
        tableView.delegate = self

        dataProvider.setupStorageListUpdatesListener { [weak self] storages in
            guard let self = self else { return }
            let difference = storages.difference(from: self.storages)
            self.storages = storages
            if difference.isEmpty {
                self.tableView.reloadData()
            } else {
                var insertIndexPath = [IndexPath]()
                var removeIndexPath = [IndexPath]()
                for change in difference {
                    switch change {
                    case .insert(let offset, _, _):
                        insertIndexPath.append(.init(row: offset, section: 0))
                    case .remove(let offset, _, _):
                        removeIndexPath.append(.init(row: offset, section: 0))
                    }
                }
                self.tableView.performBatchUpdates { [weak self] in
                    if !insertIndexPath.isEmpty {
                        self?.tableView.insertRows(at: insertIndexPath, with: .automatic)
                    }
                    if !removeIndexPath.isEmpty {
                        self?.tableView.deleteRows(at: removeIndexPath, with: .automatic)
                    }
                }
            }
        }
    }

    @objc func didPressAdd() {
        let alertController = UIAlertController(title: "Добавить склад", message: "Введите данные склада", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Название"
        }

        alertController.addTextField { textField in
            textField.placeholder = "Адресс"
        }

        alertController.addAction(.init(title: "Добавить", style: .default, handler: { [weak self, weak alertController] _ in
            guard let name = alertController?.textFields?[0].text,
                  let address = alertController?.textFields?[1].text else {
                return
            }
            self?.addStorage(name: name, address: address)

        }))
        alertController.addAction(.init(title: "Отмена", style: .cancel))

        present(alertController, animated: true)
    }

    private func addStorage(name: String, address: String) {
        SVProgressHUD.show()
        dataProvider.saveStorage(.init(id: UUID(), name: name, address: address)) { error in
            SVProgressHUD.dismiss()
        }
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorageCell", for: indexPath) as? StorageCell else { fatalError() }

        let storage = storages[indexPath.row]
        cell.configure(storage: storage)
        
        cell.tapAction = { [weak self] in
            guard let self = self else {
                return
            }
            let controller = StorageDetailsViewController(storage: storage)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataProvider.removeStorage(storages[indexPath.row]) { _ in }
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storage = storages[indexPath.row]
        let controller = ProductListViewController(storage: storage)
        navigationController?.pushViewController(controller, animated: true)
    }
}

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
