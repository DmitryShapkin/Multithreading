// NSCondition NSLocking pthread_cond_t

import UIKit

// POSIX

var available = false // predicate
var condition = pthread_cond_t()
var mutex = pthread_mutex_t()

class ConditionMutexPrinter: Thread {
    
    override init() {
        print("init")
        
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
        print(qos_class_self())
    }
    
    override func main() {
        printerMethod()
    }
    
    private func printerMethod() {
        pthread_mutex_lock(&mutex)
        
        while (!available) {
            pthread_cond_wait(&condition, &mutex)
        }
        print("printerMethod")
        print(Thread.current)
        
        available = false
        
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
}

class ConditionMutexWriter: Thread {
    
    override init() {
        print("init")
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
        print(qos_class_self())
    }
    
    override func main() {
        writerMethod()
    }
    
    private func writerMethod() {
        pthread_mutex_lock(&mutex)
        pthread_cond_signal(&condition)
        
        print("writerMethod")
        print(qos_class_self())
        print(Thread.current)
        
        available = true
        
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
}

let conditionMutexWriter = ConditionMutexWriter()
conditionMutexWriter.start()

let conditionMutexPrinter = ConditionMutexPrinter()
conditionMutexPrinter.start()

print(Thread.current)

print("######## SEPARATOR ########")

// Swift implementation

let conditionSwift = NSCondition()
var availableSwift = false

class Printer: Thread {
    
    override func main() {
        conditionSwift.lock()
        
        while (!availableSwift) {
            conditionSwift.wait()
        }
        
        print("Printer")
        availableSwift = false
        
        defer {
            conditionSwift.unlock()
        }
    }
}

class Writer: Thread {
    
    override func main() {
        
        conditionSwift.lock()
        print("Writer enter")
        availableSwift = true
        conditionSwift.signal()
        defer {
            conditionSwift.unlock()
        }
        print("Writer exit")
    }
}

let printer = Printer()
printer.start()

let writer = Writer()
writer.start()
