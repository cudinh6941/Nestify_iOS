//
//  CategoryRepository.swift
//  Nestify
//
//  Created by pham kha dinh on 4/5/25.
//

import SwiftUI

struct CategoryItem: Identifiable {
    let id: String
    let title: String
    let count: Int?
    let label: String
    let iconName: String
    let color: Color
    let navigate: AppRoute
}

struct CategoryRepository {
    static let sharedCategories: [CategoryItem] = [
        CategoryItem(id:"furniture", title: "Đồ dùng", count: 24, label: "vật phẩm", iconName: "chair.lounge.fill", color: .blue, navigate: .listItem),
        CategoryItem(id:"pet", title: "Vật nuôi", count: 2, label: "thú cưng", iconName: "pawprint.fill", color: .orange, navigate: .addPet),
        CategoryItem(id:"plant", title: "Cây cối", count: 8, label: "cây", iconName: "leaf.fill", color: .green, navigate: .addPlant),
        CategoryItem(id:"expend", title: "Chi tiêu", count: 15, label: "khoản", iconName: "creditcard.fill", color: .purple, navigate: .addMenuItem)
    ]
}
