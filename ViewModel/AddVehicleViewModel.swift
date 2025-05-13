//
//  AddVehicleViewModel.swift
//  Nestify
//
//  Created by pham kha dinh on 13/5/25.
//

import Foundation
import UIKit
class AddVehicleViewModel: ObservableObject {
    @Published var name = ""
    @Published var vehicleType = ""
    @Published var make = ""
    @Published var model = ""
    @Published var year = ""
    @Published var licensePlate = ""
    @Published var vin = ""
    @Published var color = ""
    @Published var purchaseDate: Date = Date()
    @Published var purchasePrice = ""
    @Published var currentOdometer = ""
    @Published var insuranceExpiryDate: Date = Date()
    @Published var registrationExpiryDate: Date = Date()
    @Published var lastServiceDate: Date = Date()
    @Published var nextServiceDate: Date = Date()
    @Published var serviceInterval = ""
    @Published var fuelType = ""
    @Published var storageLocation = ""
    
    @Published var selectedImage: UIImage?
    @Published var imageData: Data?
    
    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var errorMessage: String?
    
    var isFormValid: Bool {
        !name.isEmpty && !vehicleType.isEmpty
    }
    
    func saveVehicle() {
        guard isFormValid else { return }
        
        isLoading = true
        
        // Simulate a network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Create Vehicle object and save to Realm
            // This would be replaced with actual Realm code
            
            /*
            let vehicle = Vehicle()
            vehicle.id = UUID().uuidString
            vehicle.userId = "current_user_id" // Replace with actual user ID
            vehicle.name = self.name
            vehicle.vehicleType = self.vehicleType
            vehicle.make = self.make
            vehicle.model = self.model
            vehicle.year = Int(self.year) ?? 0
            vehicle.licensePlate = self.licensePlate
            vehicle.vin = self.vin
            vehicle.color = self.color
            vehicle.purchaseDate = self.purchaseDate
            vehicle.purchasePrice = Double(self.purchasePrice) ?? 0
            vehicle.currentOdometer = Double(self.currentOdometer) ?? 0
            vehicle.insuranceExpiryDate = self.insuranceExpiryDate
            vehicle.registrationExpiryDate = self.registrationExpiryDate
            vehicle.lastServiceDate = self.lastServiceDate
            vehicle.nextServiceDate = self.nextServiceDate
            vehicle.serviceInterval = Int(self.serviceInterval) ?? 0
            vehicle.fuelType = self.fuelType
            vehicle.storageLocation = self.storageLocation
            vehicle.imageData = self.imageData
            
            // Save to Realm
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(vehicle)
                }
                self.isSuccess = true
            } catch {
                self.errorMessage = error.localizedDescription
            }
            */
            
            // For demonstration purposes, we'll just simulate success
            self.isSuccess = true
            self.isLoading = false
        }
    }
}
