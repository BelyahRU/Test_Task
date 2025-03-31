import Alamofire


struct Post: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    var avatar: String?
    var name: String?
    var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, userId, title, body, avatar, name
    }
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
