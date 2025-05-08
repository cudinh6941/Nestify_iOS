//
//  HomeHeaderView.swift
//  Nestify
//
//  Created by pham kha dinh on 4/5/25.
//

import Foundation
import SwiftUI
struct HomeHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Xin chào,")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("Nguyễn Văn A")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    Text("Hà Nội · 28°C")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(Text("A").bold())
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
}
