//
//  AddItemViewModel.swift
//  Nestify
//
//  Created by pham kha dinh on 8/5/25.
//

import Foundation
import RealmSwift
import Combine
import SwiftUI
class AddItemViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var serialNumber: String = ""
    @Published var purchaseDate: Date = Date()
    @Published var warrantyExpiryDate: Date = Date().addingTimeInterval(365*24*60*60) // Default 1 year
    @Published var category: String = ""
    @Published var location: String = ""
    @Published var price: String = ""
    @Published var quantity: String = "1"
    @Published var selectedImage: UIImage? = nil
    @Published var imageData: Data? = nil
    // Output
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess: Bool = false
    
    // Form validation
    @Published var isFormValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let realmManager: RealmManager
    private let userId: String
    init(realmManager: RealmManager = .shared, userId: String = "user123") {
        self.realmManager = realmManager
        self.userId = userId
        
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest3($name, $category, $location)
            .map {name, category, location -> Bool in
                return !name.isEmpty && !category.isEmpty && !location.isEmpty
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    func saveItem() {
        guard isFormValid else {return}
        isLoading = true
        errorMessage = nil
         
        let householdItem = createHouseholdItem()
        
        realmManager.performTransactionPublisher {
            let realm = try Realm()
            realm.add(householdItem)
            let activity = self.createActivityLog(for: householdItem)
            realm.add(activity)
            
            if let warrantyDate = householdItem.warrantyExpiryDate {
                let notification = self.createWarrantyNotification(for: householdItem, warrantyDate: warrantyDate)
                realm.add(notification)
            }
            
            return householdItem
        }
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            },
            receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.isSuccess = true
            }
        )
        .store(in: &cancellables)

    }
    
    func createHouseholdItem () -> HouseholdItem {
        let item = HouseholdItem()
        item.id = realmManager.generateUUID()
        item.userId = userId
        item.name = name
        item.brand = brand.isEmpty ? nil : brand
        item.model = model.isEmpty ? nil : model
        item.serialNumber = serialNumber.isEmpty ? nil : serialNumber
        item.purchaseDate = purchaseDate
        item.warrantyExpiryDate = warrantyExpiryDate
        item.categoryId = category
        item.location = location
        item.purchasePrice = Double(price) ?? 0.0
        item.quantity = Int(quantity) ?? 1
        item.imageData = imageData
        item.status = "active"
        item.createdAt = Date()
        item.updatedAt = Date()
        
        return item
    }
    
    private func createActivityLog(for item: HouseholdItem) -> Activity {
         let activity = Activity()
         activity.id = realmManager.generateUUID()
         activity.userId = userId
         activity.action = "create"
         activity.itemId = item.id
         activity.itemType = item.itemType
         activity.descriptionText = "Đã thêm vật dụng: \(item.name)"
         activity.timestamp = Date()
         
         return activity
     }
     
     private func createWarrantyNotification(for item: HouseholdItem, warrantyDate: Date) -> Notification {
         let notification = Notification()
         notification.id = realmManager.generateUUID()
         notification.userId = userId
         notification.title = "Bảo hành sắp hết hạn"
         notification.message = "Bảo hành của \(item.name) sẽ hết hạn vào \(warrantyDate.formatDate())"
         notification.itemId = item.id
         notification.itemType = item.itemType
         notification.triggerDate = Calendar.current.date(byAdding: .day, value: -7, to: warrantyDate) ?? warrantyDate
         notification.type = "warranty_expiry"
         notification.createdAt = Date()
         notification.updatedAt = Date()
         
         return notification
     }
    
  
}
