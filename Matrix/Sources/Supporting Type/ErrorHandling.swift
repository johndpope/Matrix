//
//  ErrorHandling.swift
//  TWMLMatrix
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Limbic. All rights reserved.
//

import Accelerate

//MARK: - Error Defines

//MARK: Error Types In Matrix
public enum LAError:ErrorType, Equatable {
    case Undefined
    case SizeNotEqual(function:String, position:MatrixPosition<Matrix>, otherPosition: MatrixPosition<Matrix>)
    case Blas(function: String, status: Status)
    case ErrorWithStatus(status: Status)
    case ConstructWithSize
    
    var identifier:String{
        let id:String
        switch self{
        case .ErrorWithStatus:
            id = "ErrorWithStatus"
        case .Undefined:
            id = "Undefined"
        case .SizeNotEqual:
            id = "SizeNotEqual"
        case .Blas:
            id = "BLAS"
        case .ConstructWithSize:
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

public struct MatrixSize:OptionSetType {
    
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
