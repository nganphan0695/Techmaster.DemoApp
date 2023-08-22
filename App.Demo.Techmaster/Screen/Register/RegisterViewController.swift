
import UIKit
import ActiveLabel
import Alamofire
import SwiftHEXColors
import MBProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var passErrorViewHeightContrain: NSLayoutConstraint!
    @IBOutlet weak var emailErrorViewHeightContrain: NSLayoutConstraint!
    @IBOutlet weak var nameErrorViewHeightContrain: NSLayoutConstraint!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var clearEmailView: UIView!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailErrorView: UIView!
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var nameErrorView: UIView!
    @IBOutlet weak var clearNameView: UIView!
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var facbookView: UIView!
    @IBOutlet weak var faceBookButton: UIButton!
    
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var loginLabel: ActiveLabel!
    
    @IBOutlet weak var passwordErrorView: UIView!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var clearPassView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facbookView.layer.cornerRadius = 10
        googleView.layer.cornerRadius = 10
        
        emailText.layer.cornerRadius = 10
        emailText.layer.borderWidth = 1
        
        passwordText.layer.cornerRadius = 10
        passwordText.layer.borderWidth = 1
        
        nameText.layer.cornerRadius = 10
        nameText.layer.borderWidth = 1
        
        passwordText.isSecureTextEntry = true
        nameText.autocorrectionType = .no
        emailText.autocorrectionType = .no
        passwordText.autocorrectionType = .no
        
        
        setupEmailView()
        setupPasswordView()
        setupNameView()
        
        loginLabelSetup()
    }
    
    func setupEmailView(){
        emailText.backgroundColor = .white
        clearEmailView.backgroundColor = .white
        emailText.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        
        clearEmailView.isHidden = true
        emailErrorView.isHidden = true
        
        //        emailErrorViewHeightContrain.constant = 0
        
    }
    
    func setupPasswordView(){
        passwordText.backgroundColor = .white
        clearPassView.backgroundColor = .white
        passwordText.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        
        passwordErrorView.isHidden = true
        
        //        passErrorViewHeightContrain.constant = 0
    }
    
    func setupNameView(){
        nameText.backgroundColor = .white
        clearNameView.backgroundColor = .white
        nameText.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        
        clearNameView.isHidden = true
        nameErrorView.isHidden = true
        
        //        nameErrorViewHeightContrain.constant = 0
    }
    
    func emailError(textError: String){
        emailErrorView.isHidden = false
        
        emailText.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        emailText.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        clearEmailView.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        emailErrorLabel.text = textError
        //        emailErrorViewHeightContrain.constant = 21
    }
    
    @IBAction func clearEmail(_ sender: Any) {
        emailText.text = ""
        setupEmailView()
    }
    
    func nameError(textError: String){
        nameErrorView.isHidden = false
        
        nameText.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        nameText.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        clearNameView.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        nameErrorLabel.text = textError
        
        //        nameErrorViewHeightContrain.constant = 21
    }
    @IBAction func clearName(_ sender: Any) {
        nameText.text = ""
        setupNameView()
    }
    
    func passError(textError: String){
        passwordErrorView.isHidden = false
        
        passwordText.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        passwordText.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        clearPassView.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        
        passwordErrorLabel.text = textError
        //        passErrorViewHeightContrain.constant = 21
    }
    @IBAction func clearPassword(_ sender: Any) {
        passwordText.isSecureTextEntry = !passwordText.isSecureTextEntry
        setupPasswordView()
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let email: String = emailText.text ?? ""
        let pass: String = passwordText.text ?? ""
        let name: String = nameText.text ?? ""
        
        if name.isEmpty{
            nameError(textError: "Name can't empty")
            //            return
        }else if name.count < 4 {
            nameError(textError: "Name phải từ 4 ký tự")
            clearNameView.isHidden = false
            //            return
        }else{
            setupNameView()
        }
        
        if email.isEmpty{
            emailError(textError: "Email can't empty")
            //            return
        }else if email.count >= 40 {
            emailError(textError: "Email phải ít hơn 40 ký tự")
            clearEmailView.isHidden = false
            //            return
        }else{
            setupEmailView()
        }
        
        if pass.isEmpty{
            passError(textError: "Password can't empty")
            //            return
        }else if pass.count < 6 || pass.count > 40 {
            passError(textError: "Password phải từ 6 - 40 ký tự")
            //            return
        }else{
            setupPasswordView()
        }
        
        callAPI()
    }
    
    func loginLabelSetup(){
        let customType = ActiveType.custom(pattern: "\\sLogin\\b")
        loginLabel.enabledTypes = [customType]
        loginLabel.text = "Already have an account ? Login"
        loginLabel.customColor[customType] = UIColor.blue
        
        loginLabel.handleCustomTap(for: customType) { element in
            print("Custom type tapped: \(element)")
        }
        
        loginLabel.configureLinkAttribute = { (type, attributes, isSelected) in
            var atts = attributes
            atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 15)
            return atts
        }
    }
    
