//
//  ImageEx.swift
//  Nestify
//
//  Created by pham kha dinh on 13/5/25.
//

import UIKit
extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 0.5) else { return nil }
        return imageData.base64EncodedString()
    }
}
