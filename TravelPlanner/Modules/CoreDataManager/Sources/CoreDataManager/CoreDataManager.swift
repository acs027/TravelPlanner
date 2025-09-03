
import CoreData
import AppResources

@MainActor
protocol CoreDataManagerProtocol {
    func createFolder(name: String)
    func addLocation(_ location: LocationEntity, to folder: FolderEntity)
    func fetchFolders() -> [FolderEntity]
    func delete(folder: FolderEntity)
    func fetchLocations(in folder: FolderEntity) -> [LocationEntity]
    func deleteLocation(location: LocationEntity)
    func fetchSpecificFolder(id: String) -> FolderEntity?
}


@MainActor
public final class CoreDataManager {
    public static let shared = CoreDataManager()

        private let persistentContainer: NSPersistentContainer

        private init() {
            guard let modelURL = Bundle.module.url(forResource: "TravelPlannerDataModel", withExtension: "momd"),
                  let model = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Failed to load Core Data model")
            }

            persistentContainer = NSPersistentContainer(name: "TravelPlannerDataModel", managedObjectModel: model)
            persistentContainer.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Unresolved error \(error)")
                }
            }
        }

        public var context: NSManagedObjectContext {
            persistentContainer.viewContext
        }

    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed saving context: \(error)")
            }
        }
    }
}

extension CoreDataManager: CoreDataManagerProtocol {
    func createFolder(name: String) {
        let folder = FolderEntity(context: context)
        folder.id = UUID()
        folder.name = name
        saveContext()
    }
    
    func addLocation(_ location: LocationEntity, to folder: FolderEntity) {
        location.folder = folder
        let locations = folder.mutableSetValue(forKey: "locations")
            locations.add(location)
        saveContext()
    }
    
    func delete(folder: FolderEntity) {
        context.delete(folder)
        saveContext()
    }
    
    func fetchLocations(in folder: FolderEntity) -> [LocationEntity] {
        guard let locations = folder.locations as? Set<LocationEntity> else {
              return []
          }
        return locations.map { $0 }
    }
    
    func deleteLocation(location: LocationEntity) {
        context.delete(location)
        saveContext()
    }
    
    func fetchSpecificFolder(id: String) -> FolderEntity? {
        guard let uuid = UUID(uuidString: id) else {
               return nil // invalid UUID string
           }
        let request: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        request.fetchLimit = 1

        return try? context.fetch(request).first
    }
    
    func fetchLocation(by id: String) -> LocationEntity? {
        guard let uuid = UUID(uuidString: id) else {
            return nil
        }
        let request: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", uuid as CVarArg)
        request.fetchLimit = 1
        
        return try? context.fetch(request).first
    }
    
    // Fetch Folders
    func fetchFolders() -> [FolderEntity] {
        let request: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
}

