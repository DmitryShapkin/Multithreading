// Synchronization and Mutex

import UIKit

class SafeThread {
    private var mutex = pthread_mutex_t()
    
    init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    func someMethod(completion: () -> ()) {
        pthread_mutex_lock(&mutex)
        completion()
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
}

var array = [String]()
let safeThread = SafeThread()
safeThread.someMethod {
    print("Test")
    array.append("First String")
}

array.append("Second String")

// Swift implementation
class SafeThreadSwift {
    private let lockMutex = NSLock()
    
    func someMethod(completion: () -> ()) {
        lockMutex.lock()
        completion()
        defer {
            lockMutex.unlock()
        }
    }
}
