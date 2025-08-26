
import CoreData
import AppResources

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

extension CoreDataManager {
    
    // Create Folder
    public func createFolder(name: String) -> FolderEntity {
        let folder = FolderEntity(context: context)
        folder.id = UUID()
        folder.name = name
        folder.locations = []
        saveContext()
        return folder
    }
    
    // Add Location to Folder
    public func addLocation(_ location: TravelLocation, to folder: FolderEntity) {
        let entity = LocationEntity(context: context)
        entity.update(from: location)
        entity.folder = folder
        let locations = folder.mutableSetValue(forKey: "locations")
            locations.add(entity)
        saveContext()
    }

    // Fetch Folders
    public func fetchFolders() -> [FolderEntity] {
        let request: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    // Fetch specific Folder by id
    public func fetchSpecificFolder(id: String) -> FolderEntity? {
        guard let uuid = UUID(uuidString: id) else {
               return nil // invalid UUID string
           }
        let request: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        request.fetchLimit = 1
        
        return try? context.fetch(request).first
    }
    
    public func delete(folder: FolderEntity) {
        context.delete(folder)
        saveContext()
    }
    

    // Fetch Locations in Folder
    public func fetchLocations(in folder: FolderEntity) -> [TravelLocation] {
        guard let locations = folder.locations as? Set<LocationEntity> else {
              return []
          }
          return locations.map { $0.toDomain() }
    }
}

