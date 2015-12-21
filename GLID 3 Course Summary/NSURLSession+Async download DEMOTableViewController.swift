//
//  NSURLSession+Async download DEMOTableViewController.swift
//  GLID 3 Course Summary
//
//  Created by Malek T. on 12/19/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit


class NSURLSession_Async_download_DEMOTableViewController: UITableViewController {

    var refreshCtrl: UIRefreshControl!
    var tableData:[AnyObject]!
    var task: NSURLSessionDownloadTask!
    var session: NSURLSession!
    var cache:NSCache!
    override func viewDidLoad() {
        super.viewDidLoad()

        let alert = UIAlertController(title: "GLID 3", message: "Pull to refresh content", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        session = NSURLSession.sharedSession()
        task = NSURLSessionDownloadTask()

        self.refreshCtrl = UIRefreshControl()
        self.refreshCtrl.addTarget(self, action: "refreshTableView", forControlEvents: .ValueChanged)
        self.refreshControl = self.refreshCtrl
        
        //
        self.tableData = []
        self.cache = NSCache()
    }
    
    func refreshTableView(){
        self.loadTableView()
    }

    func loadTableView(){
        
        
        let url:NSURL! = NSURL(string: "https://itunes.apple.com/search?term=flappy&entity=software")
        task = session.downloadTaskWithURL(url, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if location != nil{
                let data:NSData! = NSData(contentsOfURL:location!)
                do{
                    let dic = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves)
                    self.tableData = dic.valueForKey("results") as! [AnyObject]
                    // Reload the tableview
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    })
                }catch{
                    
                }
            }
        })
        
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tableData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath)
        cell.imageView?.image = nil
        // Configure the cell
        let dictionary = self.tableData[indexPath.row] as! [String:AnyObject]
        cell.textLabel!.text = dictionary["trackName"] as? String
        cell.imageView?.image = UIImage(named: "placeholder")
        if (self.cache.objectForKey(indexPath.row) != nil){
            print("Use cache")
            cell.imageView?.image = self.cache.objectForKey(indexPath.row) as? UIImage
        }else{
            let artworkUrl = dictionary["artworkUrl100"] as! String
            let url:NSURL! = NSURL(string: artworkUrl)
            task = session.downloadTaskWithURL(url, completionHandler: { (location, response, error) -> Void in
                let data:NSData! = NSData(contentsOfURL: url)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Before assign the image, check whether the current cell is visible
                        if let updateCell = tableView.cellForRowAtIndexPath(indexPath) {
                            let img:UIImage! = UIImage(data: data)
                            updateCell.imageView?.image = img
                            self.cache.setObject(img, forKey: indexPath.row)
                        }
                    })
            })
            task.resume()
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
