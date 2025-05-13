//
//  AddPetViewModel.swift
//  Nestify
//
//  Created by pham kha dinh on 13/5/25.
//

import Foundation
import UIKit
class AddPetViewModel: ObservableObject {
    @Published var name = ""
    @Published var species = ""
    @Published var breed = ""
    @Published var gender = ""
    @Published var location = ""
    @Published var birthDate: Date = Date()
    @Published var weight = ""
    @Published var lastVetVisit: Date = Date()
    @Published var nextVetVisit: Date = Date()
    @Published var lastVaccinationDate: Date = Date()
    @Published var nextVaccinationDate: Date = Date()
    @Published var foodPreferences = ""
    @Published var medicalConditions = ""
    @Published var medications = ""
    
    @Published var selectedImage: UIImage?
    @Published var imageData: Data?
    
    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var errorMessage: String?
    
    var isFormValid: Bool {
        !name.isEmpty && !species.isEmpty
    }
    
    func savePet() {
        guard isFormValid else { return }
        
        isLoading = true
        
        // Simulate a network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Create Pet object and save to Realm
            // This would be replaced with actual Realm code
            
            /*
            let pet = Pet()
            pet.id = UUID().uuidString
            pet.userId = "current_user_id" // Replace with actual user ID
            pet.name = self.name
            pet.species = self.species
            pet.breed = self.breed
            pet.gender = self.gender
            pet.location = self.location
            pet.birthDate = self.birthDate
            pet.weight = Double(self.weight) ?? 0
            pet.lastVetVisit = self.lastVetVisit
            pet.nextVetVisit = self.nextVetVisit
            pet.lastVaccinationDate = self.lastVaccinationDate
            pet.nextVaccinationDate = self.nextVaccinationDate
            pet.foodPreferences = self.foodPreferences
            pet.medicalConditions = self.medicalConditions
            pet.medications = self.medications
            pet.imageData = self.imageData
            
            // Save to Realm
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(pet)
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
