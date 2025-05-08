//
//  AppSheet.swift
//  Nestify
//
//  Created by pham kha dinh on 5/5/25.
//

import SwiftUI
enum AppSheet: Identifiable {
    case addMenu
//    case addMenuItem
//    case editItem(id: UUID)

    var id: String {
        switch self {
        case .addMenu: return "addMenu"
//        case .addMenuItem: return "addMenuItem"
//        case .editItem(let id): return "editItem_\(id)"
        }
    }
}

