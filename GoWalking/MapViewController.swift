import UIKit

class MapViewController: UIViewController ,MAMapViewDelegate, AMapSearchDelegate{


    @IBOutlet weak var mapView: MAMapView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var averageLabel: UILabel!
    
    var search:AMapSearchAPI?
    var currentLocation:CLLocation?
    var locations: NSMutableArray? = []
    let distanceFilter: CLLocationDistance = 2
    var distance:Double = 0
    var seconds:Int = 0
    var AvaiblePoints:Int = 0
    var timer1:NSTimer?
    var startTime:NSDate!
    var endTime:NSDate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
        initSearch()
        计时Timer()
        startTime = NSDate()
        
    }
    
    func initMapView(){
        mapView.delegate = self
        // 启定位
        mapView!.showsUserLocation = true
        // 设置跟随定位模式，将定位点设置成地图中心点
        mapView!.userTrackingMode = MAUserTrackingModeFollow
        mapView.rotateCameraEnabled = false
        //开启后台定位
        mapView!.pausesLocationUpdatesAutomatically = true;
        mapView!.allowsBackgroundLocationUpdates = true;
        

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
            if (currentLocation?.horizontalAccuracy < kCLLocationAccuracyNearestTenMeters*3 && currentLocation?.horizontalAccuracy > 0 ){
                if(AvaiblePoints > 3){
                    addRoutePoint(mapView!.userLocation.location)
                    updateSpeed(userLocation)
                    showRoute()
                }
                else {AvaiblePoints++}
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
                updateDistance(distance)
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
        let pointcount = coordiantes.count
        if pointcount<2 {return}
        var newCoord:[CLLocationCoordinate2D] = [coordiantes[pointcount-2],coordiantes[pointcount-1]]
        let polyline = MAPolyline(coordinates: &newCoord, count: 2)
        mapView!.addOverlay(polyline)
        mapView!.showAnnotations(mapView!.annotations, animated: true)
    }
    
    
    func 添加标记点(){
        
    }
    
    //MARK:- MAMapViewDelegate
    
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
    
    //MARK:- Label Updaters
    func updateDistance(dis:Double){
        self.distance += dis
        distanceLabel.text = String(format: "%.2f m", distance)
    }
    func updateSpeed(loc:MAUserLocation){
        var speed = Double(loc.location.speed)
        if speed < 0 {speed = 0}
        speedLabel.text = String(format: "%.2f m/s", speed)
    }
    func updateTime(){
        let min=seconds/60;
        let hour=min/60;
        timeLabel.text = String(format: "%dh:%dm:%ds",hour%24,min%60,seconds%60)
    }
    func uodateAverage(){
        let avg = distance / Double(seconds)
        averageLabel.text = String(format: "%.2f m/s", avg)
    }
    //MARK:- timers
    func secondsAdder(){
        self.seconds += 1
        updateTime()
        uodateAverage()
    }
    func 计时Timer(enable:Bool = true){
        if enable{
        self.timer1 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "secondsAdder", userInfo: nil, repeats: true)
        }
        else{
            timer1?.invalidate()
            timer1 = nil
        }
    }
    
    
    //MARK:- Action Handlers
    @IBAction func EndTap(sender: AnyObject) {
        print("endTap")
        //停止定位
        mapView.showsUserLocation = false
        endTime = NSDate()
        save()
//        let mainVC = inf.getVC("mainVC")
//        presentViewController(mainVC, animated: true, completion: nil)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func PauseTap(sender: AnyObject) {
        if mapView!.showsUserLocation{
            AvaiblePoints = 0
            mapView.showsUserLocation = false
            计时Timer(false)
        } else{
            mapView.showsUserLocation = true
            计时Timer(true)
        }
    }

    //MARK:- 保存
    func save(){
        let current = RunningData()
        current.locations = locations
        current.startTime = startTime
        current.endTime = endTime
        current.distance = distance
        current.seconds = self.seconds
        current.kind = "run"
        let x = NSUserDefaults.standardUserDefaults()
        var history:[RunningData] = []
        var historyData:NSData
        if let a = x.objectForKey("history") as? NSData {
            history = NSKeyedUnarchiver.unarchiveObjectWithData(a) as![RunningData]
        } else {
            history = []
        }
        
        history.append(current)
        historyData = NSKeyedArchiver.archivedDataWithRootObject(history)
        x.setObject(historyData, forKey: "history")
    }

}