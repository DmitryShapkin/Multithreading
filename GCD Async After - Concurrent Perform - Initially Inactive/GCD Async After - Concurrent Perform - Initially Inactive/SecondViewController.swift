//
//  SecondViewController.swift
//  GCD Async After - Concurrent Perform - Initially Inactive
//
//  Created by Dmitry Shapkin on 11/02/2019.
//  Copyright © 2019 Dmitry Shapkin. All rights reserved.
//

import UIKit

protocol SecondVCDelegate {
    func currentQueueName() -> String
}

class SecondViewController: UIViewController {
    
    var delegate: SecondVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let queue = DispatchQueue.global(qos: .utility)
        queue.async {

            DispatchQueue.concurrentPerform(iterations: 200000) {
                print("\($0) times")
                print(Thread.current)

                if let string = self.delegate?.currentQueueName() {
                    print(string)
                }
                print("\r")
            }
        }
        
        myInactiveQueue()
    }
    
    func myInactiveQueue() {
        let inactiveQueue = DispatchQueue(label: "The Swift Dev", attributes: [.concurrent, .initiallyInactive])
        
        inactiveQueue.async {
            print("Done!")
        }
        
        print("Not yet started...")
        inactiveQueue.activate()
        print("Activate!")
        inactiveQueue.suspend()
        print("Pause!")
        inactiveQueue.resume()
    }
}
