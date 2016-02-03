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
        }
        
        return true
    }
    
    // MARK: - Rest API helper methods
    
    func fetch(data parameters: Dictionary<String, AnyObject> = [:], success: ((response: JSON) -> ())? = nil, error: ((response: JSON) -> ())? = nil) {
        if (self.isNew()) {
            self.request(method: "get", url: self.rootUrl, data: parameters, success: success, error: error)
        } else {
            self.request(method: "get", url: self.rootUrl + "/" + self.data["id"].stringValue, data: parameters, success: success, error: error)
        }
    }
    
    func save(data parameters: Dictionary<String, AnyObject> = [:], success: ((response: JSON) -> ())? = nil, error: ((response: JSON) -> ())? = nil) {
        if (self.isNew()) {
            self.request(method: "post", url: self.rootUrl, data: parameters, encoding: .JSON, success: success, error: error)
        } else {
            self.request(method: "put", url: self.rootUrl + "/" + self.data["id"].stringValue, data: parameters, encoding: .JSON, success: success, error: error)
        }
        
    }
    
    func destroy(success success: ((response: JSON) -> ())? = nil, error: ((response: JSON) -> ())? = nil) {
        if (!self.isNew()) {
            self.request(method: "delete", url: self.rootUrl + "/" + self.data["id"].stringValue, success: success, error: error)
        }
    }
    
    // MARK: - Rest API request method
    
    func request(method method:String, url: String, data parameters: Dictionary<String, AnyObject> = [:], headers: Dictionary<String, String> = [:], encoding: ParameterEncoding = ParameterEncoding.URL, success: ((response: JSON) -> ())? = nil, error: ((response: JSON) -> ())? = nil) {
        
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
        
        Alamofire.request(requestMethod, url, parameters: parameters, headers: headers, encoding: encoding)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(data: response.data!)
                    self.data = json
                    self.parse()
                    if success != nil {
                        success!(response: json)
                    }
                } else {
                    let json: JSON = ["error": (response.result.error?.userInfo["NSLocalizedDescription"])!]
                    if error != nil {
                        error!(response: json)
                    }
                }
        }
    }
}