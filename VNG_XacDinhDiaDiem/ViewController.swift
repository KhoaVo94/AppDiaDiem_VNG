//
//  ViewController.swift
//  VNG_XacDinhDiaDiem
//
//  Created by TramTran on 12/1/15.
//  Copyright (c) 2015 TramTran. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController,UISearchBarDelegate, LocateOnTheMap {
    
    
    var placePicker: GMSPlacePicker?
    var resultsArray = [String]()
    var placesId = [String]()
    var searchResultController:SearchResultControllerTableViewController!
    var placeDetail:Place?
    var placesClient:GMSPlacesClient?
    
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var tableViewReviews: UITableView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       placeDetail = nil
        placesClient = GMSPlacesClient()
    }
    
    override func viewDidAppear(animated: Bool) {
        searchResultController = SearchResultControllerTableViewController()
        searchResultController.delegate = self
 
    }
    // action btn Search: khai bao searchResultController la phai quan tri cua no
    @IBAction func btnSearch(sender: AnyObject) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController,animated:true,completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Loacate on Map delegate
    func locateWithLongiute(placeDetail:Place) {
        self.placeDetail = placeDetail
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableViewReviews.reloadData()
            if let keyPhoto = placeDetail.getPhoto(){
                let url:NSURL = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(keyPhoto)&key=\(googleServerKey)")!
                var dt:NSData? = NSData(contentsOfURL: url)
                if let data = dt{
                    self.imgPlace.image = UIImage(data: data)
                }

            }
            else{
                self.imgPlace.image = UIImage(named: "photoplaceholder")
            }
            
            self.lblName.text = "Name:" + placeDetail.getName()!
            if let phone = placeDetail.getPhone(){
                self.lblPhone.text = "Phone:" + phone
            }
            else{
                self.lblPhone.text = ""
            }
            if let webSite = placeDetail.getWebsite(){
                self.lblWebsite.text = "Website:" + webSite
            }
            else{
                self.lblWebsite.text = ""
            }
            self.lblAddress.text = "Address:" + placeDetail.getAddress()!
            if self.placeDetail?.getComments()?.count > 0{
                self.lblReview.text = "Reviews"
            }
            else {
                self.lblReview.text = ""
                self.tableViewReviews.reloadData()
            }
            
        }
    }
    // search
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //let placesClient = GMSPlacesClient()
        placesClient!.autocompleteQuery(searchText, bounds: nil, filter: nil) {
            (results, error:NSError?)->Void in
            self.resultsArray.removeAll()
            self.placesId.removeAll()
            if results == nil {
                println(error)
                return
            }
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                    self.placesId.append(result.placeID as String)
                }
            }
            // goi phuong thuc reloadData de truyen du lieu results search qua searchResultcontroller
            self.searchResultController.reloadDataWithArray(self.resultsArray, ids: self.placesId)
            
        }

    }
}

extension ViewController:UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comments = placeDetail?.getComments() {
            return comments.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cellid", forIndexPath: indexPath) as! TableCell
        if let ct = placeDetail?.getComments(){
            cell.configureCell(ct[indexPath.row].name, content: ct[indexPath.row].text)
        }
        
        return cell
    }
}

class TableCell: UITableViewCell {
    
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var txtContent: UITextView!
    
    func configureCell(author:String, content:String) {
        self.lblAuthor.text = author
        self.txtContent.text = content
    }
}
