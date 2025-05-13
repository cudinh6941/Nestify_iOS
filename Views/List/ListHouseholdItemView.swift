//
//  ListHouseholdItemView.swift
//  Nestify
//
//  Created by pham kha dinh on 9/5/25.
//
import SwiftUI
struct HouseholdItemsView: View {
    // Filter options for household items
    static let categories: [Option] = [
        Option(label: "Tất cả", value: ""),
        Option(label: "Đồ điện tử", value: "electronic"),
        Option(label: "Đồ nội thất", value: "furniture"),
        Option(label: "Thiết bị nhà bếp", value: "kitchen"),
        Option(label: "Quần áo", value: "clothes"),
        Option(label: "Khác", value: "others")
    ]
    @StateObject private var viewModel = GenericListViewModel<HouseholdItem>(
        userId: "user123",
        itemType: "household",
        filterOptions: HouseholdItemsView.categories
    )
    
    var body: some View {
        // Use the generic list view with specific parameters for household items
        return GenericListView(
            title: "Danh sách vật dụng",
            viewModel: viewModel,
            detailViewProvider: { item in
                ItemDetailView()
            },
            addItemViewProvider: {
                AddItemView()
            }
        )
        
    }
}
