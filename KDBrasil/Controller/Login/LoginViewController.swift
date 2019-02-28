//
//  LoginViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-28.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        btnLogin.layer.borderColor = UIColor.black.cgColor
        btnLogin.layer.borderWidth = 0.5
        btnLogin.layer.cornerRadius = 20
        btnLogin.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnLogin(_ sender: Any) {
        
        guard let email = tfEmail.text else {return}
        guard let password = tfPassword.text else {return}
        
        //check if they have value
        guard email != "" else {
            self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.emailEmpty);
            return
        }
        guard password != ""  else {
            self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.passwordEmpty);
            return
        }
        
        self.activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(errorCode: errCode)
                }
            } else {
                FIRFirestoreService.shared.getDataFromCurrentUser(password:password,completionHandler: { (error) in
                    if error == nil {
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        
    }
    

    @IBAction func btnForgotPassword(_ sender: Any) {
        guard let email = tfEmail.text else {return}
        var accountFacebook:String?
        
        //check if they have value
        guard email != "" else {self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.emailResetPassword); return}
        
        //Show Activity Indicator
        self.activityIndicator.startAnimating()
        
        //check what the provider is
        Auth.auth().fetchProviders(forEmail: email) { (value, err) in
            
            if err == nil {
                accountFacebook = value?[0]
                if accountFacebook == "facebook.com" {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(title: "Conta Facebook", message: "O e-mail \(email) é de uma conta facebook. \n\nUse a opção facebook para se conectar.")
                } else {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(title: FirebaseAuthErrors.warning, message: FirebaseAuthErrors.userNotFound)
                }
            }
            
            if accountFacebook == "password" || accountFacebook == nil{
                Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                    if error == nil {
                        self.activityIndicator.stopAnimating()
                        self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.emailSentResetPassword)
                    } else {
                        if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                            self.activityIndicator.stopAnimating()
                            self.showAlert(errorCode: errCode)
                        }
                    }
                })
            }
        }
        
    }
    
}
