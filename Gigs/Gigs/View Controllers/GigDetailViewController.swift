//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Cody Morley on 5/6/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveGig(_ sender: Any) {
        guard let title = jobTitleTextField.text,
            !title.isEmpty,
            let dueDate: Date = dueDatePicker.date,
            let description = descriptionTextView.text,
            !description.isEmpty else {
                return
        }
        let newGig = Gig(title: title, dueDate: dueDate, description: description)
        
        gigController.createGig(posting: newGig)
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard let gig = self.gig else {
            return
        }
        
        self.jobTitleTextField.text = gig.title
        self.dueDatePicker.date = gig.dueDate
        self.descriptionTextView.text = gig.description
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
