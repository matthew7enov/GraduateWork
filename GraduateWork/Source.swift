//
//  Source.swift
//  GraduateWork
//
//  Created by Matvey Semenov on 2.04.23.
//

import Foundation
import UIKit

struct Contact {
    let name: String
    let image: UIImage
    let description: String
    let gender: Gender
}

enum Gender {
    case male
    case female
}

struct ImageName {
    static let person = "person"
    static let fillperson = "person.fill"
}

struct Description {
    static let description = "девушка"
    static let description2 = "парень"
}

struct Source {
    static func makeContacts() -> [Contact] {
        [
            .init(name: "Алиса", image: .init(systemName: ImageName.person)!, description: Description.description, gender: .female),
            .init(name: "Таня", image: .init(systemName: ImageName.person)!, description: Description.description, gender: .female),
            .init(name: "Маша", image: .init(systemName: ImageName.person)!, description: Description.description, gender: .female),
            .init(name: "Соня", image: .init(systemName: ImageName.person)!, description: Description.description, gender: .female),
            .init(name: "Маша", image: .init(systemName: ImageName.person)!, description: Description.description, gender: .female),
            .init(name: "Соня", image: .init(systemName: ImageName.person)!, description: Description.description, gender: .female),
            .init(name: "Маша", image: .init(systemName: ImageName.person)!, description: Description.description, gender: .female),
            .init(name: "Соня", image: .init(systemName: ImageName.person)!, description: Description.description, gender: .female),
            .init(name: "Маша", image: .init(systemName: ImageName.person)!, description: Description.description, gender: .female),
            .init(name: "Соня", image: .init(systemName: ImageName.person)!, description: Description.description, gender: .female),
            
            .init(name: "Матвей", image: .init(systemName: ImageName.fillperson)!, description: Description.description2, gender: .male),
            .init(name: "Влад", image: .init(systemName: ImageName.fillperson)!, description: Description.description2, gender: .male),
            .init(name: "Кирилл", image: .init(systemName: ImageName.fillperson)!, description: Description.description2, gender: .male),
            .init(name: "Стас", image: .init(systemName: ImageName.fillperson)!, description: Description.description2, gender: .male),
            .init(name: "Кирилл", image: .init(systemName: ImageName.fillperson)!, description: Description.description2, gender: .male),
            .init(name: "Стас", image: .init(systemName: ImageName.fillperson)!, description: Description.description2, gender: .male),
            .init(name: "Кирилл", image: .init(systemName: ImageName.fillperson)!, description: Description.description2, gender: .male),
            .init(name: "Стас", image: .init(systemName: ImageName.fillperson)!, description: Description.description2, gender: .male)
        ]
    }
    
    static func makeContactsWithGroup() -> [[Contact]] {
        let male = makeContacts().filter {$0.gender == .male}
        let female = makeContacts().filter {$0.gender == .female}
        return [male,female]
    }
}
