import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Test_Task") // Имя модели
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Ошибка загрузки CoreData: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения: \(error)")
            }
        }
    }
}

extension CoreDataManager {
    func savePosts(_ posts: [Post]) {
        let context = persistentContainer.viewContext
        for post in posts {
            let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", String(post.id)) // id преобразуем в строку
            do {
                let existingPosts = try context.fetch(fetchRequest)
                if existingPosts.isEmpty {
                    let entity = PostEntity(context: context)
                    entity.id = String(post.id) // Сохраняем id как строку
                    entity.userId = Int64(post.userId)
                    entity.title = post.title
                    entity.body = post.body
                    entity.avatar = post.avatar
                    entity.name = post.name
                    entity.isLiked = post.isLiked
                }
            } catch {
                print("Ошибка при проверке существующих постов: \(error)")
            }
        }
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }

    
    func fetchPosts() -> [Post] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.compactMap { entity in
                guard let idString = entity.id, let id = Int(idString) else { return nil } // Преобразуем id из строки в число
                return Post(
                    id: id,
                    userId: Int(entity.userId),
                    title: entity.title ?? "",
                    body: entity.body ?? "",
                    avatar: entity.avatar,
                    name: entity.name,
                    isLiked: entity.isLiked
                )
            }
        } catch {
            print("Ошибка загрузки данных из CoreData: \(error)")
            return []
        }
    }

    
    /// Удаляет все записи из CoreData
    func removeAll() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PostEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Ошибка удаления всех записей: \(error)")
        }
    }
    
    func updateLikeStatus(for post: Post, isLiked: Bool) {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(post.id)) // id преобразуем в строку
        do {
            let results = try context.fetch(fetchRequest)
            if let postEntity = results.first {
                postEntity.isLiked = isLiked
            } else {
                let newPost = PostEntity(context: context)
                newPost.id = String(post.id) // Сохраняем id как строку
                newPost.isLiked = isLiked
            }
            try context.save()
        } catch {
            print("Ошибка обновления лайка: \(error)")
        }
    }
    
    func fetchLikedPosts() -> Set<String> {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLiked == %@", NSNumber(value: true))
        do {
            let likedPosts = try context.fetch(fetchRequest)
            return Set(likedPosts.compactMap { $0.id }) // Возвращаем Set<String>
        } catch {
            print("Ошибка загрузки лайков из CoreData: \(error)")
            return []
        }
    }

}
