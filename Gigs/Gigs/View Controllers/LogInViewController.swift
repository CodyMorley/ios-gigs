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
    @IBOutlet weak var LogInSignUpSegmentedControl: UISegmentedControl!
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
    @IBAction func logInSignUpToggle(_ sender: Any) {
    }
    
    @IBAction func sendLogInSignUp(_ sender: Any) {
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
