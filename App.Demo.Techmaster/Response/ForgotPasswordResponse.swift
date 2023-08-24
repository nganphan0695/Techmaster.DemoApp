
import Foundation
struct ForgotPasswordResponse: Decodable {
    var message: String?
    
    enum CodingKeys: String, CodingKey{
        case message = "message"
    }
}

