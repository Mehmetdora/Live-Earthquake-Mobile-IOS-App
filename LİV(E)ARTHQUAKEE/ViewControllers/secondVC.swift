//
//  secondVC.swift
//  LİV(E)ARTHQUAKEE
//
//  Created by Mehmet Dora on 22.05.2023.
//

import UIKit
import MapKit
import CoreLocation

class secondVC: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate{

    
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet var infoLabels: [UILabel]!
    @IBOutlet weak var segmentCVALue: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var secondLabelConst: NSLayoutConstraint!
    
    @IBOutlet weak var thirdLabelConst: NSLayoutConstraint!
    
    @IBOutlet weak var fourthLabelConst: NSLayoutConstraint!
    
    var locationManager = CLLocationManager()
    let depremApiClass = depremApiParser()
    var BütünVeriler : [veriler] = []
    var TürkiyedenDepremler : [veriler] = []
    var dört_altıARasıVEriler : [veriler] = []
    var altıÜzeriVEriler : [veriler] = []
    var volkanBilgileri : [volkanlar] = []
    
    let time = Date()
    let format = DateFormatter()
    var chosenUrl = ""
    var currentMounth = ""
    var currentDay = ""
    var currentHour = ""
    var currentMinute = ""
    var depSaati = ""
    var depDakkikası = ""
    var minute = ""
    var hour = ""
    var day = ""
    var mounth = ""
    var year = ""
    var kaçGünlükVeriÇekilecek = 2 // default
    var diğergün = 0
    var öncekiAy = ""
    var öncekiYıl = ""
    
    
    let dağDict = [
                "KARACA DAG": "https://tr.wikipedia.org/wiki/Karaca_Dağ",
                "ARARAT": "",
                "TENDUREK DAGI": "https://tr.wikipedia.org/wiki/Tendürek_Dağı",
                "NEMRUT DAGI":"https://tr.wikipedia.org/wiki/Nemrut_Dağı_(Bitlis)",
                "ERCIYES VOLCANIC COMPLEX" : "https://tr.wikipedia.org/wiki/Erciyes_Dağı",
                "HASANDAG-KECIBOYDURAN VOLCANIC COMPLEX":"https://tr.wikipedia.org/wiki/Hasan_Dağı",
                "KULA": "https://tr.wikipedia.org/wiki/Kula_Tepeleri"
                
            ]
    override func viewDidLoad() {
        super.viewDidLoad()
        

        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        selectLabel.text = "More Info"
        selectLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openİnfos))
        selectLabel.addGestureRecognizer(gesture)
        
        let g = UITapGestureRecognizer(target: self, action: #selector(closeİnfos))
        
        selectLabel.layer.cornerRadius = 10
        selectLabel.layer.masksToBounds = true
        infoLabels.forEach{ l in
            l.isUserInteractionEnabled = true
            l.addGestureRecognizer(g)
            l.layer.cornerRadius = 10
            l.layer.masksToBounds = true
        }
        
        
        
        // GET CURRENT DATE
        format.dateFormat = "yyyy-MM-dd hh:mm a"
        var date = format.string(from: time).components(separatedBy: " ")
        print("\(date.description)")
        var tarih = date[0].components(separatedBy: "-")
        var saat = date[1].components(separatedBy: ":")
        hour = saat[0]
        if date[2] != "AM" && date[2] != "ÖÖ" {
            hour = String(Int(saat[0])! + 12)
        }
        
        minute = saat[1]
        day = tarih[2]
        mounth = tarih[1]
        year = tarih[0]
        
        
        
        
        // ay gün farkı hesaplama
        print("\(kaçGünlükVeriÇekilecek) Viewdidload daki değer")
        diğergün = Int(day)! - kaçGünlükVeriÇekilecek
        
        öncekiAy = mounth
        öncekiYıl = year
        if diğergün < 0 || diğergün == 0{
            diğergün = 30 + diğergün
            
            if Int(mounth)! == 1{ // eğer diğer gün 0dan küçükse önceki ay ı azalt
                        öncekiAy = "12"
                    öncekiYıl = String(Int(öncekiYıl)!-1)
                   }else{
                           if (Int(mounth)! - 1) < 10{
                               öncekiAy = "0\(Int(mounth)! - 1)"
                           }else{
                           öncekiAy = String(Int(mounth)! - 1)
                       }
                   }

        }
        
        self.currentMounth = mounth
        self.currentDay = day
        self.currentHour = hour
        self.currentMinute = minute
        print("Current time \(currentHour):\(currentMinute)\n")
        
        
        if diğergün < 10 {
            var url = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(öncekiYıl)-\(öncekiAy)-0\(String(diğergün))&endtime=\(year)-\(mounth)-\(day)"
            
            var türkiyeDepremApiUrl = "https://deprem.afad.gov.tr/apiv2/event/filter?start=\(öncekiYıl)-\(öncekiAy)-0\(String(diğergün))T00:01:00&end=\(year)-\(mounth)-\(day)T\(currentHour):\(currentMinute):00&maxmag=8&minmag=2&orderby=timedesc"
            print("\(türkiyeDepremApiUrl)\n")
            print("\(url)\n")
           
            getTürkiyeData(url: türkiyeDepremApiUrl)
            getData(url: url)
        }else{
            var url = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(öncekiYıl)-\(öncekiAy)-\(String(diğergün))&endtime=\(year)-\(mounth)-\(day)"
            
            var türkiyeDepremApiUrl = "https://deprem.afad.gov.tr/apiv2/event/filter?start=\(öncekiYıl)-\(öncekiAy)-\(String(diğergün))T00:01:00&end=\(year)-\(mounth)-\(day)T\(currentHour):\(currentMinute):00&maxmag=8&minmag=2&orderby=timedesc"
            print("\(türkiyeDepremApiUrl)\n")
            print("\(url)\n")
           
            getTürkiyeData(url: türkiyeDepremApiUrl)
            getData(url: url)
        }
        
        // Set View
        self.secondLabelConst.constant = 61
        self.thirdLabelConst.constant = 61
        self.fourthLabelConst.constant = 61

        
        // Functions
                loadJson(filename: "List_of_Volcanoes_of_the_World_for_VAAC_Use")
                show_Mountains()
                

    }
    
    func setView(){

        var selectedSegment = segmentCVALue.selectedSegmentIndex
        if selectedSegment == 0{
            self.selectLabel.text = "There are \(self.BütünVeriler.count) data on the map"
        }else if selectedSegment == 1{
            selectLabel.text = "There are \(dört_altıARasıVEriler.count) data on the map."
        }else{
            selectLabel.text = "There are \(altıÜzeriVEriler.count) data on the map."
        }
        
        infoLabels[0].text = "There are \(TürkiyedenDepremler.count) data in Turkey."
        infoLabels[1].text = "Displaying \(kaçGünlükVeriÇekilecek) daily data."
        infoLabels[2].text = "CLOSE"
    }
    
    func openClosef(){ // 99 137 175
        
        if secondLabelConst.constant == 61{
            UIView.animate(withDuration: 1, animations: {
                self.secondLabelConst.constant = 99
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.33, animations: {
                    self.thirdLabelConst.constant = 137
                    self.view.layoutIfNeeded()
                    UIView.animate(withDuration: 0.33, animations:{
                        self.fourthLabelConst.constant = 175
                        self.view.layoutIfNeeded()
                    })
                })
            },completion: {_ in
                self.selectLabel.text = "There are \(self.BütünVeriler.count) data on the map"
            })
        }else{
            UIView.animate(withDuration: 1, animations: {
                self.secondLabelConst.constant = 61
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.33, animations: {
                    self.thirdLabelConst.constant = 61
                    self.view.layoutIfNeeded()
                    UIView.animate(withDuration: 0.33, animations:{
                        self.fourthLabelConst.constant = 61
                        self.view.layoutIfNeeded()
                    },completion: {_ in
                        self.infoLabels[2].text = "More Info"
                    })
                })
            })
        }
    }
    
    
    @objc func openİnfos(){  // ilk açıldığında verileri set etme
        openClosef()
        setView()
    }
    
    @objc func closeİnfos(){
        openClosef()
        setView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    
        print("\(kaçGünlükVeriÇekilecek) fonksiyondaki değer *********************")
        if kaçGünlükVeriÇekilecek != 2{
            
            // Reload all data
            
            // verileri silme
            BütünVeriler.removeAll()
            TürkiyedenDepremler.removeAll()
            dört_altıARasıVEriler.removeAll()
            altıÜzeriVEriler.removeAll()
            
            // pinleri silme
            for pin in mapView.annotations{
                mapView.removeAnnotation(pin)
            }
            show_Mountains()
            
            
            diğergün = Int(day)! - kaçGünlükVeriÇekilecek
            
            öncekiAy = mounth
            if diğergün < 0 || diğergün == 0{
                diğergün = 30 + diğergün
                
                if Int(mounth)! == 1{ // eğer diğer gün 0dan küçükse önceki ay ı azalt
                                       Int(öncekiAy)! == 12
                       }else{
                               if (Int(mounth)! - 1) < 10{
                                   öncekiAy = "0\(Int(mounth)! - 1)"
                               }else{
                               öncekiAy = String(Int(mounth)! - 1)
                           }
                       }

            }
            
            self.currentMounth = mounth
            self.currentDay = day
            self.currentHour = hour
            self.currentMinute = minute
            print("Current time \(currentHour):\(currentMinute)\n")
            
            
            if diğergün < 10 {
                var url = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(year)-\(öncekiAy)-0\(String(diğergün))&endtime=\(year)-\(mounth)-\(day)"
                
                var türkiyeDepremApiUrl = "https://deprem.afad.gov.tr/apiv2/event/filter?start=\(year)-\(öncekiAy)-0\(String(diğergün))T00:01:00&end=\(year)-\(mounth)-\(day)T\(currentHour):\(currentMinute):00&maxmag=8&minmag=2&orderby=timedesc"
                print("\(türkiyeDepremApiUrl)\n")
                print("\(url)\n")
               
                getTürkiyeData(url: türkiyeDepremApiUrl)
                getData(url: url)
            }else{
                var url = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(year)-\(öncekiAy)-\(String(diğergün))&endtime=\(year)-\(mounth)-\(day)"
                
                var türkiyeDepremApiUrl = "https://deprem.afad.gov.tr/apiv2/event/filter?start=\(year)-\(öncekiAy)-\(String(diğergün))T00:01:00&end=\(year)-\(mounth)-\(day)T\(currentHour):\(currentMinute):00&maxmag=8&minmag=2&orderby=timedesc"
                print("\(türkiyeDepremApiUrl)\n")
                print("\(url)\n")
               
                getTürkiyeData(url: türkiyeDepremApiUrl)
                getData(url: url)
            }
            
            
            
        }
        
    }
    
    func loadJson(filename fileName: String) -> [volkan]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonDataaa = try decoder.decode(VolkanikDağlar.self, from: data)
                for volk in jsonDataaa.Volcanoes{
                    let v = volkanlar(dağ_ismi: volk.Column3, ülke_ismi: volk.Column5, latitude: volk.Column15, longitude: volk.Column16)
                    volkanBilgileri.append(v)
                }
                return jsonDataaa.Volcanoes
            } catch {
                print("error:\(error)**********************")
            }
        }
        return nil
    }
    
    func show_Mountains(){
        for volkan in volkanBilgileri{
            
            let ülkeİsmi = volkan.ülke_ismi
            let dağ_ismi = volkan.dağ_ismi
            let longitude = volkan.longitude
            let latitude = volkan.latitude
            
            let dağ = Dağlar(title: "\(ülkeİsmi),\(dağ_ismi)_", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), subtitle: "\(latitude),\(longitude)")
            
            mapView.addAnnotation(dağ)
        }
        
    }
    
    // haritadaki verileri segment c göre güncelledik
    func show4Plus(){
        showAllLocations()
       
        for pin in mapView.annotations{
            if pin.title == "My Location" || pin.title!!.last == "_"{
            }else{
                if Double(pin.title!!.components(separatedBy: " - ")[0])! < 4.0{
                    mapView.removeAnnotation(pin)
                }
            }
            
        }
        selectLabel.text = "There are \(dört_altıARasıVEriler.count) data on the map."

    }
    
    func show6Plus(){
        
        for pin in mapView.annotations{
            if pin.title == "My Location" || pin.title!!.last == "_"{
                
            }else{
                if Double(pin.title!!.components(separatedBy: " - ")[0])! < 6.0{
                    mapView.removeAnnotation(pin)
                }
            }
            
        }
        selectLabel.text = "There are \(altıÜzeriVEriler.count) data on the map."

    }
    
    func showAllLocations(){
        
        
        
        for data in BütünVeriler{
            var date = data.realDateString.components(separatedBy: "T")[0]
            var hour = ""
            
            if data.realDateString.components(separatedBy: "T")[1].components(separatedBy: ".").count < 2{
                hour = data.realDateString.components(separatedBy: "T")[1]
            }else{
                hour = data.realDateString.components(separatedBy: "T")[1].components(separatedBy: ".")[0]
            }
            let place = Depremler(
                title: "\(data.magnitudeString) - \(data.place)",
                coordinate: CLLocationCoordinate2D(
                    latitude: data.latitute,
                    longitude: data.longitute),
                subtitle: "\(date) \(hour)")
            
            mapView.addAnnotation(place)
            
                    
        }
        selectLabel.text = "There are \(BütünVeriler.count) data on the map."

    }
    
    

    
    
    @IBAction func segmentCButtonChanged(_ sender: Any) {
        if segmentCVALue.selectedSegmentIndex == 0{
            DispatchQueue.main.async { [self] in
                showAllLocations()
            }
        }else if segmentCVALue.selectedSegmentIndex == 1{
            DispatchQueue.main.async { [self] in
                show4Plus()
            }
        }else if segmentCVALue.selectedSegmentIndex == 2{
            DispatchQueue.main.async { [self] in
                show6Plus()
            }
        }
        
        
    }
    
    
    func giveTimeCodeGEtCurrentDate(timecode : String) -> String{ // timeCode unu ver , depremin gerçeklerştiği tarihi al
        
        
        
        let timestampMilliseconds = Int(timecode)!
        let timestampSeconds = Double(timestampMilliseconds) / 1000.0
        let date = Date(timeIntervalSince1970: timestampSeconds)
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let isoFormattedDate = isoDateFormatter.string(from: date)
        
        
        return isoFormattedDate
        
    }
    
    func getTürkiyeData(url:String){
        depremApiClass.getTürkiyeDepremData(urll: url) { [self] depremler in
            if let depremler = depremler{
                for deprem in depremler{
                    var magTYPE = 0
                    if 2.0 < Double(deprem.magnitude)! && Double(deprem.magnitude)! < 4.0{
                        magTYPE = 1
                    }else if  4.0 < Double(deprem.magnitude)! && Double(deprem.magnitude)! < 6.0 {
                        magTYPE = 2
                    }else if Double(deprem.magnitude)! >= 6.0{
                        magTYPE = 3
                    }
                    
                    let veri = veriler(realDateString: deprem.date, magnituteDouble: Double(deprem.magnitude)!, magnitudeString: deprem.magnitude, place: "\(deprem.neighborhood ?? "Unknow"),\(deprem.district ?? "Unknow"),\(deprem.province ?? "Unknow")", time: 0, detailsUrl: "", type: deprem.type.rawValue, titleMagAndPlace: deprem.location , magnitudeTYPE: magTYPE,longitute: Double(deprem.longitude)!,latitute: Double(deprem.latitude)!)
                    
                    self.TürkiyedenDepremler.append(veri)
                    if veri.magnitudeTYPE == 1{
                        self.BütünVeriler.append(veri)
                    }else if veri.magnitudeTYPE == 2{
                        self.BütünVeriler.append(veri)
                        self.dört_altıARasıVEriler.append(veri)
                    }else if veri.magnitudeTYPE == 3{
                        self.BütünVeriler.append(veri)
                        self.altıÜzeriVEriler.append(veri)
                    }
                    
                }
               
                print("Türkiye verileri var *****************************-------------------")
                DispatchQueue.main.async {
                    showAllLocations()
                }
            }
        }
    }
    
    func getData(url:String){
        depremApiClass.getDepremData(url: url) { [self] depremVeriListesi in
            if let depremVeriListesi = depremVeriListesi{
                for features in depremVeriListesi.features {
                    var parçalıLocationVerisi = features.properties.title.components(separatedBy: "- ")
                    // gelen veriyi kontrol et
                    var birinci = parçalıLocationVerisi[0].components(separatedBy: " ")
                    
                    // deprem büyüklüğüne göre kategorileme
                    var magTYPE = 0
                    if 2.0 < features.properties.mag && features.properties.mag < 4.0 {
                        magTYPE = 1
                    }else if  4.0 < features.properties.mag && features.properties.mag < 6.0 {
                        magTYPE = 2
                    }else if features.properties.mag >= 6.0{
                        magTYPE = 3
                    }
                    
                    if parçalıLocationVerisi[1] == "" {
                        
                        let dateString = self.giveTimeCodeGEtCurrentDate(timecode: String(features.properties.time))
                        
                        
                        let veri = veriler(realDateString: dateString, magnituteDouble: features.properties.mag, magnitudeString: birinci[1], place: "UNTİTLED LOCATİON", time: features.properties.time, detailsUrl: features.properties.url, type: features.properties.type.rawValue, titleMagAndPlace: features.properties.title, magnitudeTYPE: magTYPE,longitute: features.geometry.coordinates[0],latitute: features.geometry.coordinates[1])
                        
                        if veri.magnitudeTYPE == 1{
                            self.BütünVeriler.append(veri)
                        }else if veri.magnitudeTYPE == 2{
                            self.BütünVeriler.append(veri)
                            self.dört_altıARasıVEriler.append(veri)
                        }else if veri.magnitudeTYPE == 3{
                            self.BütünVeriler.append(veri)
                            self.altıÜzeriVEriler.append(veri)
                        }
                        
                    }else{
                        
                        let dateString = self.giveTimeCodeGEtCurrentDate(timecode: String(features.properties.time))
                        
                        let veri = veriler(realDateString: dateString, magnituteDouble: features.properties.mag, magnitudeString: birinci[1], place:features.properties.place ?? "UNTİTLED LOCATİON", time: features.properties.time, detailsUrl: features.properties.url, type: features.properties.type.rawValue, titleMagAndPlace: features.properties.title, magnitudeTYPE: magTYPE,longitute: features.geometry.coordinates[0],latitute: features.geometry.coordinates[1])
                        
                        if veri.magnitudeTYPE == 1{
                            self.BütünVeriler.append(veri)
                        }else if veri.magnitudeTYPE == 2{
                            self.BütünVeriler.append(veri)
                            self.dört_altıARasıVEriler.append(veri)
                        }else if veri.magnitudeTYPE == 3{
                            self.BütünVeriler.append(veri)
                            self.altıÜzeriVEriler.append(veri)
                        }
                    }
                   
                }
                print("Dünyadan veriler var *****************************-------------------")
                DispatchQueue.main.async {
                    showAllLocations()
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // seçilen pinlerden sadece bir tane var
        let vc = FirstViewDepremDetailsVC()
        
        for v in self.dağDict{
            if v.key == mapView.selectedAnnotations.first?.title?!.components(separatedBy: ",")[1].components(separatedBy: "_")[0] {
                
                chosenUrl = v.value
                if v.value != ""{
                    performSegue(withIdentifier: "ToDetails", sender: self)
                }
                
            }
        }
        
        for deprem in BütünVeriler{
            if deprem.magnitudeString == mapView.selectedAnnotations.first?.title?!.components(separatedBy: " - ")[0]
                &&
                deprem.place == mapView.selectedAnnotations.first?.title?!.components(separatedBy: " - ")[1]{
                
                chosenUrl = deprem.detailsUrl
                if deprem.detailsUrl != ""{
                    performSegue(withIdentifier: "ToDetails", sender: self)
                }
            }
        }
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView!.canShowCallout = true
        let infoB = UIButton(type: .infoLight)
        infoB.tintColor = .white
        annotationView!.rightCalloutAccessoryView = infoB
        annotationView!.tintColor = UIColor.black
        
        if Double(annotation.title!!.components(separatedBy: " - ")[0]) != nil {
            
            var mag = Double(annotation.title!!.components(separatedBy: " - ")[0])!
            var AnnotationsDay = Int(annotation.subtitle!!.components(separatedBy: " ")[0].components(separatedBy: "-")[2])!
            var annotationMounth = Int(annotation.subtitle!!.components(separatedBy: " ")[0].components(separatedBy: "-")[1])!
            
            
            var depremTürü  = 0
            
            if mag < 3.0{
                depremTürü = 1
            }else if mag > 3.0 && mag < 4.0{
                depremTürü = 2
            }else if mag > 4.0 && mag < 5.0{
                depremTürü = 3
            }else if mag > 5.0 && mag < 6.0{
                depremTürü = 4
            }else if mag > 6.0 && mag < 7.0{
                depremTürü = 5
            }else if mag > 7.0 && mag < 8.0{
                depremTürü = 6
            }else {
                depremTürü = 7
            }
        
            if annotationMounth != Int(currentMounth){
                switch depremTürü{
                            case 1:
                                    annotationView?.image = UIImage(named: "sarıNokta")
                            case 2:
                                
                                    annotationView?.image = UIImage(named: "sarıBüyükp")

                            case 3:
                                    annotationView?.image = UIImage(named: "sarıKare")

                            case 4:
                                    annotationView?.image = UIImage(named: "sarıY")

                            case 5:
                                    annotationView?.image = UIImage(named: "sarıBY")

                            case 6:
                                    annotationView?.image = UIImage(named: "sarıÜ")

                            case 6:
                                break
                            case 7:
                                break
                            default:
                                break
                            }
            }else {
                
                switch depremTürü{
                            case 1:
                                if AnnotationsDay < Int(currentDay)!{
                                    annotationView?.image = UIImage(named: "sarıNokta")
                                }else{
                                    annotationView?.image = UIImage(named: "küçükrp")
                                }
                                
                            case 2:
                                if AnnotationsDay < Int(currentDay)!{
                                    annotationView?.image = UIImage(named: "sarıBüyükp")
                                }else{
                                    annotationView?.image = UIImage(named: "büyükrp")
                                }
                            case 3:
                                if AnnotationsDay < Int(currentDay)!{
                                    annotationView?.image = UIImage(named: "sarıKare")
                                }else{
                                    annotationView?.image = UIImage(named: "reds")
                                }
                            case 4:
                                if AnnotationsDay < Int(currentDay)!{
                                    annotationView?.image = UIImage(named: "sarıY")
                                }else{
                                    annotationView?.image = UIImage(named: "redStar")
                                }
                            case 5:
                                if AnnotationsDay < Int(currentDay)!{
                                    annotationView?.image = UIImage(named: "sarıBY")
                                }else{
                                    annotationView?.image = UIImage(named: "birbüyükrs")
                                }
                            case 6:
                                if AnnotationsDay < Int(currentDay)!{
                                    annotationView?.image = UIImage(named: "sarıÜ")
                                }else{
                                    annotationView?.image = UIImage(named: "üçgen")
                                }
                            case 6:
                                break
                            case 7:
                                break
                            default:
                                break
                            }
            }
            
            
            return annotationView
        }else {
            annotationView?.image = UIImage(named: "dağ")
            
            return annotationView
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetails"{
            let destinationVC = segue.destination as! FirstViewDepremDetailsVC
            destinationVC.Url = chosenUrl
        }
    }

}
