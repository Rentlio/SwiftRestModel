import UIKit

class ViewController: UIViewController {
    
    let posts = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posts.fetch(success: {
            response in
            print(response)
        })
    }

}