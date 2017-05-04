//
//  SignUpViewController.swift
//  MiFi
//
//  Created by Tristan Secord on 2016-11-14.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import JSSAlertView
import Apollo

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var name: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var verifyPassword: UITextField!
  @IBOutlet weak var backButtonView: UIView!
  @IBOutlet weak var actionView: UIView!
  @IBOutlet weak var signUpScrollView: UIScrollView!
  let defaults = UserDefaults.standard
  var kbHeight: CGFloat!
  var apollo: ApolloClient
  
  required init?(coder aDecoder: NSCoder) {
    let base_url = Bundle.main.infoDictionary!["API_BASE_URL"] as! String
    self.apollo = ApolloClient(url: URL(string: base_url)!)
    super.init(coder: aDecoder);
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Colors.colorWithHexString(Colors.darkBlue())
    self.backButtonView.backgroundColor = Colors.colorWithHexString(Colors.red())
    self.actionView.backgroundColor = Colors.colorWithHexString(Colors.darkBlue())
    
    //delegate Setup
    name.delegate = self
    email.delegate = self
    password.delegate = self
    verifyPassword.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  func keyboardWillShow(_ notification: NSNotification) {
    if let userInfo = notification.userInfo {
      if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        kbHeight = keyboardSize.height
        self.animateTextField(up: true)
      }
    }
  }
  
  func keyboardWillHide(_ notification: NSNotification) {
    self.animateTextField(up: false)
  }
  
  func animateTextField(up: Bool) {
    var contentInsets: UIEdgeInsets
    if up {
      contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbHeight, 0.0);
    } else {
      contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    }
    signUpScrollView.contentInset = contentInsets
    signUpScrollView.scrollIndicatorInsets = contentInsets
  }
  
  func checkData() -> Bool {
    if ((name.text == nil || name.text == "") ||
      (email.text == nil || email.text == "") ||
      (password.text == nil || password.text == "") ||
      (verifyPassword.text == nil || verifyPassword.text == "")) {
      showWarning(message: "Looks like your missing some vital information. \r\nPlease fill out all fields to sign up.")
      return false
    } else if (password.text != verifyPassword.text) {
      showWarning(message: "Your passwords must match to successfully sign up.\r\n")
      return false
    } else if (!self.isValidEmail(testStr: email.text!)) {
      showWarning(message: "Please enter a valid email address.\r\n")
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
  
  func signUp() {
    let encrypted_password = AESCrypt.encrypt(password.text, password: Bundle.main.infoDictionary!["API_CLIENT_KEY"] as! String)
    self.apollo.perform(mutation: SignUpUserMutation(name: name.text!, email: email.text!, password: encrypted_password!)) { (result, error) in
      if let error = error {
        self.showWarning(message: "Error while attempting to sign up: \(error.localizedDescription)")
      } else if let error = result?.errors?[0] {
        self.showWarning(message: error.message)
      } else if let token = result?.data?.signup?.token {
        let successAlertView = JSSAlertView().success(
          self,
          title: "Welcome to MiFi!",
          text: "Your account has been created. Start adding networks to your account!")
        successAlertView.addAction {
          self.saveAuthToken(token: token)
        }
      } else {
        self.showWarning(message: "Something went wrong. Please try again.")
      }
    }
  }
  
  func saveAuthToken(token: String) {
    self.saveToken(token: token)
    name.text = ""
    email.text = ""
    password.text = ""
    verifyPassword.text = ""
    let homePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
    self.present(homePageViewController, animated: true, completion: nil)
  }
  
  private func saveToken(token: String) {
    defaults.set("loggedIn", forKey: "userLoggedIn")
    defaults.synchronize()
    KeychainAccess.setPassword("Bearer \(token)", account: "Auth_Token", service: "KeyChainService")
  }
  
  @IBAction func backPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func signUpClicked(_ sender: CustomButton) {
    if (self.checkData()) {
      self.signUp()
    }
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
