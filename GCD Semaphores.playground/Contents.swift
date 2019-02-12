// GCD Semaphores

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "The Swift Dev", attributes: .concurrent)

let semaphore = DispatchSemaphore(value:0)

queue.async {
    semaphore.wait() // -1
    sleep(3)
    print("Method One")
    print(Thread.current)
    semaphore.signal() // +1
}

queue.async {
    semaphore.wait() // -1
    sleep(3)
    print("Method Two")
    print(Thread.current)
    semaphore.signal() // +1
}

queue.async {
    semaphore.wait() // -1
    sleep(3)
    print("Method Three")
    print(Thread.current)
    semaphore.signal() // +1
}

// Another one

let sem = DispatchSemaphore(value: 0)

DispatchQueue.concurrentPerform(iterations: 10) { (id: Int) in
    sem.wait(timeout: DispatchTime.distantFuture)
    sleep(1)
    print("Block", String(id))
    sem.signal()
}

// Another one

class SemaphoreTest {
    private let semaphoreNew = DispatchSemaphore(value: 2)
    private var array = [Int]()
    
    private func someMethod(_ id: Int) {
        semaphoreNew.wait() // -1
        array.append(id)
        print("Test array: \(array.count)")
        Thread.sleep(forTimeInterval: 2)
        semaphoreNew.signal() // +1
    }
    
    public func startAllThreads() {
        DispatchQueue.global().async {
            self.someMethod(111)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.someMethod(1231)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.someMethod(1123)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.someMethod(311)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.someMethod(133)
            print(Thread.current)
        }
    }
}

let semaphoreTest = SemaphoreTest()
semaphoreTest.startAllThreads()
