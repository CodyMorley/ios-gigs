//
//  LogInViewController.swift
//  Gigs
//
//  Created by Cody Morley on 5/5/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    //MARK: - Enums & Type Aliases -
    enum LoginType {
        case signUp
        case logIn
    }
    
    //MARK: - Properties -
    @IBOutlet weak var logInSignUpSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInSignUpButton: UIButton!
    
    var gigController: GigController?
    
    var loginType: LoginType
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Actions -
    @IBAction func logInSignUpToggle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .logIn
            logInSignUpButton.setTitle("Log In", for: .normal)
        } else {
            loginType = .signUp
            logInSignUpButton.setTitle("Sign Up", for: .normal)
        }
    }
    
    @IBAction func sendLogInSignUp(_ sender: Any) {
        if let username = usernameField.text,
            !username.isEmpty,
            let password = passwordField.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController?.signUp(as: user, completion: { result in
                    do {
                        let successs = try result.get()
                        if successs {
                            DispatchQueue.main.async {
                                let signUpAlert = UIAlertController(title: "Sign Up Successful", message: "Please log in", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                signUpAlert.addAction(alertAction)
                                self.present(signUpAlert, animated: true) {
                                    self.loginType = .logIn
                                    self.logInSignUpSegmentedControl.selectedSegmentIndex = 0
                                    self.logInSignUpButton.setTitle("Sign In", for: .normal)
                                }
                            }
                        }
                    } catch {
                        NSLog("Error signing up: \(error)")
                    }
                })
            } //else //TODO FILL THIS WITH TOMORROW'S PROJECT.
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
