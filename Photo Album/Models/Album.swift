
import Foundation
struct Album: Codable {
    let userID, id: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}
