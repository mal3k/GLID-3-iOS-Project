//
//  ViewController.swift
//  GLID 3 Course Summary
//
//  Created by Malek T. on 12/15/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var tasks:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tasks = ["NSURLSession (Download content on pull-to-refresh + Asynchronous images loading)","CoreData","UITabBarController","MapKit","Table View manager (Add, remove, rearrange cells)"]
        //
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("CellIdentifier")
        cell?.textLabel?.text = tasks[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.row{
        case 0:
            let nsurlsessionDemoVC = storyboard.instantiateViewControllerWithIdentifier("nsurlSessionVCID")
            self.navigationController?.pushViewController(nsurlsessionDemoVC, animated: true)
        default:
            break
        }
    }
}

