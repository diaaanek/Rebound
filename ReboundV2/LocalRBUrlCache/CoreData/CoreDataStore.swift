//
//  RBUrlCoreData.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import CoreData

public final class CoreDataStore {
    private static let modelName = "ReboundV2"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }

    public init(storeURL: URL) throws {
        guard let model = CoreDataStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: CoreDataStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }

    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    public func deleteItem(objectId uId: String, completion: @escaping (Result<Void,Error>) -> ()){
         perform { context in
             completion(Result {
                 let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: URL(string:uId)!)
                let managedObject = context.object(with: objectId!)
                 context.delete(managedObject)
                 try context.save()
             })
         }
     }
    func objectId(stringId: String) -> NSManagedObjectID? {
        return context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: URL(string:stringId)!)
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
