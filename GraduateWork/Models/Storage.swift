//
//  Source.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 2.04.23.
//

import Foundation
import UIKit

struct Storage: Equatable {
    let id: UUID
    let name: String
    let image: UIImage? = .init(systemName: "square.stack.3d.down.forward.fill")
    let address: String
    var products: [Product]
}

struct ImageName {
    static let stack = "square.stack.3d.down.forward.fill"
}

struct Description {
    static let address1 = "Пр. Независимости 87"
    static let address2 = "Ул. Якуба Коласа 1"
    static let address3 = "Ул. Пулихова 44"
}

//struct Source {
//    static func makeStorage() -> [Storage] {
//        [
//            .init(name: "Склад №1", image: .init(systemName: ImageName.stack)!, description: Description.address1),
//            .init(name: "Склад №2", image: .init(systemName: ImageName.stack)!, description: Description.address2),
//            .init(name: "Склад №3", image: .init(systemName: ImageName.stack)!, description: Description.address3)
//        ]
//    }
//
//}
