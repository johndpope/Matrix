//
//  ErrorHandling.swift
//  TWMLMatrix
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Limbic. All rights reserved.
//

import Foundation

//MARK: - Error Defines

//MARK: Error Types In Matrix
public enum LAError:Error, Equatable {
    case undefined
    case sizeNotEqual(function:String, position:MatrixPosition<Matrix>, otherPosition: MatrixPosition<Matrix>)
    case blas(function: String, status: Status)
    case errorWithStatus(status: Status)
    case constructWithSize
    
    var identifier:String{
        let id:String
        switch self{
        case .errorWithStatus:
            id = "ErrorWithStatus"
        case .undefined:
            id = "Undefined"
        case .sizeNotEqual:
            id = "SizeNotEqual"
        case .blas:
            id = "BLAS"
        case .constructWithSize:
            id = "ConstructWithSize"
        }
        return id
    }
    
}

public func ==(lhs: LAError, rhs: LAError)->Bool{
    return lhs.identifier == rhs.identifier
}



//MARK: Postion Define for Size Error
public enum MatrixPosition<T: Basic> {
    case this(object:T, size: MatrixSize)
    case left(object:T, size: MatrixSize)
    case right(object:T, size: MatrixSize)
}

//MARK: Define which size failed

public struct MatrixSize:OptionSet {
    
    public typealias RawValue = Int
    internal var value:RawValue
    
    public typealias Element = MatrixSize
    /// Convert from a value of `RawValue`, succeeding unconditionally.
    public init(rawValue: RawValue){
        self.value = rawValue
    }
    
    public var rawValue: RawValue { return value }
    
    public static let Rows = MatrixSize(rawValue: 0)
    public static let Cols = MatrixSize(rawValue: 1)
}
