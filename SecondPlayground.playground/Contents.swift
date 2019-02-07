// Second Playground

import UIKit

var lessonTwo = "Quality of Services"

// C implementation

var pthread = pthread_t(bitPattern: 0)
var attribute = pthread_attr_t()
pthread_attr_init(&attribute)
pthread_attr_set_qos_class_np(&attribute, QOS_CLASS_USER_INITIATED, 0)
pthread_create(&pthread, &attribute, { (pointer) -> UnsafeMutableRawPointer? in
    print("Test")
    pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0)
    return nil
}, nil)

// Swift implemetation

print(qos_class_self())

let nsThread = Thread {
    print("Swift Thread")
    print(qos_class_self())
    print(qos_class_main())
    print(qos_class_self())
}

nsThread.qualityOfService = .userInteractive
nsThread.start()
