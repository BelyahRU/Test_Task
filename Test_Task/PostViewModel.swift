import Foundation

class PostsViewModel {
    var posts = [Post]()
    var expandedPosts = Array<Int>()
    var isLoading = false
    var currentPage = 1
    let postsPerPage = 20
    var onPostsUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    func fetchPosts() {
        guard !isLoading else { return }
        isLoading = true
        onLoadingStateChanged?(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            let fetcher = PostsDataFetcher()
            fetcher.fetchPosts(page: self.currentPage, limit: self.postsPerPage) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let newPosts):
                        self.posts.append(contentsOf: newPosts)
                        self.currentPage += 1
                        self.onPostsUpdated?()
                    case .failure(let error):
                        print("Ошибка при загрузке постов: \(error)")
                    }
                    
                    self.isLoading = false
                    self.onLoadingStateChanged?(false)
                }
            }
        }
    }
}
