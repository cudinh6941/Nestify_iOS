//
//  CategoryCard.swift
//  Nestify
//
//  Created by pham kha dinh on 4/5/25.
//

import SwiftUI


struct CategoryCard: View {
    let item: CategoryItem

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: item.iconName)
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                .foregroundColor(.white)
            Text(item.title)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(item.count ?? 0) \(item.label)")
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(item.color)
        .cornerRadius(12)
    }
}
