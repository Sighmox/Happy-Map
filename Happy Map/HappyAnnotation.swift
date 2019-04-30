//
//  HappyAnnotation.swift
//  Happy Map
//
//  Created by Paul Baker on 4/30/19.
//  Copyright © 2019 Paul Baker. All rights reserved.
//

import Foundation
import MapKit

class HappyAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    let happy: HappyUpdate
    
    // Computed property, created from other properties of this class
    var title: String? {
        return "\(dateFormatter.string(from: happy.date)). \(happy.comment ?? "")"
    }
    
    init(happy: HappyUpdate) {
        self.coordinate = happy.coordinate
        self.happy = happy
    }
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
}
