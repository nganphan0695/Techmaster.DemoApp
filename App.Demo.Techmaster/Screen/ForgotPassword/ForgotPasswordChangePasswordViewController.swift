

import UIKit
import MBProgressHUD
import Alamofire

class ForgotPasswordChangePasswordViewController: UIViewController {
    
    var email: String?
    var otp: String?

    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var clearPassView: UIView!
    @IBOutlet weak var passwordErrorView: UIView!
    @IBOutlet weak var passwordText: UITextField!
    
    
    @IBOutlet weak var confirmErrorLabel: UILabel!
    @IBOutlet weak var clearConfirmView: UIView!
    @IBOutlet weak var confirmErrorView: UIView!
    @IBOutlet weak var confirmText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.autocorrectionType = .no
        confirmText.autocorrectionType = .no
        navigationController?.setNavigationBarHidden(true, animated: true)

        setupNewPasswordView()
        setupConfirmPasswordView()
    }
    

    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleNext(_ sender: Any) {
        let pass: String = passwordText.text ?? ""
        let confirm: String = confirmText.text ?? ""
       
        var passwordValid = false
        var confirmValid = false
     
        if pass.isEmpty{
            passError(textError: "New password can't empty")
        }else if pass.count < 6 || pass.count > 40 {
            passError(textError: "Password phải từ 6 - 40 ký tự")
        }else{
            passwordValid = true
            setupNewPasswordView()
        }
        
        if confirm.isEmpty{
            confirmPassError(textError: "Confirm new password can't empty")
        }else if confirm != pass {
            confirmPassError(textError: "Invalid Password")
        }else{
            confirmValid = true
            setupConfirmPasswordView()
        }
  
        if confirmValid == true && passwordValid == true {
            callAPIResetPassword()
        }
    }
    
    private func callAPIResetPassword(){
        self.showLoading(isShow: true)
        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/forgot_password/change_password"
        let parameter:[String: String] = [
            "email": email ?? "",
            "pin_code": otp ?? "",
            "new_password": passwordText.text ?? ""
        ]
        AF.request(domain,
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default).validate(statusCode: 200..<299)
            .responseDecodable(of: ForgotPasswordResponse.self, completionHandler: { afDataResponse in
                self.showLoading(isShow: false)
                switch afDataResponse.result{
                case .success(let changePasswordResponse):

                    let ischangePasswordResponse = changePasswordResponse.message != nil

                    if ischangePasswordResponse{
                        self.changePasswordSuccess()
                    } else {
                        self.changePasswordFailure(title: "Error", message: "Something went wrong")
                    }
                case .failure(let err):
                    print(err.errorDescription ?? "")
                    do {
                        guard let data = afDataResponse.data else {
                            self.changePasswordFailure(title: "Error", message: "Something went wrong")
                            return
                        }
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                            self.changePasswordFailure(title: "Error", message: "Something went wrong")
                            return
                        }

                        if let type = json["type"] as? String,
                           let message = json["message"] as? String{
                            self.changePasswordFailure(title: type, message: message)
                            print(json)
                        } else {
                            self.changePasswordFailure(title: "Error", message: "Something went wrong")
                        }
                    } catch {
                        print("errorMsg")
                        self.changePasswordFailure(title: "Error", message: "Something went wrong")
                    }
                    break
                }
            })
    }
    
    func setupNewPasswordView(){
        passwordText.backgroundColor = .white
        clearPassView.backgroundColor = .white
        passwordText.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        
        passwordErrorView.isHidden = true
    }
    
    func passError(textError: String){
        passwordErrorView.isHidden = false
        
        passwordText.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        passwordText.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        clearPassView.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)

        passwordErrorLabel.text = textError
    }
    @IBAction func newPass(_ sender: Any) {
        passwordText.isSecureTextEntry = !passwordText.isSecureTextEntry
    }
    
    func setupConfirmPasswordView(){
        confirmText.backgroundColor = .white
        clearConfirmView.backgroundColor = .white
        confirmText.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        
        confirmErrorView.isHidden = true
    }
    
    func confirmPassError(textError: String){
        confirmErrorView.isHidden = false
        
        confirmText.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        confirmText.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        clearConfirmView.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)

        confirmErrorLabel.text = textError
    }
    @IBAction func confirm(_ sender: Any) {
        confirmText.isSecureTextEntry = !confirmText.isSecureTextEntry
    }
    
    func changePasswordSuccess(){
        let alertVC = UIAlertController(title: nil, message: "Đổi mật khẩu thành công", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(cancel)
        present(alertVC, animated: true)
    }
    
    func changePasswordFailure(title: String, message: String){
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
