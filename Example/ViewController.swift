import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let posts = Post()
        posts.fetch(success: {
            response in
            print(response)
        })
    }

}