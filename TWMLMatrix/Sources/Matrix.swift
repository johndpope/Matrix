import Foundation
import Accelerate


//MARK: - Matrix
/**
    Construct a Matrix instance for Linear Algebra.
*/
public struct Matrix {
    
    public let hint:Hint
    public let attributes:Attribute
    
    /**
        Get count of rows in current matrix.
    */
    public var rowsCount:CountType {
        return la_matrix_rows(self.object)
    }
    
    /**
        Get count of columns in current matrix.
    */
    public var colsCount:CountType {
        return la_matrix_cols(self.object)
    }
    
    /**
        la_object_t instance to calculate in Linear Algebra through BLAS library.
    */
    internal var object: la_object_t
    
    
    
    public init(object: la_object_t){
        self.object = object
        self.hint = .NoHint
        self.attributes = .Default
    }
    
    public init( entries: [Double], rows: CountType, cols: CountType, stride: CountType? = nil, hint: Hint = .Default, attributes:Attribute = .Default) throws {
        
        if Int(rows) * Int(cols) != entries.count {
            throw MatrixError.ConstructWithSize
        }
        
        self.object = la_matrix_from_double_buffer(entries, CountType(rows), cols, stride ?? cols, hint.rawValue, attributes.rawValue)
        self.hint = hint
        self.attributes = attributes
    }
    
    
    public init( entries: [[Double]], hint: Hint = Hint.Default, attribute: Attribute = .Default) throws {
            
        let flatEntries = entries.flatMap { $0 }
        
        guard let cols = entries.first?.count else {
            throw MatrixError.ErrorWithStatus(status: .PrecisionMismatchError)
        }
        
        for entryArray in entries {
            guard cols == entryArray.count else {
                throw MatrixError.ErrorWithStatus(status: .PrecisionMismatchError)
            }
        }
        
        let rows = CountType(entries.count)
        self = try Matrix(entries: flatEntries, rows: rows, cols: CountType(cols))
        
    }
    
    
}


extension Matrix {
    
    public init(vectorWithEntries entries: [Double], transpose: Bool = false, hint: Hint =
        .Default, attributes: Attribute = .Default){
            
            let rows:CountType
            let cols:CountType
            
            if transpose {
                rows = CountType(entries.count)
                cols = 1
            }else{
                rows = 1
                cols = CountType(entries.count)
            }
            
            self.object = la_matrix_from_double_buffer(entries, rows, cols, cols, hint.rawValue, attributes.rawValue)
            
            self.hint = hint
            self.attributes = attributes
    }
    
    
    public init(identifyWithSize size:CountType, scalarType: ScalarType =
        .Default, attributes: Attribute = .Default){
            
            self.object = la_identity_matrix(size, scalarType.rawValue, attributes.rawValue)
            self.attributes = attributes
            self.hint = .NoHint
    }
    
}

extension Matrix {
    
    //+
    public mutating func sum(rightMatrix matrix: Matrix) throws {
        
        guard self.colsCount == matrix.colsCount && self.rowsCount == matrix.rowsCount else {
            throw MatrixError.SizeNotEqual(function: "sum", position: .Left(matrix: self, size: .Both), otherPosition: .Right(matrix: matrix, size: .Both))
        }
        
        self.object = try self._sum(matrix.object)
        
    }
    
    //-
    public mutating func difference(rightMatrix matrix: Matrix) throws {
        
        guard self.colsCount == matrix.colsCount && self.rowsCount == matrix.rowsCount else {
            throw MatrixError.SizeNotEqual(function: "difference", position: .Left(matrix: self, size: .Both), otherPosition: .Right(matrix: matrix, size: .Both))
        }
        
        self.object = try self._difference(matrix.object)
        
    }
    
    //*
    public mutating func product(rightMatrix matrix: Matrix) throws{
        
        guard self.colsCount == matrix.rowsCount else {
            throw MatrixError.SizeNotEqual(function: "product", position: .Left(matrix: self, size: .Cols), otherPosition: .Right(matrix: matrix, size: .Rows))
        }
        
        self.object = try self._product(matrix.object)
        
    }
    

    //逆矩陣
    public mutating func inverse() throws {
        
        guard self.rowsCount == self.colsCount else  {
            //不是方陣
            throw MatrixError.SizeNotEqual(function: "inverse", position: .This(matrix: self, size: .Rows), otherPosition: .This(matrix: self, size: .Rows))
        }
        
        self.object = try self._inverse()
        
    }
    
    
    //轉置
    public mutating func transpose(){
        self.object = la_transpose(self.object)
    }
    
    
    
    
}


extension Matrix {
    
    //+
    public func matrixWithSum(rightMatrix matrix: Matrix) throws -> Matrix{
        
        guard self.colsCount == matrix.colsCount && self.rowsCount == matrix.rowsCount else {
            throw MatrixError.SizeNotEqual(function: "matrixWithSum", position: .Left(matrix: self, size: .Both), otherPosition: .Right(matrix: matrix, size: .Both))
        }
        
        let result = try self._sum(matrix.object)
        return Matrix(object: result)
        
    }
    
