import UIKit

class ViewController: UIViewController ,MAMapViewDelegate, AMapSearchDelegate{
    
    var search:AMapSearchAPI?
    var currentLocation:CLLocation?

    @IBOutlet weak var mapView: MAMapView!
    
    var locations: NSMutableArray? = []
    let distanceFilter: CLLocationDistance = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        initMapView()
        initSearch()
        
    }
    
    func initMapView(){
        mapView.delegate = self
        // 启定位
        mapView!.showsUserLocation = true
        // 设置跟随定位模式，将定位点设置成地图中心点
        mapView!.userTrackingMode = MAUserTrackingModeFollow

    }
    
    // 初始化 AMapSearchAPI
    func initSearch(){
        search = AMapSearchAPI();
        search?.delegate = self
    }
    
    // 逆地理编码
    func reverseGeocoding(){
        let coordinate = currentLocation?.coordinate
        // 构造 AMapReGeocodeSearchRequest 对象，配置查询参数（中心点坐标）
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        regeo.location = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate!.latitude), longitude: CGFloat(coordinate!.longitude))
        self.search!.AMapReGoecodeSearch(regeo)
        
    }
    
    // 定位回调
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation {
            currentLocation = userLocation.location
            if (currentLocation?.horizontalAccuracy < kCLLocationAccuracyNearestTenMeters*3 && currentLocation?.horizontalAccuracy > 0)
            {
                addRoutePoint(mapView!.userLocation.location)
                showRoute()
            }
        }
    }
    
    // 点击Annoation回调
    func mapView(mapView: MAMapView!, didSelectAnnotationView view: MAAnnotationView!) {
        // 若点击的是定位标注，则执行逆地理编码
        if view.annotation.isKindOfClass(MAUserLocation){
            reverseGeocoding()
            
        }
    }
    
    // 逆地理编码回调
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if (response.regeocode != nil) {
            var title = response.regeocode.addressComponent.city
            if title == nil{return}
            let length: Int = title.characters.count

            
            if (length == 0){
                title = response.regeocode.addressComponent.province
            }
            //给定位标注的title和subtitle赋值，在气泡中显示定位点的地址信息
            mapView?.userLocation.title = title
            mapView?.userLocation.subtitle = response.regeocode.formattedAddress
        }
        
    }
    
    func addRoutePoint(location: CLLocation?)
    {

        let lastLocation: CLLocation? = locations!.lastObject as? CLLocation
        
        if lastLocation != nil {
            
            let distance: CLLocationDistance = lastLocation!.distanceFromLocation(location!)
            
            if distance > distanceFilter {
                locations!.addObject(location!)
            }
        }
        else
        {
            locations?.addObject(location!)
        }


    }
    func coordinates() -> [CLLocationCoordinate2D]! {
        var coordinates: [CLLocationCoordinate2D] = []
        if locations!.count > 1 {
            for location: AnyObject in locations! {
                let loc = location as! CLLocation
                coordinates.append(loc.coordinate)
            }
        }
        return coordinates
    }
    
    func showRoute()
    {
        var coordiantes: [CLLocationCoordinate2D] = coordinates()
        let polyline = MAPolyline(coordinates: &coordiantes, count: UInt(coordiantes.count))
        mapView!.addOverlay(polyline)
        mapView!.showAnnotations(mapView!.annotations, animated: true)
    }
    
    
    //MARK:- MAMapViewDelegate
    
    func mapView(mapView: MAMapView!, viewForOverlay overlay: MAOverlay!) -> MAOverlayView!
    {
        if overlay.isKindOfClass(MAPolyline){
            let polylineView:MAPolylineView = MAPolylineView(overlay: overlay)
            polylineView.strokeColor = UIColor.purpleColor()
            polylineView.lineWidth = 5.0
            polylineView.lineJoinType = kMALineJoinRound;//连接类型
            polylineView.lineCapType = kMALineCapRound;//端点类型
            return polylineView
        }
        return nil
    }
    
    
    
    


}