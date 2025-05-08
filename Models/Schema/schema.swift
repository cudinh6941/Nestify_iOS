import Foundation
import RealmSwift

// MARK: - Các mô hình cơ bản

// User Model
class User: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var fullName: String
    @Persisted var email: String?
    @Persisted var phone: String?
    @Persisted var passwordHash: String?
    @Persisted var preferences: String? // JSON string cho cài đặt người dùng
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    
    convenience init(id: String, fullName: String, email: String? = nil, phone: String? = nil) {
        self.init()
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// Category Model - Danh mục
class Category: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var icon: String?
    @Persisted var color: String?
    @Persisted var parentId: String? // Cho phép phân cấp danh mục
    @Persisted var userId: String // Người tạo danh mục
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    
    convenience init(id: String, name: String, userId: String, icon: String? = nil, color: String? = nil) {
        self.init()
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.userId = userId
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// BaseItem - Lớp cơ sở cho tất cả các loại đối tượng
class BaseItem: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userId: String
    @Persisted var name: String
    @Persisted var descriptionText: String?
    @Persisted var categoryId: String?
    @Persisted var location: String?
    @Persisted var imageUrl: String?
    @Persisted var status: String = "active"
    @Persisted var tags: List<String>
    @Persisted var quantity: Int = 1
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    
    // Virtual property - loại đối tượng, được ghi đè bởi các lớp con
    var itemType: String {
        return "base"
    }
    
    // Liên kết với User và Category
    var user: LinkingObjects<User> {
        return LinkingObjects(fromType: User.self, property: "id")
    }
    
    var category: LinkingObjects<Category> {
        return LinkingObjects(fromType: Category.self, property: "id")
    }
}

// MARK: - Các mô hình cụ thể cho từng loại đối tượng

// Household Item - Vật dụng trong nhà
class HouseholdItem: BaseItem {
    @Persisted var brand: String?
    @Persisted var model: String?
    @Persisted var serialNumber: String?
    @Persisted var purchaseDate: Date?
    @Persisted var warrantyExpiryDate: Date?
    @Persisted var purchasePrice: Double?
    @Persisted var currentValue: Double?
    @Persisted var condition: String? // new, good, fair, poor
    @Persisted var maintenanceInterval: Int? // Số ngày giữa các lần bảo trì
    @Persisted var lastMaintenanceDate: Date?
    @Persisted var nextMaintenanceDate: Date?
    
    override var itemType: String {
        return "household"
    }
}

// Pet - Thú cưng
class Pet: BaseItem {
    @Persisted var species: String?
    @Persisted var breed: String?
    @Persisted var gender: String?
    @Persisted var birthDate: Date?
    @Persisted var weight: Double?
    @Persisted var lastVetVisit: Date?
    @Persisted var nextVetVisit: Date?
    @Persisted var lastVaccinationDate: Date?
    @Persisted var nextVaccinationDate: Date?
    @Persisted var foodPreferences: String?
    @Persisted var medicalConditions: String?
    @Persisted var medications: String?
    
    override var itemType: String {
        return "pet"
    }
}

// Plant - Cây cối
class Plant: BaseItem {
    @Persisted var species: String?
    @Persisted var plantingDate: Date?
    @Persisted var wateringFrequency: Int? // Số ngày giữa các lần tưới nước
    @Persisted var lastWateringDate: Date?
    @Persisted var nextWateringDate: Date?
    @Persisted var fertilizingFrequency: Int? // Số ngày giữa các lần bón phân
    @Persisted var lastFertilizingDate: Date?
    @Persisted var nextFertilizingDate: Date?
    @Persisted var sunlightRequirements: String? // full_sun, partial_shade, shade
    @Persisted var soilType: String?
    @Persisted var notes: String?
    
    override var itemType: String {
        return "plant"
    }
}

// Document - Tài liệu
class Document: BaseItem {
    @Persisted var documentType: String? // passport, id_card, contract, etc.
    @Persisted var documentNumber: String?
    @Persisted var issueDate: Date?
    @Persisted var expiryDate: Date?
    @Persisted var issuingAuthority: String?
    @Persisted var fileUrl: String? // URL để lưu trữ tệp số hóa
    @Persisted var reminderDays: Int? // Số ngày trước khi hết hạn để nhắc nhở
    @Persisted var isConfidential: Bool = false
    @Persisted var notes: String?
    
    override var itemType: String {
        return "document"
    }
}

// Vehicle - Phương tiện
class Vehicle: BaseItem {
    @Persisted var vehicleType: String? // car, motorcycle, bicycle, etc.
    @Persisted var make: String?
    @Persisted var model: String?
    @Persisted var year: Int?
    @Persisted var licensePlate: String?
    @Persisted var vin: String? // Vehicle Identification Number
    @Persisted var color: String?
    @Persisted var purchaseDate: Date?
    @Persisted var purchasePrice: Double?
    @Persisted var currentOdometer: Double? // Kilometers or miles
    @Persisted var insuranceExpiryDate: Date?
    @Persisted var registrationExpiryDate: Date?
    @Persisted var lastServiceDate: Date?
    @Persisted var nextServiceDate: Date?
    @Persisted var serviceInterval: Int? // Distance hoặc ngày
    @Persisted var fuelType: String? // gasoline, diesel, electric, hybrid
    @Persisted var storageLocation: String? // garage, street, etc.
    
    override var itemType: String {
        return "vehicle"
    }
}

// MARK: - Các mô hình hỗ trợ

// CareRecord - Lịch sử chăm sóc
class CareRecord: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userId: String
    @Persisted var itemId: String // ID của BaseItem
    @Persisted var itemType: String // Loại đối tượng
    @Persisted var careType: String // watering, feeding, vaccination, oil_change, etc.
    @Persisted var notes: String?
    @Persisted var cost: Double?
    @Persisted var timestamp: Date
    @Persisted var nextCareDate: Date?
    @Persisted var photos: List<String> // URLs của hình ảnh
    @Persisted var createdAt: Date
    
    convenience init(id: String, userId: String, itemId: String, itemType: String, careType: String) {
        self.init()
        self.id = id
        self.userId = userId
        self.itemId = itemId
        self.itemType = itemType
        self.careType = careType
        self.timestamp = Date()
        self.createdAt = Date()
    }
}

