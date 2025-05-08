//
//  OverviewCard.swift
//  Nestify
//
//  Created by pham kha dinh on 4/5/25.
//

import Foundation
import SwiftUI
struct NotificationItem {
    let type: NotificationType
    let count: Int
    let title: String
    let icon: String
    let color: Color
}

enum NotificationType {
    case today, attention, deadline
}

struct OverviewCard: View {
    let item: NotificationItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: item.icon)
                .foregroundColor(.white)
                .padding()
                .background(Color.gray.opacity(0.5))
                .clipShape(Circle())

            Text(item.title)
                .font(.headline)
            Text("\(item.count) mục")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 160)
        .background(item.color)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
