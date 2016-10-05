import Alamofire
import SwiftyJSON
import HTTPStatusCodes

open class SwiftRestModel: NSObject
{
    // MARK: - Properties
    
    // URL string
    open var rootUrl: String
    
    // Model attributes Dictionary
    open var data: JSON
    
    // MARK: - Init
    
    /**
    Initializer
    
    - parameter rootUrl: URL string. `""` by default.
    - parameter data   : Model attributes Dictionary. `[:]` by default.
    */
    public init(rootUrl: String = "", data: Dictionary<String, AnyObject> = [:]) {
        self.rootUrl = rootUrl
        self.data = JSON(data)
    }
    
    // MARK: - Helper methods
    
    /**
    Parse method is called after HTTP request is successful.
    It can be used in model subclass to manupulate self.data object.
    */
    open func parse() {
        
    }
    
    /**
    Checks if model is new, depending does it have data["id"].
     
    - returns: Bool
    */
    open func isNew() -> Bool {
        if (self.data["id"].exists()) {
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
    open func fetch(data parameters: Dictionary<String, String> = [:], success: ((_ response: JSON) -> ())? = nil, error: ((_ response: JSON) -> ())? = nil) {
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
    open func save(data parameters: Dictionary<String, String> = [:], encoding: ParameterEncoding = JSONEncoding.default, success: ((_ response: JSON) -> ())? = nil, error: ((_ response: JSON) -> ())? = nil) {
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
    open func destroy(success: ((_ response: JSON) -> ())? = nil, error: ((_ response: JSON) -> ())? = nil) {
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
    open func request(method:String = "get", url: String = "", data parameters: Dictionary<String, String> = [:], headers: Dictionary<String, String> = [:], encoding: ParameterEncoding = URLEncoding.default, success: ((_ response: JSON) -> ())? = nil, error: ((_ response: JSON) -> ())? = nil) {
        
        var requestMethod: Alamofire.HTTPMethod
        
        switch method {
        case "post":
            requestMethod = .post
        case "put":
            requestMethod = .put
        case "delete":
            requestMethod = .delete
        default:
            requestMethod = .get
        }
        
        Alamofire.request(url, method: requestMethod, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    let json = JSON(data: response.data!)
                    self.data = json
                    self.parse()
                    if let success = success {
                        success(json)
                    }
                case .failure(let responseError):
                    var json = JSON(["error": responseError.localizedDescription])
                    if let responseStatus = response.response?.statusCode {
                        json["status"] = JSON(responseStatus)
                    }

                    if let error = error {
                        error(json)
                    }
                }
        }
    }
}
