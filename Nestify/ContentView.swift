//
//  ContentView.swift
//  Nestify
//
//  Created by pham kha dinh on 4/5/25.
//
import SwiftUI
struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @StateObject var coordinator = NavigationCoordinator()
    @StateObject var sheetCoordinator = SheetCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                    case .calendar:
                        EmptyView()
                    case .statistics:
                        EmptyView()
                    case .settings:
                        EmptyView()
                    }
                }

                CustomTabBar(selectedTab: $selectedTab)
            }
            .sheet(item: $sheetCoordinator.activeSheet) { sheet in
                switch sheet {
                case .addMenu:
                    AddMenuView()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .addMenuItem:
                    AddItemView()
                case .listItem:
                    HouseholdItemsView()
                case .addPet:
                    AddPetView()
                case .addPlant:
                    AddPlantView()
                case .addVehicle:
                    AddVehicleView()
                }
            }
        }

        .environmentObject(sheetCoordinator)
        .environmentObject(coordinator)
    }
}


