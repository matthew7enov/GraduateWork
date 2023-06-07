//
//  ProductListViewController.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 11.04.23.
//

import UIKit

class ProductListViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    

    var product = ProductListSource.makeProductListView()
    let tableView: UITableView = .init()
    let searchController = UISearchController()
    var products = [ProductList]()
    var filteredProducts = [ProductList]()
    
    
    
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
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All"){
        filteredProducts = products.filter{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Склад №2"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(scannerButtomPressed))
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        
        setupProductListTableView()
        initSearchController()
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func scannerButtomPressed() {
        let controller = ScannerViewController()
        navigationController?.pushViewController(controller, animated: true)
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
