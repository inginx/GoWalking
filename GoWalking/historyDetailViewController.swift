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
    
    
    var data:RunningData!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()
        initLabel()
        showRoute()

    }

    func initMap(){
        mapview.delegate = self
        
    }
    
    func initLabel(){
        startTimelabel.text = nsdateToString(data.startTime)
        endTimeLabel.text = nsdateToString(data.endTime)
        distanceLabel.text = String(format: "%.2f m",data.distance)
    }
    

    func nsdateToString(date:NSDate)->String
    {
        let local = NSLocale.currentLocale()
        let dateFormatt =
        NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd-hh-mm", options: 0, locale: local)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormatt
        return dateFormatter.stringFromDate(date)
    }


    func showRoute()
    {
        var coordiantes: [CLLocationCoordinate2D] = []
        for location: AnyObject in data.locations {
            let loc = location as! CLLocation
            coordiantes.append(loc.coordinate)
        }
        let polyline = MAPolyline(coordinates: &coordiantes, count: UInt(data.locations.count))
        mapview.addOverlay(polyline)
        mapview.showAnnotations(mapview.annotations, animated: true)
        
//        for a in coordiantes{
//            let pointAnnotation = MAPointAnnotation()
//            pointAnnotation.coordinate = a;
//            mapview.addAnnotation(pointAnnotation)
//        }
        

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
