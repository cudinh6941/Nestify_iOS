//
//  GenericListview.swift
//  Nestify
//
//  Created by pham kha dinh on 9/5/25.
//

import Foundation
import SwiftUI

struct GenericListView<T: BaseItem, DetailView: View>: View {
    @ObservedObject var viewModel: GenericListViewModel<T>
    @State private var navigateToAddItem = false
    @EnvironmentObject var coordinator: NavigationCoordinator

    // Theme colors
    private let backgroundColor = Color(hex: "#121212")
    private let cardBackgroundColor = Color(hex: "#1E1E1E")
    private let primaryColor = Color(hex: "#4A9FF5")
    private let secondaryColor = Color(hex: "#2ECC71")
    private let accentColor = Color(hex: "#F1C40F")
    private let textPrimaryColor = Color.white
    private let textSecondaryColor = Color(hex: "#B3B3B3")
    
    let title: String
    let detailViewProvider: (T) -> DetailView
    let addItemViewProvider: () -> AddItemView
    
    init(
        title: String,
        viewModel: GenericListViewModel<T>,
        @ViewBuilder detailViewProvider: @escaping (T) -> DetailView,
        @ViewBuilder addItemViewProvider: @escaping () -> AddItemView
    ) {
        self.title = title
        self.viewModel = viewModel
        self.detailViewProvider = detailViewProvider
        self.addItemViewProvider = addItemViewProvider
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background with gradient
                LinearGradient(
                    gradient: Gradient(colors: [backgroundColor, backgroundColor.opacity(0.85)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header with title
                    HStack {
                        Text(title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(textPrimaryColor)
                        
                        Spacer()
                        
                        Button(action: {
                            // Action for settings or menu
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 22))
                                .foregroundColor(textSecondaryColor)
                                .padding(8)
                                .background(cardBackgroundColor)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Search bar with modern design
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(textSecondaryColor)
                            .font(.system(size: 16))
                        
                        TextField("Tìm kiếm...", text: $viewModel.searchText)
                            .foregroundColor(textPrimaryColor)
                            .font(.system(size: 16))
                            .accentColor(primaryColor)
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(textSecondaryColor)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .padding(12)
                    .background(cardBackgroundColor)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Filter chips with smooth animation
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.filterOptions, id: \.value) { option in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.setFilter(option.value.isEmpty ? nil : option.value)
                                    }
                                }) {
                                    Text(option.label)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(
                                            viewModel.selectedFilter == option.value ||
                                            (viewModel.selectedFilter == nil && option.value.isEmpty) ?
                                                primaryColor : cardBackgroundColor
                                        )
                                        .foregroundColor(
                                            viewModel.selectedFilter == option.value ||
                                            (viewModel.selectedFilter == nil && option.value.isEmpty) ?
                                                Color.white : textSecondaryColor
                                        )
                                        .cornerRadius(20)
                                        .shadow(
                                            color: viewModel.selectedFilter == option.value ||
                                            (viewModel.selectedFilter == nil && option.value.isEmpty) ?
                                                primaryColor.opacity(0.3) : Color.clear,
                                            radius: 4, x: 0, y: 2
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                    
                    // Content area
                    ZStack {
                        // Loading state with better animation
                        if viewModel.isLoading {
                            VStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: primaryColor))
                                    .scaleEffect(1.5)
                                    .padding()
                                
                                Text("Đang tải...")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(textSecondaryColor)
                                    .padding(.top)
                                Spacer()
                            }
                        }
                        // Empty state with improved design
                        else if viewModel.filteredItems.isEmpty {
                            VStack(spacing: 24) {
                                Image(systemName: "tray")
                                    .font(.system(size: 50))
                                    .foregroundColor(textSecondaryColor)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(cardBackgroundColor)
                                            .frame(width: 120, height: 120)
                                    )
                                
                                Text("Không có dữ liệu")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(textPrimaryColor)
                                
                                Group {
                                    if !viewModel.searchText.isEmpty {
                                        Text("Không tìm thấy kết quả cho '\(viewModel.searchText)'")
                                            .font(.system(size: 16, design: .rounded))
                                            .foregroundColor(textSecondaryColor)
                                            .multilineTextAlignment(.center)
                                    } else if viewModel.selectedFilter != nil {
                                        Text("Không có dữ liệu trong danh mục này")
                                            .font(.system(size: 16, design: .rounded))
                                            .foregroundColor(textSecondaryColor)
                                            .multilineTextAlignment(.center)
                                    } else {
                                        Text("Hãy thêm mới để bắt đầu")
                                            .font(.system(size: 16, design: .rounded))
                                            .foregroundColor(textSecondaryColor)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                Button(action: {
                                    navigateToAddItem = true
                                }) {
                                    HStack {
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("Thêm mới")
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(secondaryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                    .shadow(color: secondaryColor.opacity(0.4), radius: 8, x: 0, y: 4)
                                }
                                .padding(.top, 10)
                            }
                            .padding()
                        }
                        // Item list with improved design
                        else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.filteredItems, id: \.id) { item in
                                        NavigationLink(destination: detailViewProvider(item)) {
                                            ItemCard(item: item, viewModel: viewModel)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 80) // Space for FAB
                            }
                            .padding(.top, 4)
                        }
                    }
                }
                
                // Floating Action Button with gradient and animation
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            coordinator.navigate(to: .addMenuItem)
                        }) {
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [secondaryColor, secondaryColor.opacity(0.85)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .clipShape(Circle())
                                .frame(width: 64, height: 64)
                                .shadow(color: secondaryColor.opacity(0.5), radius: 10, x: 0, y: 5)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 24)
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert(isPresented: .init(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Alert(
                title: Text("Lỗi"),
                message: Text(viewModel.errorMessage ?? "Đã xảy ra lỗi không xác định"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// Custom scale animation for buttons
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// Redesigned item card
struct ItemCard<T: BaseItem>: View {
    let item: T
    let viewModel: GenericListViewModel<T>
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar with better design
            ZStack {
                Circle()
                    .fill(viewModel.getCategoryColor(for: item.categoryId))
                    .frame(width: 60, height: 60)
                    .shadow(color: viewModel.getCategoryColor(for: item.categoryId).opacity(0.3), radius: 4, x: 0, y: 2)
                
                Text(viewModel.getItemInitials(item))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            // Details with better typography
            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#FF7675").opacity(0.8))
                    
                    Text(viewModel.getLocationName(for: item.location))
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Color(hex: "#B3B3B3"))
                    
                    Text("•")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#B3B3B3"))
                    
                    Image(systemName: "tag.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#74B9FF").opacity(0.8))
                    
                    Text(viewModel.getCategoryName(for: item.categoryId))
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Color(hex: "#B3B3B3"))
                        .lineLimit(1)
                }
                
                // Date information with better icons and formatting
                Group {
                    if let householdItem = item as? HouseholdItem, let purchaseDate = householdItem.purchaseDate {
                        HStack(spacing: 4) {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#FDCB6E").opacity(0.8))
                            
                            Text(viewModel.formatDate(purchaseDate))
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(Color(hex: "#B3B3B3"))
                            
                            if let warrantyDate = householdItem.warrantyExpiryDate {
                                Text("•")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "#B3B3B3"))
                                
                                Image(systemName: "shield.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#55EFC4").opacity(0.8))
                                
                                Text(viewModel.formatDate(warrantyDate))
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(Color(hex: "#B3B3B3"))
                            }
                        }
                    } else if let pet = item as? Pet, let birthDate = pet.birthDate {
                        HStack(spacing: 4) {
                            Image(systemName: "birthday.cake.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#FF9FF3").opacity(0.8))
                            
                            Text(viewModel.formatDate(birthDate))
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(Color(hex: "#B3B3B3"))
                        }
                    } else if let plant = item as? Plant, let nextWatering = plant.nextWateringDate {
                        HStack(spacing: 4) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#0ABDE3").opacity(0.8))
                            
                            Text(viewModel.formatDate(nextWatering))
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(Color(hex: "#B3B3B3"))
                        }
                    } else if let document = item as? Document, let expiryDate = document.expiryDate {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#FF7675").opacity(0.8))
                            
                            Text(viewModel.formatDate(expiryDate))
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(Color(hex: "#B3B3B3"))
                        }
                    } else if let vehicle = item as? Vehicle, let registrationExpiry = vehicle.registrationExpiryDate {
                        HStack(spacing: 4) {
                            Image(systemName: "car.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#A29BFE").opacity(0.8))
                            
                            Text(viewModel.formatDate(registrationExpiry))
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(Color(hex: "#B3B3B3"))
                        }
                    } else {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#74B9FF").opacity(0.8))
                            
                            Text(viewModel.formatDate(item.createdAt))
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(Color(hex: "#B3B3B3"))
                        }
                    }
                }
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12) {
                // Quantity indicator with better design
                if item.quantity > 1 {
                    Text("\(item.quantity)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .padding(8)
                        .background(Color(hex: "#4A9FF5"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#B3B3B3"))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "#1E1E1E"))
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
        )
    }
}

// Helper extension for hex colors

