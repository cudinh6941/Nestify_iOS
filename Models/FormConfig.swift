import Foundation
enum FieldType {
    case text, dropdown, datepicker, image, textarea
}

struct Field: Identifiable {
    let id = UUID()
    let label: String
    let type: FieldType
}
