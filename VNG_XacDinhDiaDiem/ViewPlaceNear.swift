//
//  ViewPlaceNear.swift
//  VNG_XacDinhDiaDiem
//
//  Created by TramTran on 12/2/15.
//  Copyright (c) 2015 TramTran. All rights reserved.
//

import UIKit

class ViewPlaceNear: UIViewController {
    
    var searchController:SearchResultControllerTableViewController!
    @IBOutlet weak var tableViewNear: UITableView!
    let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableViewNear.reloadData()
        // Do any additional setup after loading the view.
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ViewPlaceNear:UITableViewDataSource{
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let placeN = Data.placeNears{
            return placeN.count
        }
        else{
            return 0
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //println(indexPath.row)
        let cell = tableView.dequeueReusableCellWithIdentifier("cellNearBy", forIndexPath: indexPath) as! CellNearBy
        
        if Data.placeNears.count>0{
            //placeNear Detail:
            let placeNear = Data.placeNears[indexPath.row]
            cell.configueCell(placeNear)
            //1. khai bao accessory View
            if cell.accessoryView == nil {
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                cell.accessoryView = indicator
            }
            let indicator = cell.accessoryView as! UIActivityIndicatorView
            //2. neu doi tuong Place near co trang thai New,Downloaded thi tien hanh download hoac loc hinh anh
            if placeNear.state == PhotoRecordState.New || placeNear.state == PhotoRecordState.Downloaded {
                indicator.startAnimating()
                self.startOperationsForPhotoRecord(placeNear,indexPath:indexPath)
                
            }
            //2.1. neu nguoi dung dang keo table View thi download hinh anh
            if (!tableView.dragging && !tableView.decelerating) {
                self.startOperationsForPhotoRecord(placeNear,indexPath:indexPath)
            }

        }
        
        return cell
    }
    
    //bat dau Operation
    func startOperationsForPhotoRecord(placeNear: PlaceNear, indexPath: NSIndexPath){
        switch (placeNear.state) {
        case .New:
            startDownloadForRecord(placeNear, indexPath: indexPath)
        case .Downloaded:
            startFiltrationForRecord(placeNear, indexPath: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    //
    func startDownloadForRecord(placeNear: PlaceNear, indexPath: NSIndexPath){
        //1. kiem tra indexPath da co, neu khong bo qua
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        //2. Tao mot intance cua ImageDownloader
        let downloader = ImageDownloader(placeNear: placeNear)
        //3.bat dau download image, nhung phai kiem tra truoc downloader da bi canelled hay chua
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.tableViewNear.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            })
        }
        //4. them downloader
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //5 them downloader vao hang doi
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func startFiltrationForRecord(placeNear: PlaceNear, indexPath: NSIndexPath){
        if let filterOperation = pendingOperations.filtrationsInProgress[indexPath]{
            return
        }
        
        let filterer = ImageFiltration(placeNear:placeNear)
        filterer.completionBlock = {
            if filterer.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.filtrationsInProgress.removeValueForKey(indexPath)
                self.tableViewNear.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            })
        }
        pendingOperations.filtrationsInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }
    //
    

}
class CellNearBy:UITableViewCell{
    
    @IBOutlet weak var imgPlaceNear: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    
    func configueCell(placenear:PlaceNear)
    {
        if let img = placenear.image{
            imgPlaceNear.image = img
        }
        
        lblName.text =  placenear.getName()
        lblAddress.text = placenear.getAddress()
        if let distance = placenear.getDistance() {
            lblDistance.text = distance
        }
        
    }
}

