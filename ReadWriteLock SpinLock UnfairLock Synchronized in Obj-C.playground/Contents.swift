// ReadWriteLock SpinLock UnfairLock Synchronized in Obj-C

import UIKit

// POSIX implementation

class ReadWriteLock {
    private var lock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()
    
    private var globalProperty: Int = 0
    
    init() {
        pthread_rwlock_init(&lock, &attribute)
    }
    
    public var workProperty: Int {
        get {
            pthread_rwlock_wrlock(&lock)
            let temp = globalProperty
            pthread_rwlock_unlock(&lock)
            return temp
        }
        
        set {
            pthread_rwlock_wrlock(&lock)
            globalProperty = newValue
            pthread_rwlock_unlock(&lock)
        }
    }
}

let readWriteLock = ReadWriteLock()
readWriteLock.workProperty = 777
print(readWriteLock.workProperty)

// deprecated in iOS 10.0:
//class SpinLock {
//    private var lock = OS_SPINLOCK_INIT
//
//    func some() {
//        OSSpinLockLock(&lock)
//        // do something
//        OSSpinLockUnlock(&lock)
//
//    }
//}

// after iOS 10.0

class UnfairLock {
    private var lock = os_unfair_lock_s()
    
    var array = [Int]()
    
    func some() {
        os_unfair_lock_lock(&lock)
        array.append(1)
        os_unfair_lock_unlock(&lock)
    }
}

// @synchronized

class SynchronizedObjC {
    private let lock = NSObject()
    
    var array = [Int]()
    
    func someMethod() {
        objc_sync_enter(lock)
        array.append(1)
        objc_sync_exit(lock)
    }
}
