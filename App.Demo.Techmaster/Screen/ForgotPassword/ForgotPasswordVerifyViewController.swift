

import UIKit
import SwiftHEXColors
import ActiveLabel
import MBProgressHUD
import Alamofire

class ForgotPasswordVerifyViewController: UIViewController {
    
    var email_Mobile: String?
    
    var timer: Timer!
    var count: Int = 10
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var email_MobileLabel: UILabel!

    @IBOutlet weak var resendLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var otpErrorView: UIView!
    @IBOutlet weak var otp6: UITextField!
    @IBOutlet weak var otp5: UITextField!
    @IBOutlet weak var otp4: UITextField!
    @IBOutlet weak var otp3: UITextField!
    @IBOutlet weak var otp2: UITextField!
    @IBOutlet weak var otp1: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otp1.layer.cornerRadius = 10
        otp2.layer.cornerRadius = 10
        otp3.layer.cornerRadius = 10
        otp4.layer.cornerRadius = 10
        otp5.layer.cornerRadius = 10
        otp6.layer.cornerRadius = 10
        
        otp1.layer.borderWidth = 1
        otp2.layer.borderWidth = 1
        otp3.layer.borderWidth = 1
        otp4.layer.borderWidth = 1
        otp5.layer.borderWidth = 1
        otp6.layer.borderWidth = 1
        
        if let email = email_Mobile{
            email_MobileLabel.text = "Enter the OTP sent to \(email)"
        }
       
        setupOTPView()
        
        resendButton.isHidden = true
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        //sửa ảnh của nút back navigation
//       backButton()
        callAPI()
    }
    
//    func backButton(){
//        let image = UIImage(named: "Vector")
//        let backItem = UIBarButtonItem(
//            image: image,
//            style: .plain,
//            target: self,
//            action: #selector(didClickBack(_:))
//        )
//
//        backItem.tintColor = UIColor.lightGray
//        self.navigationItem.leftBarButtonItem = backItem
//    }
//
//    @objc func didClickBack(_ sender: UIBarButtonItem){
//        self.navigationController?.popViewController(animated: true)
//    }
    func setupOTPView(){
        otp1.backgroundColor = .white
        otp2.backgroundColor = .white
        otp3.backgroundColor = .white
        otp4.backgroundColor = .white
        otp5.backgroundColor = .white
        otp6.backgroundColor = .white
        
        otp1.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        otp2.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        otp3.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        otp4.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        otp5.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        otp6.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.40, alpha: 1.00).cgColor
        
        otpErrorView.isHidden = true
    }
    
    func otpError(){
        otpErrorView.isHidden = false
        
        otp1.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        otp1.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        otp2.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        otp2.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        otp3.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        otp3.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        otp4.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        otp4.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        otp5.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        otp5.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
        otp6.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00)
        otp6.layer.borderColor = UIColor(red: 0.76, green: 0.00, blue: 0.32, alpha: 1.00).cgColor
        
    }
    
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleNext(_ sender: Any) {
        let otp_1 = otp1.text ?? ""
        let otp_2 = otp2.text ?? ""
        let otp_3 = otp3.text ?? ""
        let otp_4 = otp4.text ?? ""
        let otp_5 = otp5.text ?? ""
        let otp_6 = otp6.text ?? ""
        let arrayOTP: [String] = [otp_1, otp_2, otp_3, otp_4, otp_5, otp_6]
        
        if otp_1.isEmpty || otp_2.isEmpty || otp_3.isEmpty || otp_4.isEmpty || otp_5.isEmpty || otp_6.isEmpty{
            checkOTP()
            otpError()
        }else{
            setupOTPView()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let forgotPasswordChangePasswordViewController: ForgotPasswordChangePasswordViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordChangePasswordViewController") as! ForgotPasswordChangePasswordViewController
            
            forgotPasswordChangePasswordViewController.email = email_Mobile
            forgotPasswordChangePasswordViewController.otp = arrayOTP.joined()
            
            self.navigationController?.pushViewController(forgotPasswordChangePasswordViewController, animated: true)
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runTimer(){
        
        count -= 1
        timerLabel.text = "\(count)s"
        if count < 0{
            timer.invalidate()
            resendButton.isHidden = false
            resendButton.setTitle("Resend OTP", for: .normal)
            timerLabel.isHidden = true
            resendLabel.isHidden = true
        }
    }
    
    @IBAction func resendOtpButton(_ sender: Any) {
        callAPI()
        startTimer()
    }
    
    func callAPI(){
        self.showLoading(isShow: true)
        let domain = "http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/forgot_password/reset"
        let parameter:[String: String] = ["email": email_Mobile ?? ""]
        AF.request(domain,
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default).validate(statusCode: 200..<299)
            .responseDecodable(of: ForgotPasswordResponse.self, completionHandler: { afDataResponse in
                self.showLoading(isShow: false)
                switch afDataResponse.result{
                case .success(let codeResponse):

                    let isresendCode = codeResponse.message != nil

                    if isresendCode{
                        self.resendCodeSuccess()
                        self.startTimer()
                    } else {
                        self.resendCodeFailure(title: "Error", message: "Something went wrong")
                    }
                case .failure(let err):
                    print(err.errorDescription ?? "")
                    do {
                        guard let data = afDataResponse.data else {
                            self.resendCodeFailure(title: "Error", message: "Something went wrong")
                            return
                        }
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                            self.resendCodeFailure(title: "Error", message: "Something went wrong")
                            return
                        }

                        if let type = json["type"] as? String,
                           let message = json["message"] as? String{
                            self.resendCodeFailure(title: type, message: message)
                            print(json)
                        } else {
                            self.resendCodeFailure(title: "Error", message: "Something went wrong")
                        }
                    } catch {
                        print("errorMsg")
                        self.resendCodeFailure(title: "Error", message: "Something went wrong")
                    }
                    break
                }
            })
    }
    
    func resendCodeSuccess(){
        let alertVC = UIAlertController(title: nil, message: "Kiểm tra email/mobile để lấy mã OTP", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(cancel)
        present(alertVC, animated: true)
    }
    
    func resendCodeFailure(title: String, message: String){
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
    
    func checkOTP(){
        let alertVC = UIAlertController(title: nil, message: "Hãy điền đủ OTP", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(cancel)
        present(alertVC, animated: true)
    }

}