// Notification - Thông báo
class Notification: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userId: String
    @Persisted var title: String
    @Persisted var message: String?
    @Persisted var itemId: String? // ID của BaseItem
    @Persisted var itemType: String? // Loại đối tượng
    @Persisted var triggerDate: Date // Khi nào sẽ hiển thị thông báo
    @Persisted var priority: Int = 0 // 0: normal, 1: important, 2: urgent
    @Persisted var sent: Bool = false
    @Persisted var read: Bool = false
    @Persisted var type: String // expiry_warning, care_reminder, etc.
    @Persisted var recurrenceRule: String? // Quy tắc lặp lại
    @Persisted var data: String? // JSON data bổ sung
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    
    convenience init(id: String, userId: String, title: String, triggerDate: Date, type: String) {
        self.init()
        self.id = id
        self.userId = userId
        self.title = title
        self.triggerDate = triggerDate
        self.type = type
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// Activity - Nhật ký hoạt động
class Activity: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userId: String
    @Persisted var action: String // create, update, delete, care, etc.
    @Persisted var itemId: String?
    @Persisted var itemType: String?
    @Persisted var descriptionText: String?
    @Persisted var timestamp: Date
    @Persisted var details: String? // JSON string cho chi tiết bổ sung
    
    convenience init(id: String, userId: String, action: String, itemId: String? = nil, itemType: String? = nil) {
        self.init()
        self.id = id
        self.userId = userId
        self.action = action
        self.itemId = itemId
        self.itemType = itemType
        self.timestamp = Date()
    }
}

// Task - Công việc, nhiệm vụ
class Task: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userId: String
    @Persisted var title: String
    @Persisted var descriptionText: String?
    @Persisted var dueDate: Date?
    @Persisted var completedAt: Date?
    @Persisted var priority: Int = 0 // 0: normal, 1: important, 2: urgent
    @Persisted var status: String = "pending" // pending, completed, cancelled
    @Persisted var itemId: String? // Liên kết đến đối tượng
    @Persisted var itemType: String? // Loại đối tượng
    @Persisted var reminderDate: Date?
    @Persisted var recurrence: String? // Quy tắc lặp lại
    @Persisted var tags: List<String>
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    
    convenience init(id: String, userId: String, title: String) {
        self.init()
        self.id = id
        self.userId = userId
        self.title = title
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// NotificationRule - Quy tắc tạo thông báo tự động
class NotificationRule: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userId: String
    @Persisted var name: String
    @Persisted var itemType: String? // Loại đối tượng áp dụng
    @Persisted var categoryId: String? // Danh mục áp dụng
    @Persisted var event: String // Sự kiện kích hoạt (expiry, service_due, etc.)
    @Persisted var daysInAdvance: Int = 3 // Số ngày thông báo trước sự kiện
    @Persisted var title: String // Mẫu tiêu đề thông báo
    @Persisted var message: String // Mẫu nội dung thông báo
    @Persisted var priority: Int = 0
    @Persisted var isActive: Bool = true
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    
    convenience init(id: String, userId: String, name: String, event: String, title: String, message: String) {
        self.init()
        self.id = id
        self.userId = userId
        self.name = name
        self.event = event
        self.title = title
        self.message = message
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Thiết lập Realm


