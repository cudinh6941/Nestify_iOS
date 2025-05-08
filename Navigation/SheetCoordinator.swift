//
//  SheetCoordinator.swift
//  Nestify
//
//  Created by pham kha dinh on 5/5/25.
//

import SwiftUI
class SheetCoordinator: ObservableObject {
    @Published var activeSheet: AppSheet?
    
    func present(sheet: AppSheet) {
        activeSheet = sheet
    }
    
    func dismiss() {
        activeSheet = nil
    }
}
