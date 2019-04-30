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
    
    let happyArchiveURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectory.first!
        return documentDirectory.appendingPathComponent("happys.archive")
    }()
    
    init() {
        imageStore = ImageStore()
        
        do {
            let data = try Data(contentsOf: happyArchiveURL)
            let archivedItems = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [HappyUpdate]
            happyUpdates = archivedItems!
        } catch {
            print("Error unarchiving: \(error)") // Do not worry if it happens the first time the app runs
        }
        
    }
    
    func addHappyUpdate(happy: HappyUpdate, image: UIImage) {
        happyUpdates.append(happy)
        imageStore.setImage(image, forKey: happy.imageKey)
        archiveChanges()
    }
    
    func getImage(forKey: String) -> UIImage? {
        return imageStore.image(forKey: forKey)
    }
    
    func archiveChanges() {
        
        
        do {
            
            if #available(iOS 11.0, *) {
            let data = try NSKeyedArchiver.archivedData(withRootObject: happyUpdates, requiringSecureCoding: false)
            try data.write(to: happyArchiveURL)
            }
            else {
                let data = NSKeyedArchiver.archivedData(withRootObject: happyUpdates)
                try data.write(to: happyArchiveURL)
                
            }
            
            print("archived items to \(happyArchiveURL)")
        } catch {
            print("Error archiving items: \(error)")
        }
    }
    
}
