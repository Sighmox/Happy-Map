//
//  ViewController.swift
//  Happy Map
//
//  Created by Paul Baker on 4/30/19.
//  Copyright © 2019 Paul Baker. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet var happyMap: MKMapView!
    
    var happyStore: HappyStore?
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        happyMap!.delegate = self
        
        for happy in happyStore!.happyUpdates {
            let annotation = HappyAnnotation(happy: happy)
            happyMap.addAnnotation(annotation)
        }
        
    }
    
// This button add a happy place
    @IBAction func addHappyUpdate(_ sender: Any) {
        
        centerMapOnUserLocation()
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .savedPhotosAlbum
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // This determines which picture is used when a happy update is made
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        let alertController = UIAlertController(title: "Mood Imapactor", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "What is affecting your mood?"
        }
        
        // Saves the changes when happy spots are added
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let comment = alertController.textFields!.first!.text
            let happyUpdate = HappyUpdate(coordinate: (self.locationManager?.location?.coordinate)!, comment: comment)
            self.happyStore!.addHappyUpdate(happy: happyUpdate, image: image)
            let annotation = HappyAnnotation(happy: happyUpdate)
            annotation.coordinate = happyUpdate.coordinate
            self.happyMap.addAnnotation(annotation)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    // Gets permission to use location services for user locations
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            happyMap.showsUserLocation = true
            locationManager!.startUpdatingLocation() // update as app runs
        } else {
            print("Location not permitted for app")
        }
    
}
    // If location can't be diplayed this error is diplayed
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error)") // Example: location disabled for device
}
    
    // When app opens map center function is called
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapOnUserLocation()
    }
    
    // Centers the map on user
    func centerMapOnUserLocation() {
        if let location = locationManager!.location {
            happyMap.setCenter(location.coordinate, animated: true)
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
            happyMap.setRegion(region, animated: true)
        } else {
            print("No location available")
        }
    }
    
    // Allows for photos associated with happy updates to be viewed in the map view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is HappyAnnotation {
            
            let happyannotation = annotation as! HappyAnnotation
            let pinAnnotationView = MKPinAnnotationView()
            pinAnnotationView.annotation = happyannotation
            pinAnnotationView.canShowCallout = true
            
            let image = happyStore!.getImage(forKey: happyannotation.happy.imageKey)
            
            let photoView = UIImageView()
            photoView.contentMode = .scaleAspectFit
            photoView.image = image
            let heightConstraint = NSLayoutConstraint(item: photoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
            photoView.addConstraint(heightConstraint)
            
            pinAnnotationView.detailCalloutAccessoryView = photoView
            
            return pinAnnotationView
        }
        
        return nil
    }
    
}
