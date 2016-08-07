//
//  Operators.swift
//  Matrix
//
//  Created by Grady Zhuo on 11/29/15.
//  Copyright © 2015 Limbic. All rights reserved.
//

import Accelerate

infix operator ** {
}

//Outer
infix operator >** {
}

//Inner
infix operator <** {
}

infix operator +! {

}

infix operator +? {

}

infix operator -! {

}

infix operator -? {

}

infix operator *! {

}

infix operator *? {

}


prefix operator -! {

}

prefix operator -? {

}

prefix operator ^ {
    
}


//MARK: - Equatable Protocol Implement

public func ==<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs: T) -> Bool {
    
    guard let lEntries = try? lhs.entries() else{
        return false
    }
    guard let rEntries = try? rhs.entries() else{
        return false
    }
    
    guard lhs.colsCount == rhs.colsCount && lhs.rowsCount == rhs.rowsCount else {
        return false
    }
    return lEntries.elementsEqual(rEntries)
}

//MARK: - Operator Function



public func +<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: T, rhs:U) throws -> T {
    return try lhs.summed(right: rhs)
}

public func +<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: T, rhs:Double) -> T {
    return lhs.summed(by: rhs)
}

public func +<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: Double, rhs:T) -> T {
    return rhs.summed(by: lhs)
}


public func +<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: T, rhs:Float) -> T {
    return lhs.summed(by: rhs)
}

public func +<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: Float, rhs:T) -> T {
    return rhs.summed(by: lhs)
}


public func -<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: T, rhs:U) throws -> T {
    return try lhs.differenced(right: rhs)
}

public func -<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: T, rhs:Double) -> T {
    return lhs.differenced(by: rhs)
}

public func -<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: Double, rhs:T) -> T {
    return rhs.differenced(by: lhs)
}

public func -<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: T, rhs:Float) -> T {
    return lhs.differenced(by: rhs)
}

public func -<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: Float, rhs:T) -> T {
    return rhs.differenced(by: lhs)
}

public prefix func -<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(rhs: T) throws -> T {
    return try rhs.inversed()
}

public prefix func ^<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(rhs: T) -> T {
    return rhs.transposed
}

public func *<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: T, rhs:U) throws -> T {
    return try lhs.producted(right: rhs)
}

public func *<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: T, rhs:Double) -> T {
    return lhs.producted(by: rhs)
}

public func *<T:Basic, U:Basic where T.Count == la_count_t, T.RawValue == la_object_t, U.Count == la_count_t, U.RawValue == la_object_t>(lhs: T, rhs:Float) -> T {
    return lhs.producted(by: rhs)
}

public func **<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:T) throws -> T {
    return try lhs.producted(elementwise: rhs)
}

public func *<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:Int) -> T {
    return lhs.producted(scalar: Double(rhs))
}

public func *<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:Double) -> T {
    return lhs.producted(scalar: rhs)
}

public func *<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:Float) -> T {
    return lhs.producted(scalar: rhs)
}

public func *<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: Int, rhs:T) -> T {
    return rhs.producted(scalar: Double(lhs))
}

public func *<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: Double, rhs:T) -> T {
    return rhs.producted(scalar: lhs)
}

public func *<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: Float, rhs:T) -> T {
    return rhs.producted(scalar: lhs)
}

public func /<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:Int) -> T {
    return lhs.producted(scalar: 1.0/Double(rhs))
}

public func /<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:Double) -> T {
    return lhs.producted(scalar: 1.0/rhs)
}

public func /<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:Float) -> T {
    return lhs.producted(scalar: 1.0/rhs)
}

public func /<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: Int, rhs:T) -> T {
    return rhs.producted(scalar: 1.0/Double(lhs))
}

public func /<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: Double, rhs:T) -> T {
    return rhs.producted(scalar: 1.0/lhs)
}

public func /<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: Float, rhs:T) -> T {
    return rhs.producted(scalar: 1.0/lhs)
}

public func ~>(lhs:Matrix, rhs:Vector) throws -> Matrix {
    return try lhs.solved(rightObject: rhs)
}


//MARK: - Convenience Operator
public func +!<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:T)-> T!{
    return try! lhs.summed(right: rhs)
}

public func +?<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:T)-> T!{
    return try? lhs.summed(right: rhs)
}

public func -?<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:T) -> T? {
    return try? lhs.differenced(right: rhs)
}

public func -!<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:T) -> T! {
    return try! lhs.differenced(right: rhs)
}

public prefix func -!<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(rhs: T) -> T! {
    return try! rhs.inversed()
}

public prefix func -?<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(rhs: T) -> T? {
    return try? rhs.inversed()
}

public func *!<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:T) -> T! {
    return try! lhs.producted(elementwise: rhs)
}

public func *?<T:Basic where T.Count == la_count_t, T.RawValue == la_object_t>(lhs: T, rhs:T) -> T? {
    return try? lhs.producted(elementwise: rhs)
}
