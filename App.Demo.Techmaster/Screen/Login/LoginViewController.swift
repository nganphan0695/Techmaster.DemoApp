
import UIKit
import ActiveLabel
import Alamofire
import SwiftHEXColors
import MBProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var clearEmailView: UIView!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailErrorView: UIView!
    
    @IBOutlet weak var facbookView: UIView!
    @IBOutlet weak var faceBookButton: UIButton!
    
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var signUpLabel: ActiveLabel!
    
    @IBOutlet weak var passwordErrorView: UIView!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var clearPassImage: UIImageView!
    @IBOutlet weak var clearPassView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facbookView.layer.cornerRadius = 10
        googleView.layer.cornerRadius = 10
        
        emailText.layer.cornerRadius = 10
        emailText.layer.borderWidth = 1
        
        passwordText.layer.cornerRadius = 10
        passwordText.layer.borderWidth = 1
        
        passwordText.isSecureTextEntry = true
        
        setupEmailView()
        setupPasswordView()
        
        signUpLabelSetup()
    }
    
    func setupEmailView(){
        emailText.backgroundColor = .white
        clearEmailView.backgroundColor = .white
        emailText.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        emailText.backgroundColor = .white
        
        clearEmailView.isHidden = true
        emailErrorView.isHidden = true
    }
    
    func setupPasswordView(){
        passwordText.backgroundColor = .white
        clearPassView.backgroundColor = .white
        passwordText.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        
        passwordErrorView.isHidden = true
    }
    
    func emailError(textError: String){
        emailErrorView.isHidden = false
        
        emailText.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        emailText.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        clearEmailView.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        emailErrorLabel.text = textError
    }
    
    @IBAction func clearEmail(_ sender: Any) {
        emailText.text = ""
        setupEmailView()
    }
    
    func passError(textError: String){
        passwordErrorView.isHidden = false
        
        passwordText.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        passwordText.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        clearPassView.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)

        passwordErrorLabel.text = textError
    }
    @IBAction func clearPassword(_ sender: Any) {
        passwordText.isSecureTextEntry = !passwordText.isSecureTextEntry
        setupPasswordView()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let email: String = emailText.text ?? ""
        let pass: String = passwordText.text ?? ""
        
        var emailValid = false
        var passwordValid = false
        
        if email.isEmpty{
            emailError(textError: "Email can't empty")
        }else if email.count >= 40 {
            emailError(textError: "Email phải ít hơn 40 ký tự")
            clearEmailView.isHidden = false
        }else{
            emailValid = true
            setupEmailView()
        }

        if pass.isEmpty{
            passError(textError: "Password can't empty")
        }else if pass.count < 6 || pass.count > 40 {
            passError(textError: "Password phải từ 6 - 40 ký tự")
        }else{
            passwordValid = true
            setupPasswordView()
        }
        
        if emailValid == true && passwordValid == true {
            callAPI()
        }
        
    }
    
    func signUpLabelSetup(){
        let customType = ActiveType.custom(pattern: "\\sSign Up\\b")
        signUpLabel.enabledTypes = [customType]
        signUpLabel.text = "don’t have an account ? Sign Up"
        signUpLabel.customColor[customType] = UIColor.blue

        signUpLabel.handleCustomTap(for: customType) { element in
            print("Custom type tapped: \(element)")
        }

        signUpLabel.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes
            atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 15)
            return atts
        }
    }
    
    func callAPI(){
        self.showLoading(isShow: true)
        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/login"
        AF.request(domain,
                   method: .post,
                   parameters: [
                    "email": emailText.text ?? "",
                    "password": passwordText.text ?? ""],
                   encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseData { (afDataResponse: AFDataResponse<Data>) in
            self.showLoading(isShow: false)
            switch afDataResponse.result{
            case.success(let data):
                print("Success")
                print(data)
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        self.loginFailure(title: "Error", message: "Something went wrong")
                        return
                    }
                   print("json")
                    print(json)
                    
                    let accessToken = json["access_token"] as? String
                    let refreshToken = json["refresh_token"] as? String
                    let userId = json["user_id"] as? String
                    
                    if accessToken != nil {
                        self.loginSuccess()
                    }else{
                        self.loginFailure(title: "Error", message: "Something went wrong")
                    }
                    
                } catch {
                    print("errorMsg")
                    self.loginFailure(title: "Error", message: "Something went wrong")
                }
                break
            case.failure(let err):
                print("failure")
                print(err.errorDescription ?? "")
                
                do {
                    guard let data = afDataResponse.data else {
                        self.loginFailure(title: "Error", message: "Something went wrong")
                        return
                    }
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        self.loginFailure(title: "Error", message: "Something went wrong")
                        return
                    }
                    
                    if let type = json["type"] as? String,
                       let message = json["message"] as? String{
                        self.loginFailure(title: type, message: message)
                        print(json)
                    } else {
                        self.loginFailure(title: "Error", message: "Something went wrong")
                    }
                } catch {
                    print("errorMsg")
                    self.loginFailure(title: "Error", message: "Something went wrong")
                }
                break
            }
        }
    }
    
    func loginSuccess(){
        let alertVC = UIAlertController(title: "Thông báo", message: "Login thành công", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(cancel)
        present(alertVC, animated: true)
    }
    
    func loginFailure(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(cancel)
        present(alertVC, animated: true)
    }
    
    func showLoading(isShow: Bool) {

        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
   
}