    //-
    public func matrixWithDifference(rightMatrix matrix: Matrix) throws -> Matrix{
        
        guard self.colsCount == matrix.colsCount && self.rowsCount == matrix.rowsCount else {
            throw MatrixError.SizeNotEqual(function: "matrixWithDifference",position: .Left(matrix: self, size: .Both), otherPosition: .Right(matrix: matrix, size: .Both))
        }
        
        let result = try self._difference(matrix.object)
        return Matrix(object: result)
        
    }
    
    //*
    public func matrixWithProduct(rightMatrix matrix: Matrix) throws -> Matrix{
        
        guard self.colsCount == matrix.rowsCount else {
            throw MatrixError.SizeNotEqual(function: "matrixWithProduct",position: .Left(matrix: self, size: .Cols), otherPosition: .Right(matrix: matrix, size: .Rows))
        }
        
        let result = try self._product(matrix.object)
        return Matrix(object: result)
        
    }
    
    //解聯立
    public func matrixWithSolve(rightMatrix matrix: Matrix) throws -> Matrix{
        let result = try self._solve(matrix.object)
        return Matrix(object: result)
    }
    
    //逆矩陣
    public func matrixWithInverse() throws -> Matrix {
        
        guard self.rowsCount == self.colsCount else  {
            //不是方陣
            throw MatrixError.SizeNotEqual(function: "matrixWithInverse", position: .This(matrix: self, size: .Rows), otherPosition: .This(matrix: self, size: .Cols))
        }
        
        let result = try self._inverse()
        return Matrix(object: result)
    }
    
    
    //轉置
    public func matrixWithTranspose() -> Matrix {
        let result = self._transpose()
        return Matrix(object: result)
        
    }
    
    
    
    
}

extension Matrix {
    
    //get entries
    public func entries() throws -> [Double] {
        
        let totalCount = Int(self.rowsCount * self.colsCount)
        
        var result:[Double] = [Double](count:totalCount, repeatedValue: 0)
        let res = la_matrix_to_double_buffer(&result, CountType(self.colsCount), self.object)
        
        let status = Status(rawValue: res)
        
        //If no error occurred, print result
        if status == .Success {
            return result
        }else{
            throw MatrixError.ErrorWithStatus(status: status)
        }
    }
    
}

//MARK: - Calculate by BLAS
extension Matrix {
    
    //+
    internal func _sum(right : la_object_t) throws -> la_object_t{
        
        let left = self.object
        
        guard let result = la_sum(left, right) else {
            throw MatrixError.BLAS(function: "la_sum")
        }
        
        return result
        
    }
    
    //-
    internal func _difference(right : la_object_t) throws -> la_object_t{
        
        let left = self.object
        
        guard let result = la_difference(left, right) else {
            throw MatrixError.BLAS(function: "la_difference")
        }
        
        return result
        
    }
    
    //*
    internal func _product(right : la_object_t) throws -> la_object_t{
        let left = self.object
        
        guard let result = la_matrix_product(left, right) else{
            throw MatrixError.BLAS(function: "la_matrix_product")
        }
        
        return  result
        
    }
    
    //解聯立
    internal func _solve(right : la_object_t) throws -> la_object_t{
        let left = self.object
        
        guard let result = la_solve(left, right) else{
            throw MatrixError.BLAS(function: "la_solve")
        }
        
        return result
        
    }
    
    
    //逆矩陣
    internal func _inverse() throws -> la_object_t {
        
        guard let identity = la_identity_matrix(self.rowsCount, la_scalar_type_t(LA_SCALAR_TYPE_DOUBLE), la_attribute_t(LA_DEFAULT_ATTRIBUTES)) else {
            throw MatrixError.BLAS(function: "la_identity_matrix")
        }
        
        return try self._solve(identity)
    }
    
    
    //轉置
    internal func _transpose() -> la_object_t {
        let result = la_transpose(self.object)
        return result
        
    }

}

//MARK: - Typealiases
extension Matrix {
    public typealias CountType = la_count_t
}

//MARK: - Protocol Implement 
extension Matrix : CustomStringConvertible, Equatable {
    
    public var description:String{
        
        let entriesStrings:String = (try? self.entries().map{ String($0) }.joinWithSeparator(",")) ?? "failed"
        return "Martix (rows:\(self.rowsCount),cols:\(self.colsCount))=> [\(entriesStrings)]"
    }
    
}

//MARK: - Equatable Protocol Implement

public func ==(lhs: Matrix, rhs: Matrix) -> Bool {
    
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

public func +(lhs: Matrix, rhs:Matrix) throws -> Matrix {
    return try lhs.matrixWithSum(rightMatrix: rhs)
}

public func -(lhs: Matrix, rhs:Matrix) throws -> Matrix {
    return try lhs.matrixWithDifference(rightMatrix: rhs)
}

public prefix func -(rhs: Matrix) throws -> Matrix {
    return try rhs.matrixWithInverse()
}

public func *(lhs: Matrix, rhs:Matrix) throws -> Matrix {
    return try lhs.matrixWithProduct(rightMatrix: rhs)
}

public func ~>(lhs:Matrix, rhs:Matrix) throws -> Matrix {
    return try lhs.matrixWithSolve(rightMatrix: rhs)
}

