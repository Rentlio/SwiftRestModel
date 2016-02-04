import Alamofire
import SwiftyJSON
import HTTPStatusCodes

class SwiftRestModel
{
    // MARK: - Properties
    
    // URL string
    var rootUrl: String
    
    // Model attributes Dictionary
    var data: JSON
    
    // MARK: - Init
    
    /**
    Initializer
    
    - parameter rootUrl: URL string. `""` by default.
    - parameter data   : Model attributes Dictionary. `[:]` by default.
    */
    init(rootUrl: String = "", data: Dictionary<String, AnyObject> = [:]) {
        self.rootUrl = rootUrl
        self.data = JSON(data)
    }
    
    // MARK: - Helper methods
    
    /**
    Parse method is called after HTTP request is successful.
    It can be used in model subclass to manupulate self.data object.
    */
    func parse() {
        
    }
    
    /**
    Checks if model is new, depending does it have data["id"].
     
    - returns: Bool
    */
    func isNew() -> Bool {
        if (self.data["id"].isExists()) {
            return false
        }
        
        return true
    }
    
    // MARK: - Rest API helper methods
    
    /**
    Send GET request.
    
    - parameter data   : Request parameters Dictionary. `[:]` by default.
    - parameter success: Success handler callback. `nil` by default.
    - parameter error  : Error handler callback. `nil` by default.
    */
    func fetch(data parameters: Dictionary<String, AnyObject> = [:], success: ((response: JSON) -> ())? = nil, error: ((response: JSON) -> ())? = nil) {
        if (self.isNew()) {
            self.request(method: "get", url: self.rootUrl, data: parameters, success: success, error: error)
        } else {
            self.request(method: "get", url: self.rootUrl + "/" + self.data["id"].stringValue, data: parameters, success: success, error: error)
        }
    }
    
    /**
    Send POST/PUT request.
    Send POST request if model is new.
    Send PUT request if model is not new (has data["id"]).
    
    - parameter data    : Request parameters Dictionary. `[:]` by default.
    - parameter encoding: Parameter encoding. `.JSON` by default.
    - parameter success : Success handler callback. `nil` by default.
    - parameter error   : Error handler callback. `nil` by default.
    */
    func save(data parameters: Dictionary<String, AnyObject> = [:], encoding: ParameterEncoding = .JSON, success: ((response: JSON) -> ())? = nil, error: ((response: JSON) -> ())? = nil) {
        if (self.isNew()) {
            self.request(method: "post", url: self.rootUrl, data: parameters, encoding: encoding, success: success, error: error)
        } else {
            self.request(method: "put", url: self.rootUrl + "/" + self.data["id"].stringValue, data: parameters, encoding: encoding, success: success, error: error)
        }
        
    }
    
    /**
    Send DELETE request, only if model is not new (has data["id"]).
    
    - parameter success: Success handler callback. `nil` by default.
    - parameter error  : Error handler callback. `nil` by default.
    */
    func destroy(success success: ((response: JSON) -> ())? = nil, error: ((response: JSON) -> ())? = nil) {
        if (!self.isNew()) {
            self.request(method: "delete", url: self.rootUrl + "/" + self.data["id"].stringValue, success: success, error: error)
        }
    }
    
    /**
    Send HTTP request.
    
    - parameter method  : HTTP method. `"get"` by default.
    - parameter url     : URL string. `""` by default.
    - parameter data    : Request parameters Dictionary. `[:]` by default.
    - parameter headers : Rquest headers Dictionary. `[:]` by default.
    - parameter encoding: Parameter encoding. `.URL` by default.
    - parameter success : Success handler callback. `nil` by default.
    - parameter error   : Error handler callback. `nil` by default.
    */
    func request(method method:String = "get", url: String = "", data parameters: Dictionary<String, AnyObject> = [:], headers: Dictionary<String, String> = [:], encoding: ParameterEncoding = .URL, success: ((response: JSON) -> ())? = nil, error: ((response: JSON) -> ())? = nil) {
        
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