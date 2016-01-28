import UIKit

class ViewController: UIViewController {
    
    let post = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        post.fetch()
    }

}