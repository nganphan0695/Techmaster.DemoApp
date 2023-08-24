//Định dạng mobile
//callAPI k có code để check
//resendCode textField
//kiểu trả về changepass
import UIKit

class ForgotPasswordChooseMethotViewController: UIViewController {
    var mail: String?

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var radioImage: UIImageView!
    var isOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text = mail
        setImage()
    }
    

    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleNext(_ sender: Any) {
        
        if isOn{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let verifyViewController: ForgotPasswordVerifyViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVerifyViewController") as! ForgotPasswordVerifyViewController
            
            verifyViewController.email_Mobile = email.text
            self.navigationController?.pushViewController(verifyViewController, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let inputVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordInputEmailViewController") as! ForgotPasswordInputEmailViewController
            
            
            self.navigationController?.pushViewController(inputVC, animated: true)
        }
        
    }
    
    func setImage(){
        if isOn{
            radioImage.image = UIImage(named: "radio_on")
        }else{
            radioImage.image = UIImage(named: "radio_off")
        }
    }

    @IBAction func radioButton(_ sender: Any) {
        self.isOn = !self.isOn
        self.setImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
