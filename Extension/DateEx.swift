//
//  DateEx.swift
//  Nestify
//
//  Created by pham kha dinh on 8/5/25.
//

import Foundation
extension Date {
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
