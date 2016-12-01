//
//  SignInViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-12.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import KCFloatingActionButton
import SCLAlertView

class SignInViewController: UIViewController {
    
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var signIn: CustomButton!
    @IBOutlet weak var optionsWheel: CustomOptionWheel!
    let httpHelper = HTTPHelper()
    @IBOutlet weak var signInView: UIView!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view Setup
        optionsWheel.addItem("Forgot Password?", icon: #imageLiteral(resourceName: "QUESTION_MARK"))
        optionsWheel.addItem("Sign Up", icon: #imageLiteral(resourceName: "SIGN_UP"), handler: { item in
            self.optionsWheel.close()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
            self.present(controller, animated: true, completion: nil)
        })
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "footer_lodyas"))
        
        //delegate Setup
        email.delegate = self
        password.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInPressed(_ sender: CustomButton) {
        let dataCheck = self.checkData()
        if (dataCheck == true) {
            self.sendSignInRequest()
        }
    }
    
    func checkData() -> Bool {
        if (email.text == nil || email.text == "") {
            SCLAlertView().showNotice("Notice!", subTitle: "Please enter your email.")
            return false
        } else if (!self.isValidEmail(testStr: email.text!)) {
            SCLAlertView().showNotice("Notice!", subTitle: "Please enter a valid email address")
        } else if (password.text == nil || password.text == "") {
            SCLAlertView().showNotice("Notice!", subTitle: "Please enter your password.")
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
    
    func sendSignInRequest() {
        let httpRequest = httpHelper.buildRequest("signin", method: "POST",
                                                  authType: HTTPRequestAuthType.httpBasicAuth)
        
        let encrypted_password = AESCrypt.encrypt(password.text, password: HTTPHelper.API_AUTH_PASSWORD)
        
        let deviceToken = defaults.object(forKey: "deviceToken") as! String
        
        httpRequest.httpBody = "{\"email\":\"\(email.text!)\",\"password\":\"\(encrypted_password!)\", \"device_id\":\"\(deviceToken)\"}".data(using: String.Encoding.utf8);
        
        httpHelper.sendRequest(httpRequest as URLRequest, completion: {(data:Data?, error:Error?) in
            // Display error
            if error != nil {
                //let errorMessage = self.httpHelper.getErrorMessage(error!)
                SCLAlertView().showNotice("Notice!", subTitle: (error?.localizedDescription)! as String)
                return
            }
            
            self.updateUserLoggedInFlag()
            
            do {
                if let responseDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                    
                    // save API AuthToken and ExpiryDate in Keychain
                    if let user = responseDict["user"] as? NSDictionary {
                        self.saveApiTokenInKeychain(user)
                    }
                } else {
                    print("Could not parse response dictionary!")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }
    
    func updateUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        defaults.set("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
        //clear text fields
        email.text = ""
        password.text = ""
    }
    
    func saveApiTokenInKeychain(_ tokenDict:NSDictionary) {
        // Store API AuthToken and AuthToken expiry date in KeyChain
        tokenDict.enumerateKeysAndObjects({ (dictKey, dictObj, stopBool) -> Void in
            let myKey = dictKey as! String
            let myObj = dictObj as! String
            
            switch (myKey) {
            case "api_authtoken" :
                KeychainAccess.setPassword(myObj, account: "Auth_Token", service: "KeyChainService")
                break
            case "authtoken_expiry":
                KeychainAccess.setPassword(myObj, account: "Auth_Token_Expiry", service: "KeyChainService")
                break
            default:
                break
            }
        })
        //self.delegate?.SignedIn()
    }
}

//Text Field Delegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
