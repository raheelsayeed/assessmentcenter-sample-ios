//
//  DetailViewController.swift
//  Sample-AC-iOS
//
//  Created by Raheel Sayeed on 4/26/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//

import UIKit
import AssessmentCenter

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    weak var client : ACClient?


    func configureView() {

        if let form = instrumentForm {
            if let label = detailDescriptionLabel {
                label.text = "\(form.title ?? form.OID)"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    var instrumentForm: ACForm? {
        didSet {
            configureView()
        }
    }
    
    @IBAction func startSession(_ sender: Any?) {
        
        guard let client = client, let instrumentForm = instrumentForm else {
            print("ACClient or ACForm missing")
            return
        }
        
        client.form(acform: instrumentForm) { [unowned self] (completeForm) in
            if let completeForm = completeForm {
                let taskViewController = ACTaskViewController(acform: completeForm, client: client, sessionIdentifier: "test-session")
                self.present(taskViewController, animated: true, completion: nil)
            }
        }
        
    }


}

