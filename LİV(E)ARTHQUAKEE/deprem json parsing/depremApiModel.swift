//
//  ApiParser.swift
//  LİV(E)ARTHQUAKEE
//
//  Created by Mehmet Dora on 31.05.2023.
//

import Foundation


struct veriler {
    
    let realDateString : String
    let magnituteDouble : Double
    let magnitudeString : String
    let place : String
    let time  : Int
    let detailsUrl : String
    let type : String
    let titleMagAndPlace : String
    let magnitudeTYPE : Int
    let longitute : Double
    let latitute : Double
    
    
}

struct WelcomeElement: Codable {
    let rms, eventID, location, latitude: String
    let longitude, depth: String
    let type: TypeEnum
    let magnitude: String
    let country: Country?
    let province, district, neighborhood: String?
    let date: String
    let isEventUpdate: Bool
    let lastUpdateDate: String?
}

enum Country: String, Codable {
    case i̇ran = "İran"
    case suriye = "Suriye"
    case türkiye = "Türkiye"
    case yunanistan = "Yunanistan"
    case kuzeyKıbrısTürkCumhuriyeti = "Kuzey Kıbrıs Türk Cumhuriyeti"
    case güneyKıbrısRumYönetimi = "Güney Kıbrıs Rum Yönetimi"
    case ermenistan = "Ermenistan"
    case romanya = "Romanya"
    case bulgaristan = "Bulgaristan"
    case azerbaycan = "Azerbaycan"
    case gürcistan = "Gürcistan"
    case rusya = "Rusya"
    case i̇srail = "İsrail"
    case irak = "Irak"
}

enum TypeEnum: String, Codable {
    case ml = "ML"
    case mw = "MW"
}

typealias DepremTürkiyeApiModel = [WelcomeElement]





