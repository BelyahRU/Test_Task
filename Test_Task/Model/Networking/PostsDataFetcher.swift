import Alamofire

enum PostsDataFetcherError: Error {
    case networkError(Error) // Ошибка сети
    case decodingError // Ошибка декодирования данных
    case invalidResponse // Некорректный ответ сервера
    case unknownError // Неизвестная ошибка
}


class PostsDataFetcher {
    
    func fetchPosts(page: Int, limit: Int, completion: @escaping (Result<[Post], PostsDataFetcherError>) -> Void) {
        // Загружаем по 20 постов
        let url = "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=\(limit)"
        
        AF.request(url, method: .get).validate().responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                // Обработка ошибок
                if let afError = error.asAFError {
                    switch afError {
                    case .invalidURL(_):
                        completion(.failure(.invalidResponse))
                    case .responseValidationFailed(_):
                        completion(.failure(.invalidResponse))
                    default:
                        completion(.failure(.networkError(error)))
                    }
                } else {
                    completion(.failure(.networkError(error)))
                }
            }
        }
    }
}