//    func callAPI(){
//        self.showLoading(isShow: true)
//        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/register"
//        AF.request(
//            domain,
//            method: .post,
//            parameters: [
//                    "name": nameText.text ?? "",
//                    "email": emailText.text ?? "",
//                    "password": passwordText.text ?? ""],
//            encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseData { (afDataResponse: AFDataResponse<Data>) in
//            self.showLoading(isShow: false)
//            switch afDataResponse.result{
//            case.success(let data):
//                print("Success")
//                print(data)
//                do {
//                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
//                        self.registerFailure(title: "Error", message: "Something went wrong")
//                        return
//                    }
//                    print("json")
//                    print(json)
//
//                    let accessToken = json["access_token"] as? String
//                    let refreshToken = json["refresh_token"] as? String
//                    let userId = json["user_id"] as? String
//
//                    if accessToken != nil {
//                        self.registerSuccess()
//                    }else{
//                        self.registerFailure(title: "Error", message: "Something went wrong")
//                    }
//
//                } catch {
//                    print("errorMsg")
//                    self.registerFailure(title: "Error", message: "Something went wrong")
//                }
//                break
//            case.failure(let err):
//                print("failure")
//                print(err.errorDescription ?? "")
//
//                do {
//                    guard let data = afDataResponse.data else {
//                        self.registerFailure(title: "Error", message: "Something went wrong")
//                        return
//                    }
//                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
//                        self.registerFailure(title: "Error", message: "Something went wrong")
//                        return
//                    }
//
//                    if let type = json["type"] as? String,
//                       let message = json["message"] as? String{
//                        self.registerFailure(title: type, message: message)
//                        print(json)
//                    } else {
//                        self.registerFailure(title: "Error", message: "Something went wrong")
//                    }
//
//                } catch {
//                    print("errorMsg")
//                    self.registerFailure(title: "Error", message: "Something went wrong")
//                }
//                break
//            }
//        }
//    }
    
    
    func callAPI(){
        self.showLoading(isShow: true)
        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/register"
        let parameter:[String: String] = [
            "name": nameText.text ?? "",
            "email": emailText.text ?? "",
            "password": passwordText.text ?? ""]
        AF.request(domain,
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default).validate(statusCode: 200..<299)
            .responseDecodable(of: LoginResponse.self, completionHandler: { afDataResponse in
                self.showLoading(isShow: false)
                switch afDataResponse.result{
                case .success(let loginResponse):

                    let isLoggedIn = loginResponse.accessToken != nil

                    if isLoggedIn{
                        self.registerSuccess()
                    } else {
                        self.registerFailure(title: "Error", message: "Something went wrong")
                    }
                case .failure(let err):
                    print(err.errorDescription ?? "")
                    do {
                        guard let data = afDataResponse.data else {
                            self.registerFailure(title: "Error", message: "Something went wrong")
                            return
                        }
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                            self.registerFailure(title: "Error", message: "Something went wrong")
                            return
                        }

                        if let type = json["type"] as? String,
                           let message = json["message"] as? String{
                            self.registerFailure(title: type, message: message)
                            print(json)
                        } else {
                            self.registerFailure(title: "Error", message: "Something went wrong")
                        }
                    } catch {
                        print("errorMsg")
                        self.registerFailure(title: "Error", message: "Something went wrong")
                    }
                    break
                }
            })
    }

//
//    func callAPI(){
//        self.showLoading(isShow: true)
//        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/register"
//        AF.request(domain,
//                   method: .post,
//                   parameters: [
//                    "name": nameText.text ?? "",
//                    "email": emailText.text ?? "",
//                    "password": passwordText.text ?? ""],
//                   encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseData { (afDataResponse: AFDataResponse<Data>) in
//            self.showLoading(isShow: false)
//            switch afDataResponse.result{
//            case.success(let data):
//                do {
//                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
//                        self.registerFailure(title: "Error", message: "Something went wrong")
//                        return
//                    }
//                    print("json")
//                    print(json)
//
//                    let loginResByObjectMapper = LoginResponseByObjectMapper(JSON: json)
//                    let isLoggedIn = loginResByObjectMapper?.accessToken != nil
//
//                    if isLoggedIn {
//                        self.registerSuccess()
//                    }else{
//                        self.registerFailure(title: "Error", message: "Something went wrong")
//                    }
//
//                } catch {
//                    print("errorMsg")
//                    self.registerFailure(title: "Error", message: "Something went wrong")
//                }
//                break
//            case.failure(let err):
//                print("failure")
//                print(err.errorDescription ?? "")
//
//                do {
//                    guard let data = afDataResponse.data else {
//                        self.registerFailure(title: "Error", message: "Something went wrong")
//                        return
//                    }
//                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
//                        self.registerFailure(title: "Error", message: "Something went wrong")
//                        return
//                    }
//
//                    if let type = json["type"] as? String,
//                       let message = json["message"] as? String{
//                        self.registerFailure(title: type, message: message)
//                        print(json)
//                    } else {
//                        self.registerFailure(title: "Error", message: "Something went wrong")
//                    }
//                } catch {
//                    print("errorMsg")
//                    self.registerFailure(title: "Error", message: "Something went wrong")
//                }
//                break
//            }
//        }
//    }

    
    func registerSuccess(){
        let alertVC = UIAlertController(title: "Thông báo", message: "Đăng ký thành công", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "OK", style: .destructive) { action in
//            //Chuyen man`
//        }
//        alertVC.addAction(ok)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(cancel)
       
        present(alertVC, animated: true)
    }
    
    func registerFailure(title: String, message: String){
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



