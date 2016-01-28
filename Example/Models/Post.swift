class Post: SwiftRestModel {
    
    let url = "http://jsonplaceholder.typicode.com/posts"
    
    init() {
        super.init(rootUrl: self.url)
    }
    
}