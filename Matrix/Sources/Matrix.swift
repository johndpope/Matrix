//
//  Basic.swift
//  Matrix
//
//  Created by Grady Zhuo on 11/28/15.
//  Copyright © 2015 Limbic. All rights reserved.
//

import Accelerate

public protocol MatrixBasic : Basic { /* nothing defined. */ }

extension MatrixBasic where Count == la_count_t, RawValue == la_object_t, Element == [Double] {
    public init(arrayLiteral elements: Element...) {
        self = (try? Self(entries: elements)) ?? Self(repeat: 0, rows: 0, cols: 0)
    }
}

extension MatrixBasic where Count == la_count_t, RawValue == la_object_t {
    
    public init( entries: [Double], rows: Count, cols: Count, stride: Count? = nil, hint: Hint = .Default, attributes:Attribute = .Default) throws {
        
        if Int(rows) * Int(cols) != entries.count {
            throw LAError.ConstructWithSize
        }
        
        let object = la_matrix_from_double_buffer(entries, Count(rows), cols, stride ?? cols, hint.rawValue, attributes.rawValue)
        
        self = Self(object: object, hint: hint, attributes: attributes)
    }
    
    public init( entries: [[Double]], hint: Hint = .Default, attribute: Attribute = .Default) throws {
        
        let flatEntries = entries.flatMap { $0 }
        
        guard let cols = entries.first?.count else {
            throw LAError.ErrorWithStatus(status: .PrecisionMismatchError)
        }
        
        for entryArray in entries {
            guard cols == entryArray.count else {
                throw LAError.ErrorWithStatus(status: .PrecisionMismatchError)
            }
        }
        
        let rows = Count(entries.count)
        self = try Self(entries: flatEntries, rows: rows, cols: Count(cols))
        
    }
    
    public init(identifyWithSize size:Count, scalarType: ScalarType =
        .Default, attributes: Attribute = .Default){
            
            let object = la_identity_matrix(size, scalarType.rawValue, attributes.rawValue)
            self = Self(object: object, hint: .Default, attributes: attributes)
    }
    
    public init(repeat value: Double, rows:Count, cols:Count, attributes: Attribute = .Default) {
        let splat = la_splat_from_double(value, attributes.rawValue)
        let object = la_matrix_from_splat(splat, rows, cols)
        self = Self(object: object, hint: .Default, attributes: attributes)
    }
    
}



//MARK: - Matrix
/**
    Construct a Matrix instance for Linear Algebra.
*/
public struct Matrix : _Basic, MatrixBasic {
    public typealias Element = [Double]
    
    public typealias RawValue = la_object_t
    public typealias Count = la_count_t
    
    public internal(set) var hint:Hint
    public internal(set) var attributes:Attribute
    
    /**
        la_object_t instance to calculate in Linear Algebra through BLAS library.
    */
    public internal(set) var rawValue: RawValue
    
    public init?(rawValue: RawValue) {
        self = Matrix(object: rawValue)
    }
    
    public init(object rawValue: la_object_t, hint: Hint = .Default, attributes: Attribute = .Default){
        self.rawValue = rawValue
        self.hint = hint
        self.attributes = attributes
    }
    
}

extension Matrix {
    
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

public func *(lhs: Matrix, rhs: [Double]) throws ->Matrix{
    return try lhs * Vector(entries: rhs)
}

public func *(lhs: Matrix, rhs: [[Double]]) throws ->Matrix{
    return try lhs * Matrix(entries: rhs)
}


//MARK: - Mapping supported

extension Matrix {
    
    public func mapped(closure:(Double)->Double) throws ->Matrix{
        let mapped:[Double] = try entries().map { closure($0) }
        return try Matrix(entries: mapped, rows: rowsCount, cols: colsCount)
    }
    
    public mutating func map(closure:(Double)->Double) throws {
        let matrix  = try self.mapped(closure)
        rawValue = matrix.rawValue
    }
    
    subscript(factor: (Double)->Double) -> Matrix? {
        return try? mapped(factor)
    }
    
}

