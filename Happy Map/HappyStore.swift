//
//  HappyStore.swift
//  Happy Map
//
//  Created by Paul Baker on 4/30/19.
//  Copyright © 2019 Paul Baker. All rights reserved.
//

import Foundation
import UIKit

class HappyStore {
    
    var happyUpdates: [HappyUpdate] = []
    var imageStore: ImageStore
    
    init() {
        imageStore = ImageStore()
    }
    
    func addHappyUpdate(happy: HappyUpdate, image: UIImage) {
        happyUpdates.append(happy)
        imageStore.setImage(image, forKey: happy.imageKey)
    }
    
    func getImage(forKey: String) -> UIImage? {
        return imageStore.image(forKey: forKey)
    }
}