struct DepremApiModel: Codable
 {
 
 let type: String
 let metadata: Metadata
 let features: [Feature]
 let bbox: [Double]
 }
 
 // MARK: - Feature
 struct Feature: Codable {
 let type: FeatureType
 let properties: Properties
 let geometry: Geometry
 let id: String
 }
 
 // MARK: - Geometry
 struct Geometry: Codable {
 let type: GeometryType
 let coordinates: [Double]
 }
 
 enum GeometryType: String, Codable {
 case point = "Point"
 }
 
 // MARK: - Properties
 struct Properties: Codable {
 let mag: Double
 let place: String
 let time, updated: Int
 let tz: JSONNull?
 let url, detail: String
 let felt: Int?
 let cdi, mmi: Double?
 let alert: Alert?
 let status: Status
 let tsunami, sig: Int
 let net: Net
 let code, ids: String
 let sources: String
 let types: String
 let nst: Int?
 let dmin: Double?
 let rms: Double
 let gap: Double?
 let magType: MagType?
 let type: PropertiesType
 let title: String
 }
 
 enum Alert: String, Codable {
 case green = "green"
 case red = "red"
 case yellow = "yellow"
 }
 
 enum MagType: String, Codable {
 case fa = "fa"
 case H = "H"
 case hn = "hn"
 case lg = "lg"
 case m = "m"
 case ma = "ma"
 case mb = "mb"
 case MbLg = "MbLg"
 case mb_lg = "mb_lg"
 case mc = "mc"
 case md = "md"
 case mdl = "mdl"
 case Me = "Me"
 case mfa = "mfa"
 case mh = "mh"
 case Mi = "Mi"
 case mint = "mint"
 case ml = "ml"
 case mlg = "mlg"
 case mlr = "mlr"
 case mlv = "mlv"
 case Ms = "Ms"
 case ms_20 = "ms_20"
 case ms_vx = "ms_vx"
 case Mt = "Mt"
 case mun = "mun"
 case mw = "mw"
 case mwb = "mwb"
 case mwc = "mwc"
 case mwp = "mwp"
 case mwr = "mwr"
 case mww = "mww"
 case no = "no"
 case uk = "uk"
 case Unknown = "Unknown"
 
 
 
 }
 
 enum Net: String, Codable {
 case ak = "ak"
 case at = "at"
 case ld = "ld"
 case av = "av"
 case ci = "ci"
 case hv = "hv"
 case mb = "mb"
 case nc = "nc"
 case nm = "nm"
 case nn = "nn"
 case ok = "ok"
 case pr = "pr"
 case se = "se"
 case tx = "tx"
 case us = "us"
 case uu = "uu"
 case uw = "uw"
 case pt = "pt"
 
 
 
 }
 
 enum Sources: String, Codable {
 case ak = ",ak,"
 case akAtUs = ",ak,at,us,"
 case akUs = ",ak,us,"
 case av = ",av,"
 case avAk = ",av,ak,"
 case ci = ",ci,"
 case ciUs = ",ci,us,"
 case hv = ",hv,"
 case hvUs = ",hv,us,"
 case mb = ",mb,"
 case mbUs = ",mb,us,"
 case nc = ",nc,"
 case ncNn = ",nc,nn,"
 case ncUs = ",nc,us,"
 case nm = ",nm,"
 case nn = ",nn,"
 case nnUs = ",nn,us,"
 case ok = ",ok,"
 case pr = ",pr,"
 case ptUsPR = ",pt,us,pr,"
 case se = ",se,"
 case tx = ",tx,"
 case txUs = ",tx,us,"
 case us = ",us,"
 case usAk = ",us,ak,"
 case usHv = ",us,hv,"
 case usNm = ",us,nm,"
 case usNn = ",us,nn,"
 case usPR = ",us,pr,"
 case usPRPt = ",us,pr,pt,"
 case usTx = ",us,tx,"
 case usUsauto = ",us,usauto,"
 case usUsautoPtAt = ",us,usauto,pt,at,"
 case usautoPtUs = ",usauto,pt,us,"
 case usautoUs = ",usauto,us,"
 case uu = ",uu,"
 case uw = ",uw,"
 case uwUs = ",uw,us,"
 case ewCiAtUs = ",ew,ci,at,us,"
 case ptAt = ",pt,at,"
 case ptAtUs = ",pt,at,us,"
 case seUs = ",se,us,"
 case usAt = ",us,at,"
 case usPt = ",us,pt,"
 case usUsautoPt = ",us,usauto,pt,"
 case uuUs = ",uu,us,"
 
 
 }
 
 enum Status: String, Codable {
 case automatic = "automatic"
 case reviewed = "reviewed"
 case deleted = "deleted"
 case statusREVIEWED = "REVIEWED"
 }
 
 enum PropertiesType: String, Codable {
 case accidentalExplosion = "accidental explosion"
 case acousticNoise = "acoustic noise"
 case acoustic_noise = "acoustic_noise"
 case anthropogenic_event = "anthropogenic_event"
 case buildingCollapse = "building collapse"
 case chemicalExplosion = "chemical explosion"
 case chemical_explosion = "chemical_explosion"
 case collapse = "collapse"
 case eq = "eq"
 case industrialExplosion = "industrial explosion"
 case landslide = "landslide"
 case meteor = "meteor"
 case meteorite = "meteorite"
 case mineCollapse = "mine collapse"
 case mine_collapse = "mine_collapse"
 case mining_explosion = "mining explosion"
 case not_reported = "not reported"
 case notReported = "not_reported"
 case nuclear_explosion = "nuclear explosion"
 case other = "other"
 case quarry = "quarry"
 case quarryBlast = "quarry blast"
 case quarry_blast = "quarry_blast"
 case rockBurst = "rock burst"
 case RockSlide = "Rock Slide"
 case rockslide = "rockslide"
 case rock_burst = "rock_burst"
 case snowAvalanche = "snow avalanche"
 case snow_avalanche = "snow_avalanche"
 case sonicBoom = "sonic boom"
 case sonicboom = "sonicboom"
 case sonic_boom = "sonic_boom"
 case trainCrash = "train crash"
 case volcanicEruption = "volcanic eruption"
 case volcanicExplosion = "volcanic explosion"
 case earthquake = "earthquake"
 case explosion = "explosion"
 case experimentalExplosion = "experimental explosion"
 case iceQuake = "ice quake"
 case otherEvent = "other event"
 }
 
 enum FeatureType: String, Codable {
 case feature = "Feature"
 }
 
 // MARK: - Metadata
 struct Metadata: Codable {
 let generated: Int
 let url: String
 let title: String
 let status: Int
 let api: String
 let count: Int
 }
 
 // MARK: - Encode/decode helpers
 
 class JSONNull: Codable, Hashable {
 
 public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
 return true
 }
 
 public var hashValue: Int {
 return 0
 }
 
 public init() {}
 
 public required init(from decoder: Decoder) throws {
 let container = try decoder.singleValueContainer()
 if !container.decodeNil() {
 throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
 }
 }
 
 public func encode(to encoder: Encoder) throws {
 var container = encoder.singleValueContainer()
 try container.encodeNil()
 }
 }
 
 
