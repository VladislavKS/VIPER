//
//  FeedbackListSection.swift
//  DNS-SHOP
//
//  Created by Владислав Костромин on 02.06.2021.
//

import Foundation

class FeedbackListSection: Hashable {
    let uuid = UUID()
    let title: String
    let idTitle: String
    var isSelected: Bool

    static func ==(lhs: FeedbackListSection, rhs: FeedbackListSection) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    init(title: String, idTitle: String, isSelected: Bool) {
        self.title = title
        self.idTitle = idTitle
        self.isSelected = isSelected
    }
}

