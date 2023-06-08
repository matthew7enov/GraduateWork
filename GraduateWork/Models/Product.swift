//
//  Product.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 11.04.23.
//

import Foundation
import UIKit

struct Product: Codable, Equatable {
    let barCode: String
    let name: String
    let imageUrl: URL?
    let count: Int
    let description: String
    let category: ProductCategory
}


//struct ProductList {
//    let name: String
//    let image: UIImage
//    let descriptionCategory: String
//    let category: ProductCategory
//    let count: Int
//}

struct Image {
    static let drop = "drop"
    static let popcorn = "popcorn"
}
struct DescriptionProduct {
    static let description1 = ProductCategory.snacks
    static let description2 = ProductCategory.drinks
}

//struct ProductListSource{
//    static func makeProductListView() -> [ProductList] {
//        [
//            .init(name: "Coca-cola 2L", image: .init(systemName: Image.drop)!, descriptionCategory: ProductCategory.drinks.rawValue, category: .drinks, count: 2),
//            .init(name: "Чипсы Lays (Краб)", image: .init(systemName: Image.popcorn)!, descriptionCategory: ProductCategory.snacks.rawValue, category: .snacks, count: 1),
//            .init(name: "Sprite 2L", image: .init(systemName: Image.drop)!, descriptionCategory: ProductCategory.drinks.rawValue, category: .drinks, count: 1)
//        ]
//    }
//
//}

enum ProductCategory: String, CaseIterable, Codable {
    case meat, drinks, fish, milkProducts, sweets, snacks, grocery, other

    var stringValue: String {
        switch self {
        case .meat:
            return "Мясо"
        case .drinks:
            return "Напитки"
        case .fish:
            return "Рыба"
        case .milkProducts:
            return "Молочные продукты"
        case .sweets:
            return "Сладости"
        case .snacks:
            return "Снэки"
        case .grocery:
            return "Бакалея"
        case .other:
            return "Другое"
        }
    }
    var emojiValue: String {
        switch self {
        case .meat:
            return "🥩"
        case .drinks:
            return "🥤"
        case .fish:
            return "🍣"
        case .milkProducts:
            return "🥛"
        case .sweets:
            return "🍫"
        case .snacks:
            return "🍿"
        case .grocery:
            return "🍞"
        case .other:
            return "🥥"
        }
    }
}
