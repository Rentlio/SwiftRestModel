class Post: SwiftRestModel {
    
    init(data: Dictionary<String, AnyObject> = [:]) {
        super.init(rootUrl: "http://jsonplaceholder.typicode.com/posts", data: data)
    }
    
}