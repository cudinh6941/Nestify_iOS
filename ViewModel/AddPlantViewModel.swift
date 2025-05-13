//
//  AddPlantViewModel.swift
//  Nestify
//
//  Created by pham kha dinh on 13/5/25.
//

import Foundation
import UIKit
class AddPlantViewModel: ObservableObject {
    @Published var name = ""
    @Published var species = ""
    @Published var location = ""
    @Published var plantingDate: Date = Date()
    @Published var wateringFrequency = ""
    @Published var lastWateringDate: Date = Date()
    @Published var fertilizingFrequency = ""
    @Published var lastFertilizingDate: Date = Date()
    @Published var sunlightRequirements = ""
    @Published var soilType = ""
    @Published var notes = ""
    
    @Published var selectedImage: UIImage?
    @Published var imageData: Data?
    
    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var errorMessage: String?
    
    var isFormValid: Bool {
        !name.isEmpty && !species.isEmpty && !location.isEmpty
    }
    
    func savePlant() {
        guard isFormValid else { return }
        
        isLoading = true
        
        // Simulate a network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Create Plant object and save to Realm
            // This would be replaced with actual Realm code
            
            /*
            let plant = Plant()
            plant.id = UUID().uuidString
            plant.userId = "current_user_id" // Replace with actual user ID
            plant.name = self.name
            plant.species = self.species
            plant.location = self.location
            plant.plantingDate = self.plantingDate
            plant.wateringFrequency = Int(self.wateringFrequency) ?? 0
            plant.lastWateringDate = self.lastWateringDate
            plant.nextWateringDate = Calendar.current.date(byAdding: .day, value: Int(self.wateringFrequency) ?? 7, to: self.lastWateringDate)
            plant.fertilizingFrequency = Int(self.fertilizingFrequency) ?? 0
            plant.lastFertilizingDate = self.lastFertilizingDate
            plant.nextFertilizingDate = Calendar.current.date(byAdding: .day, value: Int(self.fertilizingFrequency) ?? 30, to: self.lastFertilizingDate)
            plant.sunlightRequirements = self.sunlightRequirements
            plant.soilType = self.soilType
            plant.notes = self.notes
            plant.imageData = self.imageData
            
            // Save to Realm
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(plant)
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
