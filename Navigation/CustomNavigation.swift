//
//  CustomNavigation.swift
//  Nestify
//
//  Created by pham kha dinh on 6/5/25.
//

import SwiftUI
struct CustomNavigationView<Content: View>: View {
    let content: Content
    @State private var path = NavigationPath()

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationStack(path: $path) {
            content
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("App Title")
                            .font(.headline)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            // Back button action
                            path.removeLast()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Quay lại")
                            }
                        }
                    }
                }
        }
    }
}
