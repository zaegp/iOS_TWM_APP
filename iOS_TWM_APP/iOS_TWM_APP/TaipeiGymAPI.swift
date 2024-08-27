import UIKit
import Alamofire
import CoreLocation

enum CityName: String {
    case TPE = "台北市"
    case KHH = "高雄市"
    case TNN = "台南市"
    case TXG = "台中市"
    case TYC = "桃園市"
    case HSZ = "新竹市"
    case KEE = "基隆市"
    case CYI = "嘉義市"
    case NTPC = "新北市"
    case PIF = "屏東縣"
    case ILA = "宜蘭縣"
    case HUN = "花蓮縣"
    case TTT = "台東縣"
    case CHA = "彰化縣"
    case NTO = "南投縣"
    case YUN = "雲林縣"
    case CYQ = "嘉義縣"
    case PEN = "澎湖縣"
    case KIN = "金門縣"
    case LIE = "連江縣"
    case MIA = "苗栗縣"

    static func getCityName(from abbreviation: String) -> String {
        switch abbreviation {
        case "TPE": return CityName.TPE.rawValue
        case "KHH": return CityName.KHH.rawValue
        case "TNN": return CityName.TNN.rawValue
        case "TXG": return CityName.TXG.rawValue
        case "TYC": return CityName.TYC.rawValue
        case "HSZ": return CityName.HSZ.rawValue
        case "KEE": return CityName.KEE.rawValue
        case "CYI": return CityName.CYI.rawValue
        case "NTPC": return CityName.NTPC.rawValue
        case "PIF": return CityName.PIF.rawValue
        case "ILA": return CityName.ILA.rawValue
        case "HUN": return CityName.HUN.rawValue
        case "TTT": return CityName.TTT.rawValue
        case "CHA": return CityName.CHA.rawValue
        case "NTO": return CityName.NTO.rawValue
        case "YUN": return CityName.YUN.rawValue
        case "CYQ": return CityName.CYQ.rawValue
        case "PEN": return CityName.PEN.rawValue
        case "KIN": return CityName.KIN.rawValue
        case "LIE": return CityName.LIE.rawValue
        case "MIA": return CityName.MIA.rawValue
        default: return "未知縣市"
        }
    }
}


class TaipeiGymAPI: UIViewController{
    var City: String = ""
    var Country: String = ""
    var gymDataArray:[Value]? = []
    var onGymDataReceived: (([Value]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension TaipeiGymAPI {
    // MARK: --抓縣市
    func getLocationDetails(latitude: Double, longitude: Double) {
        print("Requesting gyms near: \(latitude), \(longitude)")
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("反向地理編碼失敗: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let county = placemark.administrativeArea ?? "未知縣市"
                let town = placemark.locality ?? "未知鄉鎮"
                self.City = CityName.getCityName(from: county)
                self.Country = town
                self.searchGym(String(latitude), String(longitude))


            }
        }
    }
    
    func searchGym(_ Latitude: String, _ Longitude: String, nextPageURL: String? = nil) {
        let url: String
        if let nextPage = nextPageURL {
            url = nextPage
        } else {
            url = "https://iplay.sa.gov.tw/odata/GymSearch"
        }

        let headers: HTTPHeaders = [
            "Accept": "application/json;odata.metadata=none"
        ]
        
        var parameters: [String: Any] = [:]
        if nextPageURL == nil {
            parameters = [
                "City": City,
                "Country": Country,
                "Latitude": Latitude,
                "Longitude": Longitude,
                "top": 10,
                "orderby": "Distance asc"
            ]
        }

        AF.request(url, parameters: parameters, headers: headers).responseDecodable(of: GymData.self) { response in
            switch response.result {
            case .success(let gymData):
                for value in gymData.value {
                    if !(self.gymDataArray?.contains(where: { $0.gymID == value.gymID }) ?? false) {
                        self.gymDataArray?.append(value)
                    }
                }
                
                if let nextLink = gymData.odataNextLink {
                    self.searchGym(Latitude, Longitude, nextPageURL: nextLink)
                } else {
                    if let gymDataArray = self.gymDataArray {
                        self.onGymDataReceived?(gymDataArray)
                    }
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

}








// MARK: - GymData
struct GymData: Codable {
    let value: [Value]
    let odataNextLink: String?

       enum CodingKeys: String, CodingKey {
           case value
           case odataNextLink = "@odata.nextLink"
       }
}

// MARK: - Value
struct Value: Codable {
    let gymID: Int
    let name, operationTel, address: String
    let rate, rateCount: Int
    let distance: Double
    let gymFuncList: String
    let photo1: String
    let latLng: String
    let rentState, openState, declaration, landAttrName: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case gymID = "GymID"
        case name = "Name"
        case operationTel = "OperationTel"
        case address = "Address"
        case rate = "Rate"
        case rateCount = "RateCount"
        case distance = "Distance"
        case gymFuncList = "GymFuncList"
        case photo1 = "Photo1"
        case latLng = "LatLng"
        case rentState = "RentState"
        case openState = "OpenState"
        case declaration = "Declaration"
        case landAttrName = "LandAttrName"
    }
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



