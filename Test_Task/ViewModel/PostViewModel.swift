import Foundation
import Network

//MARK: - Main
class PostsViewModel {
    
    private let avatars = (1...10).map { "userAvatar\($0)" } // ["userAvatar1", "userAvatar2", ..., "userAvatar10"]

    private let names = [
        "Emma Johnson", "Olivia Smith", "Liam Brown", "Noah Wilson", "Ava Martinez",
        "Sophia Anderson", "James Taylor", "Benjamin Harris", "Mia Clark", "Lucas Lewis",
        "Isabella Walker", "Ethan Hall", "Amelia Young", "Alexander Allen", "Charlotte King",
        "Henry Wright", "Daniel Scott", "Evelyn Adams", "Michael Baker", "Grace Nelson"
    ]

    var posts = [Post]()
    var expandedPosts = [Int]()
    var isLoading = false
    private var currentPage = 1
    private let postsPerPage = 20
    
    // Call backs
    var onPostsUpdated: (() -> Void)? // посты обновлены
    var onLoadingStateChanged: ((Bool) -> Void)? // загрузка
    
    private let coreDataManager = CoreDataManager.shared
    
    // Для загрузки данных в бд в фоновом потоке
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    init() {
        monitor.start(queue: queue)
    }
    
    // вызывается в делегате
    func toggleLike(post: Post, isLiked: Bool) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[index].isLiked = isLiked // Обновляем посты в viewModel
        coreDataManager.updateLikeStatus(for: post, isLiked: isLiked) // Обновляем посты в бд
    }

    func fetchPosts() {
        guard !isLoading else { return }
        isLoading = true
        onLoadingStateChanged?(true) // Включаем activityIndicator

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            // Проверяем есть ли подключение к интернету
            if self.monitor.currentPath.status == .unsatisfied {
                // Загружаем из CoreData
                let cachedPosts = self.coreDataManager.fetchPosts()
                DispatchQueue.main.async {
                    self.posts = cachedPosts
                    self.isLoading = false
                    self.onPostsUpdated?()
                    self.onLoadingStateChanged?(false)
                }
            } else {
                // Загружаем с API
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let fetcher = PostsDataFetcher()
                    fetcher.fetchPosts(page: self.currentPage, limit: self.postsPerPage) { result in
                        switch result {
                        case .success(let newPosts):
                            
                            let likedPostIDs = self.coreDataManager.fetchLikedPosts() // Загружаем лайки
                            let updatedPosts = newPosts.map { post -> Post in
                                var updatedPost = post
                                updatedPost.avatar = self.avatars.randomElement()
                                updatedPost.name = self.names.randomElement()
                                updatedPost.isLiked = likedPostIDs.contains(String(post.id)) // Подставляем лайки
                                return updatedPost
                            }

                            DispatchQueue.global(qos: .background).async {
                                self.coreDataManager.savePosts(updatedPosts) // Сохраняем в БД
                            }

                            DispatchQueue.main.async {
                                self.posts.append(contentsOf: updatedPosts)
                                self.currentPage += 1
                                self.onPostsUpdated?()
                            }
                        case .failure(let error):
                            var errorMessage = "Ошибка загрузки постов"
                            switch error {
                            case .networkError(let networkError):
                                errorMessage = "Ошибка сети: \(networkError.localizedDescription)"
                            case .decodingError:
                                errorMessage = "Ошибка декодирования данных"
                            case .invalidResponse:
                                errorMessage = "Некорректный ответ от сервера"
                            case .unknownError:
                                errorMessage = "Неизвестная ошибка"
                            }
                            // Распечатываем ошибку в консоль
                            DispatchQueue.main.async {
                                print(errorMessage)
                            }
                        }
                        
                        // Убираем загрузку
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.onLoadingStateChanged?(false)
                        }
                    }
                }
            }
        }
    }


}
