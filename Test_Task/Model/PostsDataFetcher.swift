import Alamofire

// Структура для поста
struct Post: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

// Класс для получения постов
class PostsDataFetcher {
    
    // Метод для загрузки данных о постах
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
        
        // Используем Alamofire для запроса
        AF.request(url, method: .get).validate().responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
