class Post: SwiftRestModel {
    
    let url = "http://jsonplaceholder.typicode.com/posts"
    
    init(data: Dictionary<String, AnyObject> = [:]) {
        super.init(rootUrl: self.url, data: data)
    }
    
}