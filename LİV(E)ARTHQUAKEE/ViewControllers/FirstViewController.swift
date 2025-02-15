//
//  FirstViewController.swift
//  LİV(E)ARTHQUAKEE
//
//  Created by Mehmet Dora on 22.05.2023.
//

import UIKit
import Foundation
import Lottie


class FirstViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,UISearchBarDelegate,UITabBarControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var alarmButton: UIImageView!
    
    
    
    var refreshControl = UIRefreshControl()
    let depremApiClass = depremApiParser()
    var BütünVeriler : [veriler] = []
    var FiltreliVeriler : [veriler] = []
    var TürkiyedenDepremler : [veriler] = []
    var dört_altıARasıVEriler : [veriler] = []
    var altıÜzeriVEriler : [veriler] = []
    var filtrelenmişPlaceNames : [veriler] = []
    
    let time = Date()
    let format = DateFormatter()
    var chosenUrl = ""
    var currentMounth = ""
    var currentDay = ""
    var currentHour = ""
    var currentMinute = ""
    var depSaati = ""
    var depDakkikası = ""
    var minute  = ""
    var day = ""
    var mounth = ""
    var year = ""
    var kaçGünlükVeriÇekilecek = 2 // default değeri
    var diğergün = 0
    var öncekiAy = ""
    var öncekiYıl = ""
    var filtring = false
    var Editing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                    
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gotoalarm))
        alarmButton.isUserInteractionEnabled = true
        alarmButton.addGestureRecognizer(gesture)
        
        // FUNCTİONS
        hideKeyboard()
        
        
        
        
        // REFRESH CONTROL
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Data...",attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        refreshControl.backgroundColor = UIColor(cgColor: CGColor(red: 80.0/255.0, green: 9.0/255.0, blue: 1.0/255.0, alpha: 1.0))
        
        tableView.addSubview(refreshControl)
        
        
        // GET CURRENT DATE
        format.dateFormat = "yyyy-MM-dd hh:mm a"
        var date = format.string(from: time).components(separatedBy: " ")
        print("\(date.description)")
        var tarih = date[0].components(separatedBy: "-")
        var saat = date[1].components(separatedBy: ":")
        var hour = "\(saat[0])"
        if date[2] != "AM" && date[2] != "ÖÖ"{
            hour = String(Int(saat[0])! + 12)
        }
        
        minute = saat[1]
        day = tarih[2]
        mounth = tarih[1]
        year = tarih[0]
        //kaçGünlükVeriÇekilecek = 2 // kaç günlük veriler çekilecek - 0 dan büyük olmalı

        
        // ay gün farkı hesaplama
        print(kaçGünlükVeriÇekilecek)
        diğergün = Int(day)! - kaçGünlükVeriÇekilecek
        öncekiAy = mounth
        öncekiYıl = year
        if diğergün < 0  || diğergün == 0{
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
        print("Current hour \(currentHour):\(currentMinute)\n")
        
        
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
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
                if tabBarIndex == 0 {

                    let indexPath = NSIndexPath(row: 0, section: 0)
                    let navigVC = viewController as? UINavigationController
                    let finalVC = navigVC?.viewControllers[0] as? FirstViewController
                    finalVC?.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)

                }
        
        
    }
  
    func scroolTOtop(){
        if tabBarController?.selectedViewController == FirstViewController(){
            
            self.tableView.scrollsToTop = true
            self.tableView.clipsToBounds = true
            self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
  
    func ReloadDates(){
        
        print(kaçGünlükVeriÇekilecek)
        diğergün = Int(day)! - kaçGünlükVeriÇekilecek
        öncekiAy = mounth
        if diğergün < 0  || diğergün == 0{
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
        
        
    }
    
    func hideKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(klavyeKapa))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
    }
    
    @objc func klavyeKapa(){
        filtring = false
        view.endEditing(true)
    }
    
  
    
    @objc func refresh(){
       
        ReloadDates()
        
        BütünVeriler.removeAll()
        FiltreliVeriler.removeAll()
        TürkiyedenDepremler.removeAll()
        dört_altıARasıVEriler.removeAll()
        altıÜzeriVEriler.removeAll()
        filtrelenmişPlaceNames.removeAll()
        
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
        
        print("REFRESHED")
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset < -120{ // scrollview ın merkezi y ye göre
            refreshControl.attributedTitle = NSAttributedString(string: "REFRESHED DATA",attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }else{
            refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Data...",attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
        refreshControl.backgroundColor = UIColor(cgColor: CGColor(red: 80.0/255.0, green: 9.0/255.0, blue: 1.0/255.0, alpha: 1.0))
    }
    
    func filterTExt(_ query : String, segmentID : Int){
        FiltreliVeriler.removeAll()
        
        // bütün veriler arasından filtreleme işlemi
        switch segmentID {
        case 0:
            FiltreliVeriler = BütünVeriler.filter({($0.titleMagAndPlace).localizedCaseInsensitiveContains(query.lowercased())})
            if !FiltreliVeriler.isEmpty{
                filtring = true
            }
        case 1:
            FiltreliVeriler = dört_altıARasıVEriler.filter({($0.titleMagAndPlace).localizedCaseInsensitiveContains(query.lowercased())})
            if !FiltreliVeriler.isEmpty{
                filtring = true
            }
        case 2:
            FiltreliVeriler = altıÜzeriVEriler.filter({($0.titleMagAndPlace).localizedCaseInsensitiveContains(query.lowercased())})
            if !FiltreliVeriler.isEmpty{
                filtring = true
            }
        case 3:
            FiltreliVeriler = TürkiyedenDepremler.filter({($0.titleMagAndPlace).localizedCaseInsensitiveContains(query.lowercased())})
            if !FiltreliVeriler.isEmpty{
                filtring = true
            }
        
        default:
            let alert = UIAlertController(title: "Something Wrong", message: "There is some error while searching!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            present(alert,animated: true)
        }
       
    
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if let text = textField.text{
            filterTExt(text + string,segmentID: segmentController.selectedSegmentIndex)
        }
        tableView.reloadData()
        return true
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
    
    
    
    func zamanFarkınıBul(tarihString : String) -> String { // depremin gerçekleştiği tarihi ver , şu an ile aradaki farkı al
        // gelen veri ya 2023-08-22T01:34:12  yada 2023-08-23T16:10:20.040Z böyle
        //2023-12-03 T 10:35:57.353Z
        
        var depMounth = tarihString.components(separatedBy: "T")[0].components(separatedBy: "-")[1]
        var depDay = tarihString.components(separatedBy: "T")[0].components(separatedBy: "-")[2]
        
        var depHour = ""
        var depMinute = ""
        
        if tarihString.components(separatedBy: "T")[1].components(separatedBy: ".").count < 2 {
            
            depHour = tarihString.components(separatedBy: "T")[1].components(separatedBy: ":")[0]
            depMinute = tarihString.components(separatedBy: "T")[1].components(separatedBy: ":")[1]
        }else{
            depHour = tarihString.components(separatedBy: "T")[1].components(separatedBy: ".")[0].components(separatedBy: ":")[0]
            depMinute = tarihString.components(separatedBy: "T")[1].components(separatedBy: ".")[0].components(separatedBy: ":")[1]
        }
        
        
        self.depSaati = depHour
        self.depDakkikası = depMinute
        
        
        
        
        if depMounth == self.currentMounth && depDay == self.currentDay{
            if depHour == self.currentHour {
                return "\(String(Int(self.currentMinute)! - Int(depMinute)!)) dk. önce"
            }else{
                return "\(String(Int(self.currentHour)! - Int(depHour)!)) sa. önce"
            }
        }else if depMounth == self.currentMounth && depDay != self.currentDay{
            if Int(currentDay)! - Int(depDay)! == 1{
                var saatFarkı = Int(currentHour)! + (24 - Int(depHour)!)
                return "\(String(saatFarkı)) sa. önce"
            }else {
                return "\(String(Int(self.currentDay)! - Int(depDay)!)) gün önce"
            }
        }else{
            var günFarkı = Int(currentDay)! + (31 - Int(depDay)!)
            
            return "\(String(günFarkı)) gün önce"
        }
        
    }
    
    
    

    
    
    @IBAction func segmentContrButton(_ sender: UISegmentedControl) {
        // when the segment controller value changed
        self.tableView.reloadData()
       
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("Türkiye verileri var *****************************-------------------")
            }
        }
    }
    
    func getData(url:String){
        depremApiClass.getDepremData(url: url) { [self] depremVeriListesi in
            if let depremVeriListesi = depremVeriListesi{
                var c = 0
                for features in depremVeriListesi.features {
                    
                    var parçalıLocationVerisi = features.properties.title.components(separatedBy: "- ")
                    // gelen veriyi kontrol et
                    var birinci = parçalıLocationVerisi[0].components(separatedBy: " ")
                    let mag = features.properties.mag
                    print(mag)
                    
                    // deprem büyüklüğüne göre kategorileme
                    var magTYPE = 0
                    
                        if 2.0 < mag && mag < 4.0 {
                            magTYPE = 1
                        }else if  4.0 <= mag && mag < 6.0 {
                            magTYPE = 2
                        }else if mag >= 6.0{
                            magTYPE = 3
                        }
                    
                        
                    if parçalıLocationVerisi[1] == "" {
                        
                        let dateString = self.giveTimeCodeGEtCurrentDate(timecode: String(features.properties.time))
                        
                        
                        let veri = veriler(realDateString: dateString, magnituteDouble: mag, magnitudeString: birinci[1], place: "UNTİTLED LOCATİON", time: features.properties.time, detailsUrl: features.properties.url, type: features.properties.type.rawValue, titleMagAndPlace: features.properties.title, magnitudeTYPE: magTYPE,longitute: features.geometry.coordinates[0],latitute: features.geometry.coordinates[1])
                        
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
                        
                        let veri = veriler(realDateString: dateString, magnituteDouble: mag, magnitudeString: birinci[1], place:features.properties.place ?? "UNTİTLED LOCATİON", time: features.properties.time, detailsUrl: features.properties.url, type: features.properties.type.rawValue, titleMagAndPlace: features.properties.title, magnitudeTYPE: magTYPE,longitute: features.geometry.coordinates[0],latitute: features.geometry.coordinates[1])
                        
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

                DispatchQueue.main.async {
                    self.tableView.reloadData()
              }
            print("Dünya verileri var *****************************-------------------")
            }
        }
    }
    
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if textField.isEditing{
            if !FiltreliVeriler.isEmpty{
                return "There are \(FiltreliVeriler.count) data."
            }else{
                return "No Data"
            }
            
        }
        
        if segmentController.selectedSegmentIndex == 0{
            return "There are \(BütünVeriler.count) data."
        }else if segmentController.selectedSegmentIndex == 1{
            if dört_altıARasıVEriler.isEmpty {
                return "No Data"
            }else{
                return "There are \(dört_altıARasıVEriler.count) data."
            }
        }else if segmentController.selectedSegmentIndex == 2{
            if altıÜzeriVEriler.isEmpty {
                return "No Data"
            }else{
                return "There are \(altıÜzeriVEriler.count) data."
            }
            
        }else {
            if TürkiyedenDepremler.isEmpty {
                return "No Data"
            }else{
                return "There are \(TürkiyedenDepremler.count) data."
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        
        if !FiltreliVeriler.isEmpty{
            
            cell.kaçDKönceLabel.text = self.zamanFarkınıBul(tarihString: self.FiltreliVeriler[indexPath.row].realDateString)
            cell.saatLabel.text = "\(self.depSaati):\(self.depDakkikası)"
            cell.locationLabel.text = self.FiltreliVeriler[indexPath.row].place
            cell.depremBüyüklüğüLabel.text = self.FiltreliVeriler[indexPath.row].magnitudeString

            
        }else{
            
            if BütünVeriler.isEmpty{
                cell.locationLabel.text = "Unknow"
                cell.depremBüyüklüğüLabel.text = "-.-"
                cell.kaçDKönceLabel.text = "Unknow"
                cell.saatLabel.text = "Unknow"
            }
            else{
                
                if segmentController.selectedSegmentIndex == 0 {
                    
                    cell.kaçDKönceLabel.text = self.zamanFarkınıBul(tarihString: self.BütünVeriler[indexPath.row].realDateString)
                    cell.saatLabel.text = "\(self.depSaati):\(self.depDakkikası)"
                    cell.locationLabel.text = self.BütünVeriler[indexPath.row].place
                    cell.depremBüyüklüğüLabel.text = self.BütünVeriler[indexPath.row].magnitudeString
                    
                }
                else if segmentController.selectedSegmentIndex == 1{
                    
                    cell.kaçDKönceLabel.text = self.zamanFarkınıBul(tarihString: self.dört_altıARasıVEriler[indexPath.row].realDateString)
                    cell.saatLabel.text = "\(self.depSaati):\(self.depDakkikası)"
                    cell.locationLabel.text = self.dört_altıARasıVEriler[indexPath.row].place
                    cell.depremBüyüklüğüLabel.text = self.dört_altıARasıVEriler[indexPath.row].magnitudeString
                    
                }
                else if segmentController.selectedSegmentIndex == 2{
                    
                    cell.kaçDKönceLabel.text = self.zamanFarkınıBul(tarihString: self.altıÜzeriVEriler[indexPath.row].realDateString)
                    cell.saatLabel.text = "\(self.depSaati):\(self.depDakkikası)"
                    cell.locationLabel.text = self.altıÜzeriVEriler[indexPath.row].place
                    cell.depremBüyüklüğüLabel.text = self.altıÜzeriVEriler[indexPath.row].magnitudeString
                    
                }
                else if segmentController.selectedSegmentIndex == 3 {
                    
                    cell.kaçDKönceLabel.text = self.zamanFarkınıBul(tarihString: self.TürkiyedenDepremler[indexPath.row].realDateString)
                    cell.saatLabel.text = "\(self.depSaati):\(self.depDakkikası)"
                    cell.locationLabel.text = self.TürkiyedenDepremler[indexPath.row].place
                    cell.depremBüyüklüğüLabel.text = self.TürkiyedenDepremler[indexPath.row].magnitudeString
                    
                }
                
            }
            
        }
        
      
        return cell
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !FiltreliVeriler.isEmpty{
            
            if FiltreliVeriler[indexPath.row].detailsUrl != ""{
            
                chosenUrl = FiltreliVeriler[indexPath.row].detailsUrl
                performSegue(withIdentifier: "toDetails", sender: self)
            }
            
        }else{
            
            switch self.segmentController.selectedSegmentIndex{
                    case 0:
                        if BütünVeriler.isEmpty{
                            
                        }else{
                            if BütünVeriler[indexPath.row].detailsUrl == ""{
                                
                            }else{
                                chosenUrl = BütünVeriler[indexPath.row].detailsUrl
                                performSegue(withIdentifier: "toDetails", sender: self)
                            }
                            
                        }
                    case 1:
                        if dört_altıARasıVEriler.isEmpty{
                            
                        }else{
                            if dört_altıARasıVEriler[indexPath.row].detailsUrl == ""{
                                
                            }else{
                                chosenUrl = dört_altıARasıVEriler[indexPath.row].detailsUrl
                                performSegue(withIdentifier: "toDetails", sender: self)
                            }
                            
                        }
                        case 2:
                            if altıÜzeriVEriler.isEmpty{
                                
                            }else{
                                if altıÜzeriVEriler[indexPath.row].detailsUrl == ""{
                                    
                                }else{
                                    chosenUrl = altıÜzeriVEriler[indexPath.row].detailsUrl
                                    performSegue(withIdentifier: "toDetails", sender: self)
                                }
                                
                            }
                        case 3:
                            print("no url")
                        default :
                            print("ok")
                    }
                    
        }
        
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let destinationVc = segue.destination as! FirstViewDepremDetailsVC
            destinationVc.Url = chosenUrl
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !FiltreliVeriler.isEmpty{
            return FiltreliVeriler.count
        }else if filtring == true{
                return 0
        }else{
            switch self.segmentController.selectedSegmentIndex{
                                    case 0:
                                        if BütünVeriler.isEmpty{
                                            return 15
                                        }else{
                                            return  BütünVeriler.count
                                        }
                                    case 1:
                                        return  self.dört_altıARasıVEriler.count
                                    case 2:
                                        return self.altıÜzeriVEriler.count
                                    case 3:
                                        return self.TürkiyedenDepremler.count
                                    default :
                                        return 0
                    }
        }
       
    }
    
   

    @objc func gotoalarm(){
        performSegue(withIdentifier: "toAlarm", sender: nil)
    }
     
    @objc func gotoDetails(){
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    

}
