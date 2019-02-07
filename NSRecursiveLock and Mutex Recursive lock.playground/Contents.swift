// NSRecursiveLock and Mutex Recursive lock

// C implementation

import UIKit

class RecursiveMutexTest {
    private var mutex = pthread_mutex_t()
    private var attribute = pthread_mutexattr_t()
    
    init() {
        print("Initialized")
        pthread_mutexattr_init(&attribute)
        pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attribute)
    }
    
    func firstTask() {
        pthread_mutex_lock(&mutex)
        secondTask()
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
    
    private func secondTask() {
        pthread_mutex_lock(&mutex)
        print("Second Task")
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
    
    deinit {
        print("Deinitialized")
    }
}

var recursiveMutexTest = RecursiveMutexTest()
recursiveMutexTest.firstTask()

print("### separator ###")

// Swift implementation

let recursiveLock = NSRecursiveLock()

class RecursiveThread: Thread {
    
    override func main() {
        recursiveLock.lock()
        print("Thread acquired lock")
        someMethod()
        print(qos_class_self())
        defer {
            recursiveLock.unlock()
        }
        print("Exit main()")
    }
    
    func someMethod() {
        recursiveLock.lock()
        print("Some Method")
        defer {
            recursiveLock.unlock()
        }
    }
}

let recursiveThread = RecursiveThread()
//recursiveThread.qualityOfService = .userInteractive
recursiveThread.start()
