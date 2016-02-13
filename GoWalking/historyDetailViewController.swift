//
//  historyDetailViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/28.
//  Copyright © 2015年 称一称. All rights reserved.
//

import UIKit

class historyDetailViewController: UIViewController ,MAMapViewDelegate{

    @IBOutlet weak var mapview: MAMapView!
    @IBOutlet weak var startTimelabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var spendTimeLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    
    var data:RunningData!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()
        initLabel()
        showRoute()

    }

    func initMap(){
        mapview.delegate = self
        mapview.rotateCameraEnabled = false
//        if data.locations.count > 1{
//            let x = data.locations.lastObject as! CLLocation
//            mapview.centerCoordinate = x.coordinate
//        }
//        mapview.setZoomLevel(17, animated: false)
    }
    
    func initLabel(){
        let min=data.seconds/60;
        let hour=min/60;
        startTimelabel.text = data.startTime.toString()
        endTimeLabel.text = data.endTime.toString()
        distanceLabel.text = String(format: "%.2f m",data.distance)
        spendTimeLabel.text = String(format: "%dh:%dm:%ds",hour%24,min%60,data.seconds%60)
        averageSpeedLabel.text = String(format: "%.2f m/s",data.distance/Double(data.seconds) )
        stepsLabel.text = "\(data.steps)步"
    }
    
    func showRoute()
    {
        if data.locations.count < 1{return}
        
        var maxlatitude :CLLocationDegrees = (data.locations[0]as! CLLocation).coordinate.latitude
        var minlatitude :CLLocationDegrees = (data.locations[0]as! CLLocation).coordinate.latitude
        var maxlongitude :CLLocationDegrees = (data.locations[0]as! CLLocation).coordinate.longitude
        var minlongitude :CLLocationDegrees = (data.locations[0]as! CLLocation).coordinate.longitude
        
        
        var coordiantes: [CLLocationCoordinate2D] = []
        for location: AnyObject in data.locations {
            let loc = location as! CLLocation
            
            if loc.coordinate.latitude > maxlatitude {maxlatitude = loc.coordinate.latitude}
            if loc.coordinate.latitude < minlatitude {minlatitude = loc.coordinate.latitude}
            if loc.coordinate.longitude > maxlongitude {maxlongitude = loc.coordinate.longitude}
            if loc.coordinate.longitude < minlongitude {minlongitude = loc.coordinate.longitude}
            
            loc.coordinate.longitude
            coordiantes.append(loc.coordinate)
        }
        
        let centerPoint:CLLocation = CLLocation(latitude: (maxlatitude + minlatitude)/2, longitude: (maxlongitude + minlongitude)/2 )
        mapview.centerCoordinate = centerPoint.coordinate
        
        let polyline = MAPolyline(coordinates: &coordiantes, count: UInt(data.locations.count))
        mapview.addOverlay(polyline)
        mapview.showAnnotations(mapview.annotations, animated: true)
        
        
        let span:MACoordinateSpan = MACoordinateSpanMake(maxlatitude - minlatitude + 0.01, maxlongitude - minlongitude + 0.01)
        let region:MACoordinateRegion = MACoordinateRegionMake(centerPoint.coordinate, span)
        mapview.setRegion(region, animated: true)

        
        var coordiantesToDraw: [CLLocationCoordinate2D] = []
        coordiantesToDraw.append((data.locations.firstObject as! CLLocation).coordinate)
        coordiantesToDraw.append((data.locations.lastObject as! CLLocation).coordinate)
        
        for a in coordiantesToDraw{
            let pointAnnotation = MAPointAnnotation()
            pointAnnotation.coordinate = a;
            mapview.addAnnotation(pointAnnotation)
        }
        

    }
    
    func mapView(mapView: MAMapView!, viewForOverlay overlay: MAOverlay!) -> MAOverlayView!
    {
        if overlay.isKindOfClass(MAPolyline){
            let polylineView:MAPolylineView = MAPolylineView(overlay: overlay)
            polylineView.strokeColor = UIColor.blueColor()
            polylineView.lineWidth = 5.0
            polylineView.lineJoinType = kMALineJoinRound;//连接类型
            polylineView.lineCapType = kMALineCapRound;//端点类型
            return polylineView
        }
        return nil
    }


}
