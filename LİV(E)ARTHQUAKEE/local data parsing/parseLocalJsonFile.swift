//
//  parseLocalJsonFile.swift
//  LİV(E)ARTHQUAKEE
//
//  Created by Mehmet Dora on 20.10.2023.
//

import Foundation


struct volkanlar{
    let dağ_ismi : String
    let ülke_ismi : String
    let latitude : Double
    let longitude : Double
}


struct VolkanikDağlar : Decodable{
    
    let Volcanoes : [volkan]
    
    
    
}
struct volkan : Decodable{
    
    let Column3 : String // dağ ismi
    let Column5 : String // ülke
    let Column7 : String
    let Column8 : Int
    let Column9 : Int
    let Column10 : Int
    let Column11 : String
    let Column12 : Int
    let Column13 : Int
    let Column14 : Int
    let Column15 : Double // latitude
    let Column16 : Double // longitude
    
}
