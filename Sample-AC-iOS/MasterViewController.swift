//
//  MasterViewController.swift
//  Sample-AC-iOS
//
//  Created by Raheel Sayeed on 4/26/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//

import UIKit
import AssessmentCenter

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil

    var client : ACClient?
    var forms  : [ACForm]?


    override func viewDidLoad() {
        super.viewDidLoad()
        // initialise Assessment Center Client
        let baseURLString = <# https://www.assessmentcenter.net/ac_api/.. #>
        let accessId = <# AccessIdentifier #>
        let accessToken = <# AccessToken #>
        
        client = ACClient(baseURL: URL(string: baseURLString)!, accessIdentifier: accessId, token: accessToken)
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList(_:)))
        navigationItem.rightBarButtonItem = refreshButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func refreshList(_ sender: Any) {
        client?.listForms(completion: { [weak self] (list) in
            if let list = list {
                self?.forms = list
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        })
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let instrument = forms![indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.instrumentForm = instrument
                controller.client = client
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forms?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let form = forms![indexPath.row]
        cell.textLabel?.text = form.title ?? "No Title"
        cell.detailTextLabel?.text = form.OID
        return cell
    }

    


}

