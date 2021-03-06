import UIKit
import CoreMotion
import KVNProgress

class MapViewController: UIViewController ,MAMapViewDelegate, AMapSearchDelegate,UIAlertViewDelegate{


    @IBOutlet weak var mapView: MAMapView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var averageLabel: UILabel!
    
    @IBOutlet weak var setpsLabel: UILabel!
    var search:AMapSearchAPI?
    var currentLocation:CLLocation?
    var locations: NSMutableArray! = []
    let distanceFilter: CLLocationDistance = 2
    var distance:Double = 0
    var seconds:Int = 0
    var AvaiblePoints:Int = 0
    var timer1:NSTimer?
    var typeIconTimer:NSTimer?
    var startTime:NSDate! = NSDate()
    var endTime:NSDate! = NSDate()
    var steps:Int = 0
    var pauseStep:Int = 0
    var pauseTime:NSDate = NSDate()
    let pedometer = CMPedometer()
    var flags: NSMutableArray! = []

    @IBOutlet weak var typeIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMapView()
        initSearch()
        计时Timer()
        startTime = NSDate()
        StartReadStep()
        showWeakGps(true)
        
        self.changeNavigationBarTextColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true


        let pauseItem = UIApplicationShortcutItem(type: "暂停/停止", localizedTitle: "暂停/停止")
        UIApplication.sharedApplication().shortcutItems = [pauseItem]

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pause", name: "pause", object: nil)

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
            updateSpeed(userLocation)
            if (currentLocation?.horizontalAccuracy < kCLLocationAccuracyNearestTenMeters*3 && currentLocation?.horizontalAccuracy > 0 ){
                if(AvaiblePoints > 3){
                    showWeakGps(false)
                    addRoutePoint(mapView!.userLocation.location)
                    showRoute()
                }
                else {AvaiblePoints++}
            }else{
                AvaiblePoints = 0
                showWeakGps(true)
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
        distanceLabel.text = String(format: "%.2f", distance/1000)
    }
    func updateSpeed(loc:MAUserLocation){
        var speed = Double(loc.location.speed)
        if speed < 0 {speed = 0}
        speedLabel.text = String(format: "%.2f", speed)
    }
    func updateTime(){
        let min=seconds/60;
        let hour=min/60;
        timeLabel.text = String(format: "%d:%d:%d",hour%24,min%60,seconds%60)
    }
    func uodateAverage(){
        let avg = distance / Double(seconds)
        averageLabel.text = String(format: "%.2f", avg)
    }

    func updateTypeIcon(){
        let image:UIImage!
        switch JudgingRuningType(){
        case .cycling:image = UIImage(named: "骑车")
        case .walking:image = UIImage(named: "走路")
        case .runing:image = UIImage(named: "跑步")
        }
        typeIcon.image = image

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

        self.typeIconTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "updateTypeIcon", userInfo: nil, repeats: true)
        }

        else{
            timer1?.invalidate()
            timer1 = nil
            typeIconTimer?.invalidate()
            typeIconTimer = nil
        }
    }
//MARK:- 计步器
    func StartReadStep(){
        if CMPedometer.isStepCountingAvailable() != true{
            self.setpsLabel.text = "传感器错误"
            return
        }
        pedometer.startPedometerUpdatesFromDate(startTime){
            data, error in
            if error == nil{
//                print(data!.numberOfSteps)
                dispatch_async(dispatch_get_main_queue(), {
                    print("\(self.pauseStep),\(data!.numberOfSteps)")
                    self.steps = Int(data!.numberOfSteps) - self.pauseStep
                    self.setpsLabel.text = "\(self.steps)"
                });
            }
        }
    }
    
    func stopReadStep(){
        pedometer.stopPedometerUpdates()
    }
    
    func pauseTimeCount(){
        pedometer.queryPedometerDataFromDate(pauseTime, toDate: NSDate()){
            data,err in
            if err != nil {return}
            dispatch_async(dispatch_get_main_queue(), {
                self.pauseStep += Int((data?.numberOfSteps)!)
            });
        }
    }
    
    //MARK:- Action Handlers
    @IBAction func EndTap(sender: AnyObject) {
        print("endTap")
        //停止定位
        mapView.showsUserLocation = false
        endTime = NSDate()
        popSaveAlert()


    }
    
    @IBAction func PauseTap(sender: AnyObject) {
        pause()
    }

    func pause(){
        if mapView!.showsUserLocation{
            AvaiblePoints = 0
            mapView.showsUserLocation = false
            计时Timer(false)
            pauseTime = NSDate()
            stopReadStep()
        } else{
            mapView.showsUserLocation = true
            pauseTimeCount()
            计时Timer(true)
            StartReadStep()
        }

    }

    //MARK:- 保存

    func JudgingRuningType()->RunningType{
        //Judging Runing Type
        let distancePerStep = Double(distance)/Double(steps)
        let avg = distance / Double(seconds)

        if distancePerStep > 2{return RunningType.cycling}
        else if avg > 1.4 {return RunningType.runing}
        else {return RunningType.walking}
    }


    func save(){
        let current = RunningData()
        current.locations = locations
        current.startTime = startTime
        current.endTime = endTime
        current.distance = distance
        current.seconds = self.seconds
        current.steps = self.steps
        current.kind = JudgingRuningType()

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
        inf.计算路程()
        KVNProgress.showSuccessWithStatus("保存成功")
    }

//MARK:- 警告
    func popSaveAlert(){
        let alert = UIAlertController(title: "保存运动", message: "需要保留此次记录嘛？", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "保存！", style: UIAlertActionStyle.Default){
            _ in
            self.save();

            let startItem = UIApplicationShortcutItem(type: "开始跑步", localizedTitle: "开始跑步")
            UIApplication.sharedApplication().shortcutItems = [startItem]

            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "算了吧", style: UIAlertActionStyle.Cancel) {
            _ in
            let startItem = UIApplicationShortcutItem(type: "开始跑步", localizedTitle: "开始跑步")
            UIApplication.sharedApplication().shortcutItems = [startItem]

            self.dismissViewControllerAnimated(true, completion: nil)

            })
        
        presentViewController(alert, animated: true, completion: nil)
        }

    func showWeakGps(isWeak:Bool){
        if (isWeak && self.view.viewWithTag(50) == nil){
            let x = UILabel(frame: CGRectMake(0 , sHeight - 104, sWidth, 50.0))
            x.backgroundColor = UIColor.blackColor()
            x.alpha = 0.5
            x.textColor = UIColor.whiteColor()
            x.tag = 50
            x.text = "GPS信号弱，将会影响定位及位置记录。"
            x.textAlignment = NSTextAlignment.Center
            self.view.addSubview(x)
        }
        else{
            let x = self.view.viewWithTag(50) as? UILabel
            x?.removeFromSuperview()
        }
    }

}