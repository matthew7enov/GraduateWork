//
//  ProductListViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 11.04.23.
//

import UIKit
import SVProgressHUD

class ProductListViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let dataProvider = DataProvider.shared

    var storage: Storage {
        didSet {
            filteredProducts = getFilteredProducts()
        }
    }

    let tableView: UITableView = .init()
    let searchController = UISearchController()
    var filteredProducts = [Product]()

    init(storage: Storage) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = storage.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(scannerButtomPressed))
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController

        setupProductListTableView()
        initSearchController()
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.dataSource = self
        tableView.delegate = self

        dataProvider.setupProductListUpdatesListener(storageId: storage.id.uuidString) { [weak self] products in
            guard let self = self else { return }
            let difference = products.difference(from: self.storage.products)
            self.storage.products = products
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

    func initSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All","🥩","🥤","🍿","🥛","🍞","🍣","🍫","🥥"]
        searchController.searchBar.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar  = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!

        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }

    func getFilteredProducts() -> [Product] {
        let searchBar  = searchController.searchBar
        guard searchBar.scopeButtonTitles?.count ?? 0 > searchBar.selectedScopeButtonIndex else {
            return storage.products
        }
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!

        return storage.products.filter{
            let scopeMatch = (scopeButton == "All" || $0.category.emojiValue == scopeButton)
            if(searchController.searchBar.text != ""){
                let searchTextMatch = $0.name.lowercased().contains(searchText.lowercased())

                return scopeMatch && searchTextMatch
            } else {
                return scopeMatch
            }
        }
    }

    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All"){
        filteredProducts = storage.products.filter{
            let scopeMatch = (scopeButton == "All" || $0.category.emojiValue == scopeButton)
            if(searchController.searchBar.text != ""){
                let searchTextMatch = $0.name.lowercased().contains(searchText.lowercased())

                return scopeMatch && searchTextMatch
            } else {
                return scopeMatch
            }
        }
        tableView.reloadData()
    }

    func move(product: Product, to storage: Storage) {
        SVProgressHUD.show()
        dataProvider.move(product: product, from: self.storage, to: storage) { _ in
            SVProgressHUD.dismiss()
        }
    }

    @objc func scannerButtomPressed() {
        let controller = ScannerViewController(storageId: storage.id.uuidString)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell else { fatalError() }
        let product = filteredProducts[indexPath.row]
        cell.configure(product: product)
        
        cell.tapAction = { [weak self] in
            guard let self = self else {
                return
            }
            let controller = StoragePickerViewController(currentStorage: self.storage)
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .coverVertical
            controller.didSelectStorage = { [weak self] storage in
                guard let storage else {
                    return
                }
                self?.move(product: product, to: storage)
            }
            self.present(controller, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataProvider.removeProduct(filteredProducts[indexPath.row], storageId: storage.id.uuidString) { _ in }
    }
}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ProductDetailsViewController(storageId: storage.id.uuidString)
        controller.mode = .edit
        controller.product = filteredProducts[indexPath.row]
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
