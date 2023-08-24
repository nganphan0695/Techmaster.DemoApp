

import UIKit
import SwiftHEXColors

class ForgotPasswordInputEmailViewController: UIViewController {
    
    @IBOutlet weak var textFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiled.layer.cornerRadius = 10
        textFiled.layer.borderWidth = 1
        textFiled.layer.borderColor = UIColor(hexString: "#4E4B66")?.cgColor
        textFiled.autocorrectionType = .no
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleNext(_ sender: Any) {
        if emailValid() == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let forgotPasswordVerifyViewController: ForgotPasswordVerifyViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVerifyViewController") as! ForgotPasswordVerifyViewController
            
            forgotPasswordVerifyViewController.email_Mobile = textFiled.text
            

            self.navigationController?.pushViewController(forgotPasswordVerifyViewController, animated: true)
        }
        
    }
    
    func emailValid() -> Bool{
        let email: String = textFiled.text ?? ""
        
        var emailValid = false
        
        if email.isEmpty{
            showAlert(message: "Email can't empty")
        }else if email.count >= 40 {
         showAlert(message: "Email phải ít hơn 40 ký tự")
        }else if isValidEmail(email) == false{
            showAlert(message: "Email/mobile không đúng định dạng")
        }else{
            emailValid = true
        }
        return emailValid

    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func showAlert(message: String){
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(cancel)
        present(alertVC, animated: true)
    }

}
