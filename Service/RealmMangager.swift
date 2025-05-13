//
//  RealmMangager.swift
//  Nestify
//
//  Created by pham kha dinh on 7/5/25.
//
//
//  RealmManager.swift
//  Nestify
//
//  Created by pham kha dinh on 7/5/25.
//

import SwiftUI
import Combine
import RealmSwift

class RealmManager: ObservableObject {
    static let shared = RealmManager()

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?

    private var notificationTokens: [NotificationToken] = []

    private let dataChangeSubject = PassthroughSubject<Void, Never>()
    var dataChanged: AnyPublisher<Void, Never> {
        dataChangeSubject.eraseToAnyPublisher()
    }

    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorOccurred: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }

    private init() {
        setupRealm()
    }

    func setupRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                // Xử lý migration khi schema thay đổi
                if oldSchemaVersion < 1 {
                    // Không cần thực hiện việc gì khi đây là version đầu tiên
                }
            },
            objectTypes: [
                User.self,
                Category.self,
                BaseItem.self,
                HouseholdItem.self,
                Pet.self,
                Plant.self,
                Document.self,
                Vehicle.self,
                CareRecord.self,
                Notification.self,
                Activity.self,
                Task.self,
                NotificationRule.self
            ]
        )
        
        Realm.Configuration.defaultConfiguration = config
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            print("Realm file path: \(fileURL)")
        }
    }

    // MARK: - Helper Functions

    func generateUUID() -> String {
        return UUID().uuidString
    }

    func performTransaction<T>(_ operation: () throws -> T) -> Result<T, Error> {
        do {
            let realm = try Realm()
            var result: T!
            try realm.write {
                result = try operation()
            }
            self.dataChangeSubject.send()
            return .success(result)
        } catch {
            self.errorSubject.send(error)
            self.error = error
            return .failure(error)
        }
    }

    func performTransactionPublisher<T>(_ operation: @escaping () throws -> T) -> AnyPublisher<T, Error> {
        Future<T, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "RealmManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            let result = self.performTransaction(operation)
            switch result {
            case .success(let value): promise(.success(value))
            case .failure(let error): promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - CRUD Publishers

    func createEntityPublisher<T: Object>(_ entity: T) -> AnyPublisher<T, Error> {
        performTransactionPublisher {
            let realm = try Realm()
            realm.add(entity)
            return entity
        }
    }

    func updateEntityPublisher<T: Object>(_ type: T.Type, id: String, with updates: @escaping (T) -> Void) -> AnyPublisher<T, Error> {
        performTransactionPublisher {
            let realm = try Realm()
            guard let entity = realm.object(ofType: type, forPrimaryKey: id) else {
                throw NSError(domain: "RealmManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])
            }
            updates(entity)
            if entity.objectSchema.properties.contains(where: { $0.name == "updatedAt" }) {
                entity.setValue(Date(), forKey: "updatedAt")
            }
            return entity
        }
    }

    func deleteEntityPublisher<T: Object>(_ entity: T) -> AnyPublisher<Void, Error> {
        performTransactionPublisher {
            let realm = try Realm()
            realm.delete(entity)
        }
        .map { _ in () }
        .eraseToAnyPublisher()
    }

    func entityPublisher<T: Object>(_ type: T.Type) -> AnyPublisher<Results<T>, Error> {
        Future<Results<T>, Error> { [weak self] promise in
            print("Started load for \(T.self)")
            guard let self = self else {
                promise(.failure(NSError(domain: "RealmManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            do {
                let realm = try Realm()
                let results = realm.objects(type)
                
                // Chỉ thông báo khi có THAY ĐỔI thực sự, không thông báo khi load ban đầu
                let token = results.observe { changes in
                    switch changes {
                    case .initial:
                        // KHÔNG thông báo khi lấy dữ liệu ban đầu
                        print("Initial data loaded for \(T.self)")
                    case .update(_, let deletions, let insertions, let modifications):
                        // Chỉ thông báo khi có thay đổi thực sự
                        if !deletions.isEmpty || !insertions.isEmpty || !modifications.isEmpty {
                            print("Data changed for \(T.self): deletions=\(deletions.count), insertions=\(insertions.count), modifications=\(modifications.count)")
                            self.dataChangeSubject.send()
                        }
                    case .error(let error):
                        self.errorSubject.send(error)
                    }
                }
                
                self.notificationTokens.append(token)
                promise(.success(results))
            } catch {
                self.errorSubject.send(error)
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func observeEntity<T: Object>(_ type: T.Type, id: String) -> AnyPublisher<T?, Error> {
        Future<T?, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "RealmManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            do {
                let realm = try Realm()
                guard let entity = realm.object(ofType: type, forPrimaryKey: id) else {
                    promise(.success(nil))
                    return
                }
                let token = entity.observe { [weak self] change in
                    switch change {
                    case .change, .deleted:
                        self?.dataChangeSubject.send()
                    case .error(let error):
                        self?.errorSubject.send(error)
                    }
                }
                self.notificationTokens.append(token)
                promise(.success(entity))
            } catch {
                self.errorSubject.send(error)
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func invalidateAllTokens() {
        notificationTokens.forEach { $0.invalidate() }
        notificationTokens.removeAll()
    }

    deinit {
        invalidateAllTokens()
    }
}



