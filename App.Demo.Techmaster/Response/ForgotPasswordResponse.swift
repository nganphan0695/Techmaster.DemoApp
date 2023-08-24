
import Foundation
struct ForgotPasswordResponse: Decodable {
    var message: String?
    
    enum CodingKeys: String, CodingKey{
        case message = "message"
    }
}

struct ChangePasswordResponse: Decodable {
    var message: String?
    var pin_code: String?
    var new_password: String?
    
    enum CodingKeys: String, CodingKey{
        case message = "message"
        case pin_code = "pin_code"
        case new_password = "new_password"
    }
}
