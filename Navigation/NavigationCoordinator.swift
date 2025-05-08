//
//  NavigationCoordinator.swift
//  Nestify
//
//  Created by pham kha dinh on 5/5/25.
//

import SwiftUI
class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate (to route: AppRoute) {
        path.append(route)
    }
    
    func goBack() {
        path.removeLast()
    }
    func popToRoot() {
        path.removeLast(path.count)
    }
}
