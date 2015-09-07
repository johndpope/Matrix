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
public enum MatrixError:ErrorType {
    case Undefined
    case SizeNotEqual(function:String, position:MatrixPosition, otherPosition: MatrixPosition)
    case BLAS(function: String)
    case ErrorWithStatus(status: Status)
    case ConstructWithSize
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