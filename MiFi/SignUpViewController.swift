//
//  SignUpViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-14.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import KCFloatingActionButton
import SCLAlertView

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstName: CustomTextField!
    @IBOutlet weak var lastName: CustomTextField!
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var verifyPassword: CustomTextField!
    @IBOutlet weak var signUp: CustomButton!
    @IBOutlet weak var optionsWheel: CustomOptionWheel!
    let httpHelper = HTTPHelper()

    override func viewDidLoad() {
        super.viewDidLoad()

        //View setup
        optionsWheel.addItem("Sign In", icon: #imageLiteral(resourceName: "SIGN_IN"), handler: { item in
            self.optionsWheel.close()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(controller, animated: true, completion: nil)
        })
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "footer_lodyas"))
        
        //delegate Setup
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        verifyPassword.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //SignUp Clicked
    @IBAction func signUp(_ sender: CustomButton) {
        let dataCheck = self.checkData()
        if (dataCheck == true) {
            self.sendSignUpRequest()
        }
    }
    
    func checkData() -> Bool {
        if ((firstName.text == nil || firstName.text == "") ||
            (lastName.text == nil || lastName.text == "") ||
            (email.text == nil || email.text == "") ||
            (password.text == nil || password.text == "") ||
            (verifyPassword.text == nil || verifyPassword.text == "")) {
            SCLAlertView().showNotice("Notice!", subTitle: "Please fill out all fields to sign up. Thank You.")
            return false
        } else if (password.text != verifyPassword.text) {
            SCLAlertView().showNotice("Notice!", subTitle: "Your passwords must match to sign up.")
            return false
        } else if (!self.isValidEmail(testStr: email.text!)) {
            SCLAlertView().showNotice("Notice!", subTitle: "Please enter a valid email address")
            return false
        }
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func sendSignUpRequest() {
        // 1. Create HTTP request and set request header
        let httpRequest = httpHelper.buildRequest("signup", method: "POST",
                                                  authType: HTTPRequestAuthType.httpBasicAuth)
        
        // 2. Password is encrypted with the API key
        let encrypted_password = AESCrypt.encrypt(password.text!, password: HTTPHelper.API_AUTH_PASSWORD)
        
        // 3. Send the request Body
        httpRequest.httpBody = "{\"first_name\":\"\(firstName.text!)\",\"last_name\":\"\(lastName.text!)\",\"email\":\"\(email.text!)\",\"password\":\"\(encrypted_password!)\"}".data(using: String.Encoding.utf8)

        // 4. Send the request
        httpHelper.sendRequest(httpRequest as URLRequest, completion: {(data:Data?, error:Error?) in
            if error != nil {
                SCLAlertView().showNotice("Notice!", subTitle: (error?.localizedDescription)! as String)
                return
            }
            SCLAlertView().showSuccess("Welcome to MiFi!", subTitle: "Your account has been created. Sign in and set up your account!")
        })
    }
}

//Text Field Delegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
