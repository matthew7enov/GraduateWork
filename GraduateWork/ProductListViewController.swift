//
//  ProductListViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 11.04.23.
//

import UIKit

class ProductListViewController: UIViewController {

    var product = ProductListSource.makeProductListView()
    let tableView: UITableView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProductListTableView()
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell else { fatalError() }
        
        cell.configure(product: product[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        product.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ProductDetailsViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ProductListViewController {
    func setupProductListTableView() {
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
