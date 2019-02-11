// GCD DispatchWorkItem

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class DispatchWorkItemOne {
    private let queue = DispatchQueue(label: "DispatchWorkItemOne", attributes: .concurrent)
    
    func create() {
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("Start task")
            
            for i in 0...1000 {
                print(i)
            }
            
        }
        
        workItem.notify(queue: .main) {
            print(Thread.current)
            print("Task has been finished")
        }
        
        queue.async(execute: workItem)
    }
}

//let dispatchWorkItemOne = DispatchWorkItemOne()
//dispatchWorkItemOne.create()

class DispatchWorkItemTwo {
    private let queue = DispatchQueue(label: "DispatchWorkItemOne")
    
    func create() {
        queue.async {
            sleep(1)
            print(Thread.current)
            print("First task")
            print("\r")
        }
        
        queue.async {
            sleep(1)
            print(Thread.current)
            print("Second task")
            print("\r")
        }
        
        let workItem = DispatchWorkItem {
            sleep(1)
            print(Thread.current)
            print("workItem")
            print("\r")
        }
        
        queue.async(execute: workItem)
        
        workItem.cancel()
        
        workItem.notify(queue: .main) {
            print(Thread.current)
            print("WorkItem has been finished")
            print("\r")
        }
    }
}

//let dispatchWorkItemTwo = DispatchWorkItemTwo()
//dispatchWorkItemTwo.create()

var view = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
var ballImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))

ballImage.backgroundColor = .yellow
ballImage.contentMode = .scaleAspectFit
view.addSubview(ballImage)

PlaygroundPage.current.liveView = view

let imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!

// # Classic

func fetchImage() {
    let queue = DispatchQueue.global(qos: .utility)
    queue.async {
        if let data = try? Data(contentsOf: imageURL) {
            DispatchQueue.main.async {
                ballImage.image = UIImage(data: data)
            }
        }
    }
}

//fetchImage()

// # Dispatch work item

func fetchImageTwo() {
    var data: Data?
    let queue = DispatchQueue.global(qos: .utility)
    
    let workItem = DispatchWorkItem(qos: .userInteractive) {
        data = try? Data(contentsOf: imageURL)
        print(Thread.current)
    }
    
    queue.async(execute: workItem)
    
    workItem.notify(queue: DispatchQueue.main) {
        if let imageData = data {
            ballImage.image = UIImage(data: imageData)
        }
    }
}

//fetchImageTwo()

// # URLSession

func fetchImageThree() {
    let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
        print(Thread.current)
        if let imageData = try? Data(contentsOf: imageURL) {
            DispatchQueue.main.async {
                print(Thread.current)
                ballImage.image = UIImage(data: imageData)
            }
        }
    }
    task.resume()
    print("here: \(Thread.current)")
}

fetchImageThree()
