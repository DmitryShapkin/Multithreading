// GCD DispatchGroup

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class DispatchGroupTestFirst {
    private let serialQueue = DispatchQueue(label: "The Swift Dev")
    
    private let groupRed = DispatchGroup()
    
    func loadInfo() {
        serialQueue.async(group: groupRed) {
            sleep(1)
            print("1")
        }
        
        serialQueue.async(group: groupRed) {
            sleep(1)
            print("2")
        }
        
        groupRed.notify(queue: .main) {
            print("Finish")
        }
    }
}

let dispatchGroupTestFirst = DispatchGroupTestFirst()
//dispatchGroupTestFirst.loadInfo()

class DispatchGroupTestSecond {
    private let concurrentQueue = DispatchQueue(label: "The Swift Dev", attributes: .concurrent)
    
    private let groupBlack = DispatchGroup()
    
    func loadInfo() {
        groupBlack.enter()
        concurrentQueue.async(group: groupBlack) {
            sleep(3)
            print("1")
            self.groupBlack.leave()
        }
        
        groupBlack.enter()
        concurrentQueue.async(group: groupBlack) {
            sleep(3)
            print("2")
            self.groupBlack.leave()
        }
        
        groupBlack.wait()
        print("Finish")
        
        groupBlack.notify(queue: .main) {
            print("Finish Second")
        }
    }
}

let dispatchGroupTestSecond = DispatchGroupTestSecond()
//dispatchGroupTestSecond.loadInfo()

// Another practice

class EightImage: UIView {
    public var ivs = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
        
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 300, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 300, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 400, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100)))
        
        for i in 0...7 {
            ivs[i].contentMode = .scaleAspectFit
            self.addSubview(ivs[i])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var view = EightImage(frame: CGRect(x: 0, y: 0, width: 700, height: 900))
view.backgroundColor = .red

let imageURLs = ["https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "https://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://bestkora.com/IosDeveloper/wp-content/uploads/2016/12/Screen-Shot-2017-01-17-at-9.33.52-PM.png", "http://www.picture-newsletter.com/arctic/arctic-12.jpg" ]

var images = [UIImage]()

PlaygroundPage.current.liveView = view

func asyncLoadImage(imageURL: URL, runQueue: DispatchQueue, completionQueue: DispatchQueue, completion: @escaping (UIImage?, Error?) -> ()) {
    
    runQueue.async {
        do {
            let data = try Data(contentsOf: imageURL)
            completionQueue.async {
                completion(UIImage(data: data), nil)
            }
        } catch let error {
            completionQueue.async {
                completion(nil, error)
            }
        }
    }
}

func asyncGroup() {
    let aGroup = DispatchGroup()
    
    for i in 0...3 {
        aGroup.enter()
        asyncLoadImage(imageURL: URL(string: imageURLs[i])!,
                       runQueue: .global(),
                       completionQueue: .main) { (result, error) in
                        guard let image = result else { return }
                        images.append(image)
                        aGroup.leave()
        }
    }
    
    aGroup.notify(queue: .main) {
        for i in 0...3 {
            view.ivs[i].image = images[i]
        }
    }
}

func asyncURLSessionMethod() {
    for i in 4...7 {
        let url = URL(string: imageURLs[i - 4])
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                view.ivs[i].image = UIImage(data: data!)!
            }
        }
        task.resume()
    }
}


asyncGroup()
asyncURLSessionMethod()
