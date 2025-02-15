//
//  Depremler.swift
//  LİV(E)ARTHQUAKEE
//
//  Created by Mehmet Dora on 24.08.2023.
//

import UIKit
import MapKit




class Dağlar: NSObject , MKAnnotation{
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    
    init(title: String? , coordinate: CLLocationCoordinate2D, subtitle: String?) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
        
    }
    
    

}


class Depremler: NSObject , MKAnnotation{
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    
    init(title: String? , coordinate: CLLocationCoordinate2D, subtitle: String?) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
        
    }
    
    

}
