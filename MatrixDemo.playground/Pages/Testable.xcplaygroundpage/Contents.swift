//: [Previous](@previous)

import Foundation
@testable import Matrix

import Accelerate


let vector = Vector(entries: [1, 0, 1])


let mm = try! Matrix(entries: [1, 2, 3, 4, 5, 7], rows: 2, cols: 3)
mm.normed(byLevel: .l1)
let a = try? vector.mapped { $0+1 }
print(a)


let i:Int = 1
var new = mm + Double(1.0)
//print(new)
//
////new.sum(by: 1)
//new.sum(by: 1.0)
//
//print(mm.inversed)
