//
//  Vector.swift
//  Matrix
//
//  Created by Grady Zhuo on 11/28/15.
//  Copyright © 2015 Limbic. All rights reserved.
//

import Accelerate

public protocol VectorBasic : Basic { /* nothing defined. */ }

extension VectorBasic where Count == la_count_t, RawValue == la_object_t, Element == Double {
    public init(arrayLiteral elements: Element...){
        
        let hint: Hint = .Default
        let attributes: Attribute = .Default
    
        let rows = Count(elements.count)
        let object = la_matrix_from_double_buffer(elements, rows, 1, 1, hint.rawValue, attributes.rawValue)
        
        self = Self(object: object, hint: hint, attributes: attributes)
    }
}

extension VectorBasic where Count == la_count_t, RawValue == la_object_t {
    
    public init(entries: [Double], hint: Hint =
        .Default, attributes: Attribute = .Default){
            
            let rows = Count(entries.count)
            
            let object = la_matrix_from_double_buffer(entries, rows, 1, 1, hint.rawValue, attributes.rawValue)
            
            self = Self(object: object, hint: hint, attributes: attributes)
    }
    
    
    public init(doubleValue value: Double, rows:Count, attributes: Attribute = .Default) {
        let splat = la_splat_from_double(value, attributes.rawValue)
        let object = la_vector_from_splat(splat, rows)
        self = Self(object: object, hint: .Default, attributes: attributes)
    }
    
    public func outerProducted(rightObject vector: Vector) throws -> Self{
        let result = try self._outerProducted(vector.rawValue)
        return Self(object: result, hint: hint, attributes: self.attributes)
    }
    
    internal func _outerProducted(rawValue : RawValue) throws -> RawValue{
        
        let result = rawValue.outerProducted(rawValue)
        
        do{
            try Status.check(status: result.status)
        }catch{
            throw LAError.Blas(function: "la_outer_product", status: result.status)
        }
        
        return result
    }
    
    
    internal func _innerProducted(rawValue : RawValue) throws -> RawValue{
        
        let result = rawValue.innerProducted(rawValue)
        
        do{
            try Status.check(status: result.status)
        }catch{
            throw LAError.Blas(function: "la_inner_product", status: result.status)
        }
    
        return result
    }
    
    //MARK: - Inner
    public func innerProducted(rightObject vector: Vector) throws -> Self{
        let result = try _innerProducted(vector.rawValue)
        return Self(object: result, hint: self.hint, attributes: self.attributes)
    }
    
    public subscript(index: Int) ->  Double? {
        return try? self.entries()[index]
    }

}


public struct Vector : _Basic, VectorBasic {
    public typealias Element = Double
    public typealias RawValue = la_object_t
    public typealias Count = la_count_t
    
    public internal(set) var hint:Hint
    public internal(set) var attributes:Attribute
    
    /**
     la_object_t instance to calculate in Linear Algebra through BLAS library.
     */
    public internal(set) var rawValue: RawValue
    
    public init?(rawValue: RawValue) {
        self = Vector(object: rawValue)
    }
    
    public init(object: la_object_t, hint: Hint = .Default, attributes: Attribute = .Default){
        self.rawValue = object
        self.hint = hint
        self.attributes = attributes
    }
    
}

extension Vector {
    
    public mutating func sum<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(right rawValue: U) throws {
        
        try _sum(right: rawValue)
        
    }
    
    //-
    public mutating func difference<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(right rawValue: U) throws {
        
        try _difference(right: rawValue)
    }
    
    //*
    internal mutating func product<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(right rawValue: U) throws{
        try _product(right: rawValue)
    }
    
    
    //逆矩陣
    internal mutating func inverse() throws {
        try _inverse()
    }
    
    
    //轉置
    internal mutating func transpose(){
        _transpose()
    }
}

public func >**(lhs: Vector, rhs:Vector) throws -> Vector {
    return try lhs.outerProducted(rightObject: rhs)
}

public func <**(lhs: Vector, rhs:Vector) throws -> Vector {
    return try lhs.innerProducted(rightObject: rhs)
}

//MARK: - Mapping supported

extension Vector {
    
    public func mapped(closure:(Double)->Double) throws ->Vector{
        let mapped:[Double] = try entries().map { closure($0) }
        return Vector(entries: mapped)
    }
    
    public mutating func map(closure:(Double)->Double) throws {
        let vector  = try self.mapped(closure)
        rawValue = vector.rawValue
    }
    
    subscript(functor: (Double)->Double) -> Vector? {
        return try? mapped(functor)
    }
    
}


