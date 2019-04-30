//
//  HappyUpdate.swift
//  Happy Map
//
//  Created by Paul Baker on 4/30/19.
//  Copyright © 2019 Paul Baker. All rights reserved.
//

import Foundation
import MapKit

class HappyUpdate {
    
    let coordinate: CLLocationCoordinate2D
    let imageKey: String
    let date: Date
    var comment: String?
    
    init(coordinate: CLLocationCoordinate2D, comment: String?) {
        self.coordinate = coordinate
        self.imageKey = UUID().uuidString
        self.date = Date()
        self.comment = comment
    }
    
    // Encoding the happy updates to be saved
    func encode(with aCoder: NSCoder) {
        // can't encode structs, so encode the latitude and longitude individually
        aCoder.encode(coordinate.latitude, forKey: "coordinate_latitude")
        aCoder.encode(coordinate.longitude, forKey: "coordinate_longitude")
        aCoder.encode(imageKey, forKey: "imageKey")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(comment, forKey: "comment")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let latitude = aDecoder.decodeDouble(forKey: "coordinate_latitude")
        let longitude = aDecoder.decodeDouble(forKey: "coordinate_longitude")
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        imageKey = aDecoder.decodeObject(forKey: "imageKey") as! String
        date = aDecoder.decodeObject(forKey: "date") as! Date
        comment = aDecoder.decodeObject(forKey: "comment") as? String
    }

}
