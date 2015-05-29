//
//  ViewController.swift
//  GoSomewhere
//
//  Created by Jae Hoon Lee on 5/29/15.
//  Copyright (c) 2015 Jae Hoon Lee. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let uberServerToken = "put your server token here"
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!

    @IBAction func getProductsButtonPressed(sender: UIButton) {
        locationManager.stopUpdatingLocation()
        if let urlToReq = NSURL(string: "https://api.uber.com/v1/products?latitude=\(latitudeLabel.text!)&longitude=\(longitudeLabel.text!)") {
            var request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "GET"
            request.setValue("Token \(uberServerToken)", forHTTPHeaderField: "Authorization")
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response, data, error) in
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
        }
    }
    
    @IBAction func getEstimatesButtonPressed(sender: UIButton) {
        locationManager.stopUpdatingLocation()
        if let urlToReq = NSURL(string: "https://api.uber.com/v1/estimates/price?start_latitude=\(latitudeLabel.text!)&start_longitude=\(longitudeLabel.text!)&end_latitude=37.3175&end_longitude=-122.0419") {
            var request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "GET"
            request.setValue("Token \(uberServerToken)", forHTTPHeaderField: "Authorization")
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response, data, error) in
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
        }
    }

    override func viewDidLoad() {
         super.viewDidLoad()
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    override func viewWillAppear(animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let newLocation = locations.last as! CLLocation
        latitudeLabel.text = String(format: "%.8f", newLocation.coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", newLocation.coordinate.longitude)
    }
}

