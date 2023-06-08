//
//  DataProvider.swift
//  CourseWork
//
//  Created by Matvey Semenov on 12/12/2022.
//

import Foundation
import Alamofire
import FirebaseFirestore
import FirebaseFirestoreSwift

class DataProvider {
    enum ProviderError: Error {
        case userNotFound
    }

    static let shared = DataProvider()

    lazy var firestore = Firestore.firestore()
    lazy var userService = UserService.shared

    // MARK: - Storage

    func getStorages(_ completion: @escaping ([Storage]) -> Void) {
        firestore.collection("storage").getDocuments { snapshot, error in
            guard error == nil,
                  let storageModels = snapshot?.documents.compactMap({ try? $0.data(as: StorageAPIModel.self) }) else {
                completion([])
                return
            }
            completion(storageModels.compactMap({ Storage(id: $0.id, name: $0.name, address: $0.address, products: []) }))
        }
    }

    func setupStorageListUpdatesListener(_ completion: @escaping ([Storage]) -> Void) {
        firestore.collection("storage").addSnapshotListener { snapshot, error in
            guard error == nil,
                  let storageModels = snapshot?.documents.compactMap({ try? $0.data(as: StorageAPIModel.self) }) else {
                completion([])
                return
            }
            completion(storageModels.compactMap({ Storage(id: $0.id, name: $0.name, address: $0.address, products: []) }))
        }
    }

    func saveStorage(_ storage: StorageAPIModel, completion: @escaping (Error?) -> Void) {
        do {
            try firestore.collection("storage")
                .document("storage_\(storage.id.uuidString)")
                .setData(from: storage) { error in
                    completion(error)
                }
        } catch let error {
            completion(error)
        }
    }

    func removeStorage(_ storage: Storage, completion: @escaping (Error?) -> Void) {
        firestore.collection("storage")
            .document("storage_\(storage.id.uuidString)")
            .delete() { error in
                completion(error)
            }
    }

    // MARK: - Product

    func setupProductListUpdatesListener(storageId: String, completion: @escaping ([Product]) -> Void) {
        firestore.collection("storage")
            .document("storage_\(storageId)")
            .collection("productList")
            .addSnapshotListener { snapshot, error in
                guard error == nil,
                      let products = snapshot?.documents.compactMap({ try? $0.data(as: Product.self) }) else {
                    completion([])
                    return
                }
                completion(products)
            }
    }

    func saveProduct(_ product: Product, storageId: String, completion: @escaping (Error?) -> Void) {
        do {
            try firestore.collection("storage")
                .document("storage_\(storageId)")
                .collection("productList")
                .document("code_\(product.barCode)").setData(from: product) { error in
                    completion(error)
                }
        } catch let error {
            completion(error)
        }
    }

    func removeProduct(_ product: Product, storageId: String, completion: @escaping (Error?) -> Void) {
        firestore.collection("storage")
            .document("storage_\(storageId)")
            .collection("productList")
            .document("code_\(product.barCode)")
            .delete() { error in
                completion(error)
            }
    }

    func getProduct(with barCode: String, in storageId: String, completion: @escaping (Product?) -> Void) {
        let searchForProduct = {
            let headers: HTTPHeaders = .init(dictionaryLiteral: ("Authorization", "Bearer cbb6f84da44eed28ce5d6aa38494eb1bdf955a64851f3a4a680e54f3ed7f814d"))
            AF.request("https://go-upc.com/api/v1/code/\(barCode)", headers: headers).responseDecodable(of: ProductApiModel.self) { response in
                switch response.result {
                case .success(let model):
                    let newProduct = Product(barCode: model.code, name: model.product.name, imageUrl: model.product.imageUrl, count: 1, description: model.product.description ?? "", category: .other)
                    completion(newProduct)
                case .failure(_):
                    completion(nil)
                }
            }
        }

        firestore.collection("storage")
            .document("storage_\(storageId)")
            .collection("productList")
            .document("code_\(barCode)")
            .getDocument(as: Product.self) { result in
                switch result {
                case .success(let product):
                    completion(.init(barCode: product.barCode, name: product.name, imageUrl: product.imageUrl, count: product.count + 1, description: product.description, category: product.category))
                case .failure(_):
                    searchForProduct()
                }
            }
    }

    func move(product: Product, from: Storage, to: Storage, completion: @escaping (Bool) -> Void) {
        let fromStorageListRef = firestore.collection("storage")
            .document("storage_\(from.id.uuidString)")
            .collection("productList")
        let toStorageListRef = firestore.collection("storage")
            .document("storage_\(to.id.uuidString)")
            .collection("productList")

        firestore.runTransaction { transaction, errorPointer in
            transaction.deleteDocument(fromStorageListRef.document("code_\(product.barCode)"))
            do {
                try transaction.setData(from: product, forDocument: toStorageListRef.document("code_\(product.barCode)"))
            } catch let saveError as NSError {
                errorPointer?.pointee = saveError
                return nil
            }
            return to.id
        } completion: { _, error in
            completion(error != nil)
        }
    }
}
