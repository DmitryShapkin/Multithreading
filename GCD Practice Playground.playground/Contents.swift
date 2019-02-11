// GCD Practice Playground

import UIKit
import Foundation
import PlaygroundSupport

class FirstViewController: UIViewController {
    
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FirstViewController"
        view.backgroundColor = .white
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initButton()
    }
    
    func initButton() {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.backgroundColor = .blue
        button.setTitle("Press", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10.0
        view.addSubview(button)
    }
    
    @objc func buttonPressed() {
        print("buttonPressed")
        let secondVC = SecondViewController()
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}

class SecondViewController: UIViewController {
    
    fileprivate var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SecondViewController"
        view.backgroundColor = .white
        
        self.fetchImage()
    }
    
    func fetchImage() {
        imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        queue.async {
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: imageData)

            print("first: \(Thread.current)")
            
            DispatchQueue.main.async {
                
                print("second: \(Thread.current)")
                
                let imageView = UIImageView(image: image)
                imageView.sizeToFit()

                self.view.addSubview(imageView)
            }
            print("third: \(Thread.current)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
}

let vc = FirstViewController()
let navbar = UINavigationController(rootViewController: vc)

PlaygroundPage.current.liveView = navbar
