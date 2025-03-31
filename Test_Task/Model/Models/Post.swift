
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
