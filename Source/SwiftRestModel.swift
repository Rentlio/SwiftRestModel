import Alamofire
import SwiftyJSON
import HTTPStatusCodes

class SwiftRestModel
{
    // MARK: - Properties
    
    var rootUrl: String
    var data: JSON
    
    // MARK: - Init
    
    init(rootUrl: String = "", data: Dictionary<String, AnyObject> = [:]) {
        self.rootUrl = rootUrl
        self.data = JSON(data)
    }
    
    // MARK: - Helper methods
    
    func parse() {
        
    }
    
    func isNew() -> Bool {
        if (self.data["id"].isExists()) {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Rest API helper methods
    
    func fetch(data parameters: Dictionary<String, String> = [String: String](), success: ((response: JSON) -> ())? = nil, error: ((response: Any) -> ())? = nil) {
        if (self.isNew()) {
            self.request(method: "get", url: self.rootUrl, data: parameters, success: success, error: error)
        } else {
            self.request(method: "get", url: self.rootUrl + "/" + self.data["id"].stringValue, data: parameters, success: success, error: error)
        }
    }
    
    func save(data parameters: Dictionary<String, String> = [String: String](), success: ((response: JSON) -> ())? = nil, error: ((response: Any) -> ())? = nil) {
        if (self.isNew()) {
            self.request(method: "post", url: self.rootUrl, data: parameters, encoding: .JSON, success: success, error: error)
        } else {
            self.request(method: "put", url: self.rootUrl + "/" + self.data["id"].stringValue, data: parameters, encoding: .JSON, success: success, error: error)
        }
        
    }
    
    func destroy(data parameters: Dictionary<String, String> = [String: String](), success: ((response: JSON) -> ())? = nil, error: ((response: Any) -> ())? = nil) {
        if (!self.isNew()) {
            self.request(method: "delete", url: self.rootUrl + "/" + self.data["id"].stringValue, data: parameters, success: success, error: error)
        }
    }
    
    // MARK: - Rest API request method
    
    func request(method method:String, url: String, data parameters: Dictionary<String, String> = [String: String](), encoding: ParameterEncoding = ParameterEncoding.URL, success: ((response: JSON) -> ())? = nil, error: ((response: Any) -> ())? = nil) {
        
        var requestMethod: Alamofire.Method
        
        switch method {
        case "post":
            requestMethod = .POST
        case "put":
            requestMethod = .PUT
        case "delete":
            requestMethod = .DELETE
        default:
            requestMethod = .GET
        }
        
        Alamofire.request(requestMethod, url, parameters: parameters, encoding: encoding)
            .responseJSON { response in
                let json = JSON(data: response.data!)
                self.data = json
                self.parse()
                if response.result.isSuccess {
                    if success != nil {
                        success!(response: json)
                    }
                } else {
                    if error != nil {
                        error!(response: json)
                    }
                }
        }
    }
}