//
//  ErrorHandling.swift
//  TWMLMatrix
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Grady Zhuo. All rights reserved.
//

import Foundation

//MARK: - Error Defines

//MARK: Error Types In Matrix
public enum MatrixError:ErrorType, Equatable {
    case Undefined
    case SizeNotEqual(function:String, position:MatrixPosition, otherPosition: MatrixPosition)
    case BLAS(function: String)
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
        case .BLAS:
            id = "BLAS"
        case .ConstructWithSize:
            id = "ConstructWithSize"
        }
        return id
    }
    
}


public func ==(lhs: MatrixError, rhs: MatrixError)->Bool{
    return lhs.identifier == rhs.identifier
}

//MARK: Postion Define for Size Error
public enum MatrixPosition {
    case This(matrix:Matrix, size: MatrixSize)
    case Left(matrix:Matrix, size: MatrixSize)
    case Right(matrix:Matrix, size: MatrixSize)
}

//MARK: Define which size failed
public enum MatrixSize : Int {
    case Both
    case Rows
    case Cols
}