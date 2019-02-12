// Operation OperationQueue OperationBlock

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

print(Thread.current)

//let firstOperation = {
//    print("Start")
//    print(Thread.current)
//    print("Finish")
//}
//
//let queue = OperationQueue()
//queue.addOperation(firstOperation)

print(Thread.current)

var result: String?
let concatOperation = BlockOperation {
    result = "The Swift Dev"
    print(Thread.current)
}

//concatOperation.start()


//let queue = OperationQueue()
//queue.addOperation(concatOperation)
////sleep(1)
//print(result!)
//
//// Another one:

//let anotherQueue = OperationQueue()
//anotherQueue.addOperation {
//    print("test")
//    print(Thread.current)
//}

class MyThread: Thread {
    override func main() {
        print("Test main thread")
        print(Thread.current)
    }
}

let myThread = MyThread()
myThread.start()

class OperationA: Operation {
    override func main() {
        print("Test Operation A")
        print(Thread.current)
    }
}

let operationA = OperationA()
operationA.start()
