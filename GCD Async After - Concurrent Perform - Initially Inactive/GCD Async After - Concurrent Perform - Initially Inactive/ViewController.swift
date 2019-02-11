//
//  ViewController.swift
//  GCD Async After - Concurrent Perform - Initially Inactive
//
//  Created by Dmitry Shapkin on 11/02/2019.
//  Copyright © 2019 Dmitry Shapkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SecondVCDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        afterBlock(seconds: 4) {
            print("Hello")
            print(Thread.current)
            print(self.currentQueueName())
            print("\r")
            self.showAlert()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondVCSegue" {
            let vc = segue.destination as! SecondViewController
            vc.delegate = self
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "Hello", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func afterBlock(seconds: Int, queue: DispatchQueue = DispatchQueue.global(), completion: @escaping () -> ()) {
        
        queue.asyncAfter(deadline: .now() + .seconds(seconds)) {
            completion()
        }
    }
    
    func currentQueueName() -> String {
        let name = __dispatch_queue_get_label(nil)
        return String(cString: name, encoding: .utf8)!
    }
}
