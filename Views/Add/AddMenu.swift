//
//  AddMenu.swift
//  Nestify
//
//  Created by pham kha dinh on 4/5/25.
//

import Foundation
import SwiftUI

struct AddMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var sheetCoordinator: SheetCoordinator
    @EnvironmentObject var coordinator: NavigationCoordinator


    let categories = CategoryRepository.sharedCategories

    func navigate(to categoryId: String) {
        // Logic để chuyển màn hình tùy theo `categoryId`
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }

                VStack(spacing: 12) {
                    ForEach(categories) { category in
                        Button(action: {
                            sheetCoordinator.dismiss()
                            coordinator.navigate(to: .addMenuItem)
                        }) {
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(category.color.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: category.iconName)
                                            .foregroundColor(category.color)
                                            .font(.system(size: 20, weight: .bold))
                                    )

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(category.title)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(category.label)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(hex: "#2b2b2c"))
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                        }
                    }

                    Divider().padding(.vertical, 8)

                    Button(action: {
                        navigate(to: "custom")
                    }) {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(Color.purple.opacity(0.1))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "plus.square.fill")
                                        .foregroundColor(.purple)
                                        .font(.system(size: 22, weight: .bold))
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tạo mục mới")
                                    .font(.headline)
                                Text("Thêm danh mục tùy chỉnh")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.purple.opacity(0.1))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "diamond.fill")
                                        .foregroundColor(.purple)
                                )
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.purple, style: StrokeStyle(lineWidth: 2, dash: [5]))
                        )
                    }
                }

                Spacer()
            }
            .padding()
            .background(Color.black)
        }
    }
}
