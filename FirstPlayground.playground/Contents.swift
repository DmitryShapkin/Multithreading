// First playground

import UIKit

// Thread
// Operation
// GCD

// UNIX - POSIX (low level)

var thread = pthread_t(bitPattern: 0) // create the thread
var attribute = pthread_attr_t()

pthread_attr_init(&attribute)
pthread_create(&thread, &attribute, { (pointer) -> UnsafeMutableRawPointer? in
    print("Unix Test")
    return nil
}, nil)

// Thread Two (Swift implementation)

var nsThread = Thread {
    print("Swift Test")
}

nsThread.start()
nsThread.cancel()
