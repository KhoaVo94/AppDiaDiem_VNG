//
//  PlaceNear.swift
//  VNG_XacDinhDiaDiem
//
//  Created by TramTran on 12/2/15.
//  Copyright (c) 2015 TramTran. All rights reserved.
//

import Foundation
import UIKit

enum PhotoRecordState {
    case New, Downloaded, Filtered, Failed
}
class PlaceNear {
    var state = PhotoRecordState.New
    var image = UIImage(named: "photoplaceholder.png")
    //
    private var name:String?
    private var address:String?
    private var keyPhoto:String?
    private var distance:String?
    
    init(name:String?,address:String?,keyPhoto:String?,distance:String?){
        self.name = name
        self.address = address
        self.keyPhoto = keyPhoto
        self.distance = distance
    }
    
    func getName()->String?{
        return self.name
    }
    func getAddress()->String?{
        return self.address
    }
    func getKeyPhoto()->String?{
        return self.keyPhoto
    }
    func getDistance()->String?{
        return self.distance
    }
    func setDistance(dis:String?)->Void{
        self.distance = dis
    }
    
    
}

//loc hinh anh

class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
    
    lazy var filtrationsInProgress = [NSIndexPath:NSOperation]()
    lazy var filtrationQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
}
class ImageDownloader: NSOperation {
    //1.Them doi tuong placeNear
    let placeNear: PlaceNear
    
    //2. Gan gia tri
    init(placeNear: PlaceNear) {
        self.placeNear = placeNear
    }
    
    //3. thuc hien cong viec
    override func main() {
        //4. neu placeNear da cancelled thi return
        if self.cancelled {
            return
        }
        //5. Download Image data
        if let keyPhoto = placeNear.getKeyPhoto(){
            //println(keyPhoto)
            let url:NSURL = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(keyPhoto)&key=\(googleServerKey)")!
            //println(url)
            var dt:NSData! = NSData(contentsOfURL: url)
            
            //6. kiem tra lai place Detail da huy hay chua
            if self.cancelled {
                return
            }
            
            //7. neu data co thi load image
            if dt?.length > 0 {
                self.placeNear.image = UIImage(data:dt!)
                self.placeNear.state = .Downloaded
            }
            else// neu ko co thi load ko thanh cong
            {
                self.placeNear.state = .Failed
                self.placeNear.image = UIImage(named: "photoplaceholder")
            }

        }
        else{
            self.placeNear.state = .Failed
            self.placeNear.image = UIImage(named: "photoplaceholder")
        }
    }
}
class ImageFiltration: NSOperation {
    let placeNear:PlaceNear
    
    init(placeNear: PlaceNear) {
        self.placeNear = placeNear
    }
    
    override func main () {
        if self.cancelled {
            return
        }
        
        if self.placeNear.state != .Downloaded {
            return
        }
        
        if let filteredImage = self.placeNear.image {
            self.placeNear.image = filteredImage
            self.placeNear.state = .Filtered
        }
    }
}
