//
//  MonthBudgetView.swift
//  Nestify
//
//  Created by pham kha dinh on 4/5/25.
//

import SwiftUI
struct MonthBudgetView: View {
    let usedPercentage: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ngân sách tháng")
                .font(.headline)
            ProgressView(value: usedPercentage)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
            Text("Đã dùng: \(Int(usedPercentage * 100))%")
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.purple)
        .cornerRadius(12)
    }
}
