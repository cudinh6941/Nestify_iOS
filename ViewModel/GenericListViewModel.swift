//
//  GenericListViewModel.swift
//  Nestify
//
//  Created by pham kha dinh on 9/5/25.
//

import Foundation
import Combine
import SwiftUI
class GenericListViewModel<T: BaseItem>: ObservableObject {
    // State variables
    @Published var items: [T] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var selectedFilter: String? = nil
    @Published var searchText: String = ""
    
    // Categories & filters
    @Published var filterOptions: [Option] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let realmManager: RealmManager
    private let userId: String
    private let itemType: String
    
    init(realmManager: RealmManager = .shared, userId: String = "user123", itemType: String, filterOptions: [Option]) {
        self.realmManager = realmManager
        self.userId = userId
        self.itemType = itemType
        self.filterOptions = filterOptions
        
        // Add "All" option at the beginning if not present
        if !filterOptions.contains(where: { $0.value.isEmpty }) {
            self.filterOptions.insert(Option(label: "Tất cả", value: ""), at: 0)
        }
        
        // Chỉ gọi loadItems() một lần, KHÔNG đăng ký dataChanged
        loadItems()
        
        // Đăng ký nhận thông báo thay đổi SAU khi data đã được load
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            self.realmManager.dataChanged
                .receive(on: DispatchQueue.main)
                .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    
                    if !self.isLoading {
                        print("Data changed notification received, reloading...")
                        self.loadItems()
                    } else {
                        print("Data changed notification received but loading is in progress, skipping")
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    
    var filteredItems: [T] {
        var result = items
        
        // Apply category filter
        if let filter = selectedFilter, !filter.isEmpty {
            result = result.filter { $0.categoryId == filter }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.descriptionText?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
        
        return result
    }
    
    func loadItems() {
        // Tránh gọi khi đang loading
        if isLoading {
            print("Already loading, skipping")
            return
        }
        
        print("Loading items for \(T.self)")
        isLoading = true
        
        // Hủy các subscriptions cũ trước khi tạo mới
        cancellables.removeAll(keepingCapacity: true)
        
        realmManager.entityPublisher(T.self)
            .map { results -> [T] in
                Array(results.filter("userId == %@ AND itemType == %@", self.userId, self.itemType))
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    
                    // Đặt isLoading = false trong callback
                    self.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                        print("Error loading items: \(error.localizedDescription)")
                    } else {
                        print("Items loaded successfully")
                    }
                },
                receiveValue: { [weak self] items in
                    guard let self = self else { return }
                    self.items = items
                    print("Received \(items.count) items")
                }
            )
            .store(in: &cancellables)
            
        // KHÔNG đặt isLoading = false ở đây!
    }
    
    func setFilter(_ categoryId: String?) {
        self.selectedFilter = categoryId
    }
    

    
    // MARK: - Helper Formatting Methods
    
    func getItemInitials(_ item: T) -> String {
        let words = item.name.components(separatedBy: " ")
        if words.count > 1 {
            return String(words[0].prefix(1) + words[1].prefix(1))
        } else if !words.isEmpty {
            return String(words[0].prefix(2))
        }
        return "??"
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    func getLocationName(for code: String?) -> String {
        guard let code = code else { return "Không có" }
        
        switch code {
        case "living_room": return "Phòng khách"
        case "bedroom": return "Phòng ngủ"
        case "kitchen": return "Nhà bếp"
        case "bathroom": return "Phòng tắm"
        case "storage": return "Kho"
        case "yard": return "Sân"
        default: return code
        }
    }
    
    func getCategoryName(for code: String?) -> String {
        guard let code = code else { return "Khác" }
        
        switch code {
        case "electronic": return "Đồ điện tử"
        case "furniture": return "Đồ nội thất"
        case "kitchen": return "Thiết bị nhà bếp"
        case "clothes": return "Quần áo"
        case "others": return "Khác"
        default: return code
        }
    }
    
    func getCategoryColor(for categoryId: String?) -> Color {
        guard let categoryId = categoryId else { return .gray }
        
        switch categoryId {
        case "electronic": return .blue
        case "furniture": return .orange
        case "kitchen": return .green
        case "clothes": return .purple
        case "others": return .gray
        default: return .gray
        }
    }
}
