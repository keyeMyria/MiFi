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
import Alamofire
import SwiftyJSON
import JSSAlertView
import Apollo

class SignInViewController: UIViewController {
  @IBOutlet weak var email: CustomTextField!
  @IBOutlet weak var password: CustomTextField!
  let defaults = UserDefaults.standard
  var apollo: ApolloClient
  
  required init?(coder aDecoder: NSCoder) {
    let base_url = Bundle.main.infoDictionary!["API_BASE_URL"] as! String
    self.apollo = ApolloClient(url: URL(string: base_url)!)
    super.init(coder: aDecoder);
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Colors.colorWithHexString(Colors.darkBlue())
    email.delegate = self
    password.delegate = self
  }
  
  func checkData() -> Bool {
    if (email.text == nil || email.text == "") {
      showWarning(message: "Looks like your missing some vital information. \r\nPlease enter your email.")
      return false
    } else if (!self.isValidEmail(testStr: email.text!)) {
      showWarning(message: "Please enter a valid email address.\r\n")
      return false
    } else if (password.text == nil || password.text == "") {
      showWarning(message: "Looks like your missing some vital information. \r\nPlease enter your password.")
      return false
    }
    return true
  }
  
  func showWarning(message: String!) {
    JSSAlertView().warning(self, title: "Notice!", text: message)
  }
  
  func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
  }
  
  func login() {
    let encrypted_password = AESCrypt.encrypt(password.text, password: Bundle.main.infoDictionary!["API_CLIENT_KEY"] as! String)
    
    self.apollo.perform(mutation: UserLoginMutation(email: email.text!, password: encrypted_password!)) { (result, error) in
      if let error = error {
        self.showWarning(message: "Error while attempting to login: \(error.localizedDescription)")
      } else if let error = result?.errors?[0] {
        self.showWarning(message: error.message)
      } else if let token = result?.data?.login?.token {
        self.saveAuthToken(token: token)
      } else {
        self.showWarning(message: "Something went wrong. Please try again.")
      }
    }
  }
  
  func saveAuthToken(token: String) {
    saveToken(token: token)
    email.text = ""
    password.text = ""
    let homePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
    self.present(homePageViewController, animated: true, completion: nil)
  }
  
  private func saveToken(token: String) {
    defaults.set("loggedIn", forKey: "userLoggedIn")
    defaults.synchronize()
    KeychainAccess.setPassword("Bearer \(token)", account: "Auth_Token", service: "KeyChainService")
  }
  
  @IBAction func createAccountPressed(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
    self.present(signUpViewController, animated: true, completion: nil)
  }
  
  @IBAction func forgotPasswordPressed(_ sender: Any) {
  }
  
  @IBAction func signInPressed(_ sender: CustomButton) {
    if (checkData()) { login() }
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
