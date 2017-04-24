import Just
import SwiftyJSON

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
        if data["id"].exists() {
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
    open func fetch(data parameters: Dictionary<String, Any> = [:], success: ((_ res: JSON) -> ())? = nil, error: ((_ res: JSON) -> ())? = nil) {
        if isNew() {
            req(method: .get, url: self.rootUrl, data: parameters, success: success, error: error)
        } else {
            req(method: .get, url: self.rootUrl + "/" + self.data["id"].stringValue, data: parameters, success: success, error: error)
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
    open func save(data parameters: Dictionary<String, Any> = [:], success: ((_ res: JSON) -> ())? = nil, error: ((_ res: JSON) -> ())? = nil) {
        if isNew() {
            req(method: .post, url: self.rootUrl, data: parameters, success: success, error: error)
        } else {
            req(method: .put, url: self.rootUrl + "/" + self.data["id"].stringValue, data: parameters, success: success, error: error)
        }
        
    }
    
    /**
    Send DELETE request, only if model is not new (has data["id"]).
    
    - parameter success: Success handler callback. `nil` by default.
    - parameter error  : Error handler callback. `nil` by default.
    */
    open func destroy(success: ((_ res: JSON) -> ())? = nil, error: ((_ res: JSON) -> ())? = nil) {
        if !isNew() {
            req(method: .delete, url: self.rootUrl + "/" + self.data["id"].stringValue, success: success, error: error)
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
    
    open func req(method: HTTPMethod = .get, url: String = "", data parameters: Dictionary<String, Any> = [:], headers: Dictionary<String, String> = [:], success: ((_ res: JSON) -> ())? = nil, error: ((_ res: JSON) -> ())? = nil) {
        
        let r = Just.request(method, url: url, params: parameters, data:parameters, headers: headers)
        
        if r.ok {
            var json = JSON(data: r.content!)
            if let statusCode = r.statusCode {
                json["status"] = JSON(statusCode)
            }
            self.data = json
            self.parse()
            if let success = success {
                success(json)
            }
        } else {
            var json = JSON(["error": r.error?.localizedDescription])
            if let statusCode = r.statusCode {
                json["status"] = JSON(statusCode)
            }
            if let error = error {
                error(json)
            }
        }
        
    }
}
