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
public typealias MatrixError = NSError
extension NSError {
    
    public class func ConstructWithSize()->NSError{
        return NSError(domain: "matrix.error.ConstructWithSize", code: 990, userInfo: nil)
    }
    
    public class func Undefined()->NSError{
        return NSError(domain: "matrix.error.Undefined", code: 999, userInfo: nil)
    }
    
    public class func SizeNotEqual(#function:String, position:MatrixPosition, otherPosition: MatrixPosition)->NSError{
        return NSError(domain: "matrix.error.SizeNotEqual", code: 991, userInfo: ["funcation":function, "postion":position.description, "otherPostition":otherPosition.description])
    }
    public class func BLAS(#function:String)->NSError{
        return NSError(domain: "matrix.error.undefined", code: 992, userInfo: ["funcation":function])
    }
    
    public class func ErrorWithStatus(#status:Status)->NSError{
        return NSError(domain: "matrix.error.undefined", code: 993, userInfo: ["status":status.description])
    }
    
    

}

//MARK: Postion Define for Size Error
public enum MatrixPosition : Printable {
    case This(matrix:Matrix, size: MatrixSize)
    case Left(matrix:Matrix, size: MatrixSize)
    case Right(matrix:Matrix, size: MatrixSize)
    
    public var description:String {
        switch self{
        case let .This(matrix, size):
            return "This \(matrix), \(size)"
        case let .Left(matrix, size):
            return "Left \(matrix), \(size)"
        case let .Right(matrix, size):
            return "Right \(matrix), \(size)"
        }
    }
    
}

//MARK: Define which size failed
public enum MatrixSize : Int, Printable {
    case Both
    case Rows
    case Cols
    
    
    public var description:String {
        switch self{
        case .Both:
            return "Both"
        case .Rows:
            return "Rows"
        case .Cols:
            return "Cols"
        }
    }
}