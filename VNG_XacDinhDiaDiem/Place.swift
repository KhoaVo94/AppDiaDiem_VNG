//
//  File.swift
//  VNG_XacDinhDiaDiem
//
//  Created by TramTran on 12/1/15.
//  Copyright (c) 2015 TramTran. All rights reserved.
//

import Foundation
class Place {
    private let photo:String?
    private let name:String?
    private let address:String?
    private let website:String?
    private let phone:String?
    private var comments:[review]?
    
    class review {
        var name:String
        var text:String
        
       
        init(name:String, text:String) {
            self.name = name
            self.text = text
        }
    }
    
    init(photo:String?, name:String?, address:String?, website:String?, phone:String?, comments:[review]?) {
        self.photo = photo
        self.name = name
        self.address = address
        self.website = website
        self.phone = phone
        self.comments = comments
    }
     func getPhoto()->String?{
        return self.photo
    }
    func getName()->String?{
        return self.name
    }
    func getAddress()->String?{
        return self.address
    }
    func getWebsite()->String?{
        return self.website
    }
    func getPhone()->String?{
        return self.phone
    }
    func getComments()->[review]?{
        return self.comments
    }
    
}