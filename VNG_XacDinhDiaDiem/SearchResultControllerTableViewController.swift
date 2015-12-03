//
//  SearchResultControllerTableViewController.swift
//  VNG_XacDinhDiaDiem
//
//  Created by TramTran on 12/1/15.
//  Copyright (c) 2015 TramTran. All rights reserved.
//

import UIKit

protocol LocateOnTheMap{
    func locateWithLongiute(placeDetail:Place)
}

class SearchResultControllerTableViewController: UITableViewController {
    var searchResults:[String]!// mang chua ket qua search
    var idResults:[String]!// mang chua ket qua place id search
    var delegate:LocateOnTheMap!
    var placeDetail:Place!// doi tuong placeDetail
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array()
        self.idResults = Array()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // cau hinh cell cho tableView Search
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
        cell.textLabel??.text = self.searchResults[indexPath.row]
        return cell as! UITableViewCell
    }
    
    // khi mot dong TableView Serch duoc chon
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //1.tableView bien mat
        self.dismissViewControllerAnimated(true, completion: nil)
                //2. Search place detail khi biet placeID
      
                let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(self.idResults[indexPath.row])&key=\(googleServerKey)")
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!){
                    (data,reponse,error)->Void in
                    if data != nil {
                        let dic =  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves, error: nil) as! NSDictionary
                        //println(dic)
                        let photo = dic["result"]?["photos"] as? NSArray
                        var photo2:String? = nil
                        if let array = photo {
                            photo2 = array[0]["photo_reference"] as? String
                        }
                        
                        var geometry = dic["result"]?["geometry"] as? NSDictionary
                        let location = geometry!["location"] as? NSDictionary
                        let lat = location!["lat"] as! Double
                        let lon = location!["lng"] as! Double
                        var name:String? = dic["result"]?["name"] as? String
                        var address:String? = dic["result"]?["formatted_address"] as? String
                        var phone:String? = dic["result"]?["international_phone_number"] as? String
                        var website:String? = dic["result"]?["website"] as? String
                        var reviews = dic["result"]?["reviews"] as? NSArray
                        var comments:[Place.review] = []
                        if let rev = reviews {
                            for i in 0...reviews!.count-1{
                                let name:String? = rev[i]["author_name"] as? String
                                let text:String? = rev[i]["text"] as? String
                                let review:Place.review = Place.review(name: name!, text: text!)
                                comments.append(review)
                                
                            }
                            
                        }
                     
                        self.placeDetail = Place(photo: photo2, name: name, address: address, website: website, phone: phone, comments: comments)
                        
                        //3.Search palce nearby dua vao lat,lon cua placeDetail
                        let url2 = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&rankby=distance&types=food&key=\(googleServerKey)")
                       // println(url2)
                        let task2 =  NSURLSession.sharedSession().dataTaskWithURL(url2!){
                            (data2,reponse2,error2)->Void in
                            if data2 != nil {
                                let dic2 =  NSJSONSerialization.JSONObjectWithData(data2!, options: NSJSONReadingOptions.MutableLeaves, error: nil) as! NSDictionary
                                //println(dic2)
                                
                                Data.placeNears.removeAll()
                                
                                let res = dic2["results"] as? NSArray
                                if let results = res{
                                    var c = 0
                                    for i in 0...results.count-1{
                                        if c < 16 {
                                            let photo = results[i]["photos"] as? NSArray
                                            var keyphoto2:String? = nil
                                            if let pt = photo {
                                                keyphoto2 = pt[0]["photo_reference"] as? String
                                            }
                                            let name = results[i]["name"] as? String
                                            let address = results[i]["vicinity"] as? String
                                       
                                        
                                            var placeNear = PlaceNear(name: name, address: address, keyPhoto: keyphoto2, distance: nil)
                                            placeNear.state = PhotoRecordState.New
                                            Data.placeNears.append(placeNear)
                                            c = c+1
                                        }
                                        else {
                                            break
                                        }
                                    }
                                    //4.Search distance
                                    //4.1. khai bao dia diem dich can search
                                    var destinations:String = ""
                                    for j in 0...Data.placeNears.count-1 {
                                        if destinations.isEmpty {
                                            destinations = destinations + Data.placeNears[j].getAddress()!.stringByReplacingOccurrencesOfString(" ", withString: "+")
                                        }
                                        else {
                                            destinations = destinations + "|" + Data.placeNears[j].getAddress()!.stringByReplacingOccurrencesOfString(" ", withString: "+").stringByReplacingOccurrencesOfString(",", withString: "")
                                        }
                                    }
                                    //4.2. Khai bao dia diem khoi tao can search
                                    let origins = self.placeDetail.getAddress()!.stringByReplacingOccurrencesOfString(" ", withString: "+")
                                    //4.3. Khai bao url va tien hanh thuc hien task search
                                    var urlString : NSString = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origins)&destinations=\(destinations)&language=vi-VI&key=\(googleServerKey)"
                                    var urlStr : NSString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                                    let url3 : NSURL = NSURL(string: urlStr as String)!
                                   // println(url3)
                                    let task3 = NSURLSession.sharedSession().dataTaskWithURL(url3){
                                        (data3,reponse3,error3)->Void in
                                        if(data3 != nil){
                                            let dic3 =  NSJSONSerialization.JSONObjectWithData(data3!, options: NSJSONReadingOptions.MutableLeaves, error: nil) as! NSDictionary
                                            let ro = dic3["rows"] as? NSArray
                                            //println(ro)
                                            if let rows = ro{
                                                for i in 0...rows.count-1{
                                                    let e = rows[i]["elements"] as? NSArray
                                                    if let elements = e{
                                                        //println(elements)
                                                        for j in 0...elements.count-1{
                                                            let distance = elements[j]["distance"] as? NSDictionary
                                                            if let dis = distance{
                                                                let value = distance!["text"] as? String
                                                                //println(value)
                                                                Data.placeNears[j].setDistance(value)
                                                            }
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    task3.resume()
                                    //end task 3
                                   
                                }
                                
                            }
                        }
                        task2.resume()
                        // end task2
                        
                        //. truyen du lieu qua View controller
                        
                        Data.placeDetail = self.placeDetail
                        self.delegate.locateWithLongiute(self.placeDetail)
                    }
                    
                }
                task.resume()
        //end task
    }
    
    func reloadDataWithArray(array:[String], ids:[String]){
        self.searchResults = array
        self.idResults = ids
        self.tableView.reloadData()
    }
    
    
}
