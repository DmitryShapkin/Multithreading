// GCD Concurrent queus Serial queues sync-async

import UIKit

class QueueTest {
    private let serialQueue = DispatchQueue(label: "serialQueue")
    private let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
}

class QueueTestSecond {
    private let globalQueue = DispatchQueue.global()
    private let mainQueue = DispatchQueue.main
}
