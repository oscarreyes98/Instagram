//
//  HomeViewController.swift
//  Instagram
//
//  Created by Oscar Reyes on 1/3/18.
//  Copyright © 2018 Oscar Reyes. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var postsTableView: UITableView!
    var posts: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        self.postsTableView.insertSubview(refreshControl, at: 0)

        self.postsTableView.dataSource = self
        self.postsTableView.delegate = self
        self.postsTableView.rowHeight = UITableViewAutomaticDimension
        self.postsTableView.estimatedRowHeight = 350
        
        let query = PFQuery(className: "Post")
        
        // Fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.postsTableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "Error getting images")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postsTableView.reloadData()
        
        if let index = self.postsTableView.indexPathForSelectedRow{
            self.postsTableView.deselectRow(at: index, animated: true)
        }
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (posts?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath) as! PictureCell
        let post = posts?[indexPath.row]
        
        let photo = post?["media"] as! PFFile
        photo.getDataInBackground {(data: Data?, error: Error?) in
            if error == nil {
                cell.picImageView.image = UIImage(data: data!)
            }
        }
        
        cell.captionLabel.text = post?["caption"] as? String
        
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            print("Logged out")
            self.performSegue(withIdentifier: "returnToLoginSegue", sender: nil)
        }
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        let query = PFQuery(className: "Post")
        
        // Fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.postsTableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "Error getting images")
            }
        }
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    var isMoreDataLoading = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(!isMoreDataLoading){
            
            let scrollViewContentHeight = postsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - postsTableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && postsTableView.isDragging){
                
                isMoreDataLoading = true
                
                loadMoreData()
                
            }
        }
    }
    
    func loadMoreData() {
        
        let query = PFQuery(className: "Post")
        
        self.isMoreDataLoading = false
        
        // Fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.postsTableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "Error getting images")
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
