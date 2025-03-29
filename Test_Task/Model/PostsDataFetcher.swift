import Alamofire


struct Post: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}


class PostsDataFetcher {
    func fetchPosts(page: Int, limit: Int, completion: @escaping (Result<[Post], Error>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=\(limit)"
        
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
