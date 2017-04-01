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
  @IBOutlet weak var signIn: CustomButton!
  let defaults = UserDefaults.standard
  var session: UserLoginMutation.Data.Login?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Colors.colorWithHexString(Colors.darkBlue())
    email.delegate = self
    password.delegate = self
  }
  
  func checkData() -> Bool {
    if (email.text == nil || email.text == "") {
      JSSAlertView().warning(
        self,
        title: "Notice!",
        text: "Looks like your missing some vital information. \r\nPlease enter your email."
      )
      return false
    } else if (!self.isValidEmail(testStr: email.text!)) {
      JSSAlertView().warning(
        self,
        title: "Notice!",
        text: "Please enter a valid email address.\r\n"
      )
    } else if (password.text == nil || password.text == "") {
      JSSAlertView().warning(
        self,
        title: "Notice!",
        text: "Looks like your missing some vital information. \r\nPlease enter your password."
      )
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
  
  func login() {
    let encrypted_password = AESCrypt.encrypt(password.text, password: HTTPHelper.API_AUTH_PASSWORD)
    
    apollo.perform(mutation: UserLoginMutation(email: email.text!, password: encrypted_password!)) { (result, error) in
      if let error = error {
        //Notify possible network problem.
        JSSAlertView().warning(
          self,
          title: "Notice!",
          text: "Error while attempting to login: \(error.localizedDescription)"
        )
      } else if let error = result?.errors?[0] {
        JSSAlertView().warning(
          self,
          title: "Notice!",
          text: error.message
        )
      } else if let token = result?.data?.login?.token {
        self.saveAuthToken(token: token)
      } else {
        JSSAlertView().warning(
          self,
          title: "Notice!",
          text: "Something went wrong. Please try again."
        )
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
    if (checkData()) {
      login()
    }
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
