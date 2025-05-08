//
//  CustomTabBar.swift
//  Nestify
//
//  Created by pham kha dinh on 4/5/25.
//
import SwiftUI

enum Tab {
    case home, calendar, statistics, settings
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @EnvironmentObject var sheetCoordinator: SheetCoordinator

    var body: some View {
        HStack {
            tabItem(icon: "house.fill", tab: .home)
            tabItem(icon: "calendar", tab: .calendar)

            Button(action: {
                sheetCoordinator.present(sheet: .addMenu)
            }) {
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 60, height: 60)
                        .shadow(radius: 4)
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
                .offset(y: -25)
            }

            tabItem(icon: "chart.bar", tab: .statistics)
            tabItem(icon: "gear", tab: .settings)
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color(hex: "#2b2b2c"))
    }

    private func tabItem(icon: String, tab: Tab) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                Text(title(for: tab))
                    .font(.caption)
                    .foregroundColor(selectedTab == tab ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func title(for tab: Tab) -> String {
        switch tab {
        case .home: return "Trang chủ"
        case .calendar: return "Lịch"
        case .statistics: return "Thống kê"
        case .settings: return "Cài đặt"
        }
    }
}

