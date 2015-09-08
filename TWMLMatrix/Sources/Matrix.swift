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
    
    public init?( entries: [Double], rows: CountType, cols: CountType, stride: CountType? = nil, hint: Hint = .Default, attributes:Attribute = .Default, inout error:NSError?) {
        
        if Int(rows) * Int(cols) != entries.count {
            error = NSError.ConstructWithSize()
            return nil
        }
        
        self.object = la_matrix_from_double_buffer(entries, CountType(rows), cols, stride ?? cols, hint.rawValue, attributes.rawValue)
        self.hint = hint
        self.attributes = attributes
    }
    
    
    public init?( entries: [[Double]], hint: Hint = Hint.Default, attribute: Attribute = .Default, inout error:NSError?) {
            
        let flatEntries = entries.flatMap { $0 }
        
        if let cols = entries.first?.count {
            
            for entryArray in entries {
                
                if cols != entryArray.count {
                    error = NSError.ConstructWithSize()
                    return nil
                }

            }
            
            let rows = CountType(entries.count)
            if let m = Matrix(entries: flatEntries, rows: rows, cols: CountType(cols), error: &error){
                self = m
            }else{
                return nil
            }
            
        }else{
            return nil
        }
        
        
        
        
        
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
    public mutating func sum(rightMatrix matrix: Matrix, inout error:NSError?) {
        
        if self.colsCount == matrix.colsCount && self.rowsCount == matrix.rowsCount {
            if let o = self._sum(matrix.object, error: &error) {
                self.object = o
            }
        }else{
            error = NSError.SizeNotEqual(function: "sum", position: .Left(matrix: self, size: .Both), otherPosition: .Right(matrix: matrix, size: .Both))
        }
        
    }
    
    //-
    public mutating func difference(rightMatrix matrix: Matrix, inout error:NSError?) {
        
        if self.colsCount == matrix.colsCount && self.rowsCount == matrix.rowsCount {
            if let o = self._difference(matrix.object, error: &error) {
                self.object = o
            }
            
        }else{
            error = MatrixError.SizeNotEqual(function: "difference", position: .Left(matrix: self, size: .Both), otherPosition: .Right(matrix: matrix, size: .Both))
        }
        
        
        
    }
    
    //*
    public mutating func product(rightMatrix matrix: Matrix, inout error:NSError?){
        
        if self.colsCount == matrix.rowsCount {
            if let o = self._product(matrix.object, error: &error) {
                self.object = o
            }
        }else{
            error = MatrixError.SizeNotEqual(function: "product", position: .Left(matrix: self, size: .Cols), otherPosition: .Right(matrix: matrix, size: .Rows))
        }
        
    }
    

    //逆矩陣
    public mutating func inverse(inout error:NSError?) {
        
        if self.rowsCount == self.colsCount  {
            if let o = self._inverse(&error) {
                self.object = o
            }
        }else{
            //不是方陣
            error = MatrixError.SizeNotEqual(function: "inverse", position: .This(matrix: self, size: .Rows), otherPosition: .This(matrix: self, size: .Rows))
        }
    }
    
    
    //轉置
    public mutating func transpose(){
        self.object = la_transpose(self.object)
    }
    
    
    
    
}


extension Matrix {
    
    //+
    public func matrixWithSum(rightMatrix matrix: Matrix, inout error:NSError?) -> Matrix!{
        
        if self.colsCount == matrix.colsCount && self.rowsCount == matrix.rowsCount {
            if let result = self._sum(matrix.object, error: &error) {
                return Matrix(object: result)
            }
        }else{
            error = MatrixError.SizeNotEqual(function: "matrixWithSum", position: .Left(matrix: self, size: .Both), otherPosition: .Right(matrix: matrix, size: .Both))
        }
        
        return nil
        
    }
    
    //-
    public func matrixWithDifference(rightMatrix matrix: Matrix, inout error:NSError?) -> Matrix!{
        
        if self.colsCount == matrix.colsCount && self.rowsCount == matrix.rowsCount {
            
            if let result = self._difference(matrix.object, error: &error){
                return Matrix(object: result)
            }
            
        }else{
            error = MatrixError.SizeNotEqual(function: "matrixWithDifference",position: .Left(matrix: self, size: .Both), otherPosition: .Right(matrix: matrix, size: .Both))
        }
        
        return nil
        
    }
    
    //*
    public func matrixWithProduct(rightMatrix matrix: Matrix, inout error:NSError?) -> Matrix!{
        
        if self.colsCount != matrix.rowsCount {
            error = MatrixError.SizeNotEqual(function: "matrixWithProduct",position: .Left(matrix: self, size: .Cols), otherPosition: .Right(matrix: matrix, size: .Rows))
        }else{
            if let result = self._product(matrix.object, error: &error){
                return Matrix(object: result)
            }
        }
        
        return nil
    }
    
    //解聯立
    public func matrixWithSolve(rightMatrix matrix: Matrix, inout error:NSError?) -> Matrix!{
        if let result = self._solve(matrix.object, error: &error){
            return Matrix(object: result)
        }
        return nil
    }
    
    //逆矩陣
    public func matrixWithInverse(inout error:NSError?) -> Matrix! {
        
        if self.rowsCount != self.colsCount {
            //不是方陣
            error = MatrixError.SizeNotEqual(function: "matrixWithInverse", position: .This(matrix: self, size: .Rows), otherPosition: .This(matrix: self, size: .Cols))
            return nil
        }
        
        if let result = self._inverse(&error){
            return Matrix(object: result)
        }
        
        return nil
    }
    
    
    //轉置
    public func matrixWithTranspose() -> Matrix {
        let result = self._transpose()
        return Matrix(object: result)
        
    }
    
    
    
    
}

extension Matrix {
    
    //get entries
    public func entries(inout error:NSError?) -> [Double]? {
        
        let totalCount = Int(self.rowsCount * self.colsCount)
        
        var result:[Double] = [Double](count:totalCount, repeatedValue: 0)
        let res = la_matrix_to_double_buffer(&result, CountType(self.colsCount), self.object)
        
        let status = Status(rawValue: res)
        
        //If no error occurred, print result
        if status == Status.Success {
            return result
        }else{
            error = MatrixError.ErrorWithStatus(status: status)
            return nil
        }
    }
    
}

//MARK: - Calculate by BLAS
extension Matrix {
    
    //+
    internal func _sum(right : la_object_t, inout error:NSError?) -> la_object_t!{
        
        let left = self.object
        
        if let result = la_sum(left, right) {
            return result
        }else{
            error = MatrixError.BLAS(function: "la_sum")
        }
        
        return nil
    }
    
    //-
    internal func _difference(right : la_object_t, inout error:NSError?) -> la_object_t!{
        
        let left = self.object
        
        if let result = la_difference(left, right) {
            return result
        }else{
            error = MatrixError.BLAS(function: "la_difference")
        }
        
        return nil
        
    }
    
    //*
    internal func _product(right : la_object_t, inout error:NSError?) -> la_object_t!{
        let left = self.object
        
        if let result = la_matrix_product(left, right){
            return result
        }else{
            error = MatrixError.BLAS(function: "la_matrix_product")
        }
        
        return  nil
        
    }
    
    //解聯立
    internal func _solve(right : la_object_t, inout error:NSError?) -> la_object_t!{
        let left = self.object
        
        if let result = la_solve(left, right){
            return result
        }else{
            error = MatrixError.BLAS(function: "la_solve")
        }
        
        return nil
        
    }
    
    
    //逆矩陣
    internal func _inverse(inout error:NSError?) -> la_object_t! {
        
        if let identity = la_identity_matrix(self.rowsCount, la_scalar_type_t(LA_SCALAR_TYPE_DOUBLE), la_attribute_t(LA_DEFAULT_ATTRIBUTES)) {
            return self._solve(identity, error: &error)
        }else{
            error = MatrixError.BLAS(function: "la_identity_matrix")
        }
        
        return nil
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
extension Matrix : Printable, Equatable {
    
    public var description:String{
        var error:NSError?

        if let elements = (self.entries(&error)?.map({String(stringInterpolationSegment: $0)})) {
            let entriesStrings = join(",", elements)
            return "Martix (rows:\(self.rowsCount),cols:\(self.colsCount))=> [\(entriesStrings)]"
        }else{
            return "Failed"
        }
    }
    
}

//MARK: - Equatable Protocol Implement

public func ==(lhs: Matrix, rhs: Matrix) -> Bool {
    
    var error:NSError?
    if let lEntries = lhs.entries(&error){
        
        if let rEntries = rhs.entries(&error){
            
            if lhs.colsCount == rhs.colsCount && lhs.rowsCount == rhs.rowsCount {
                var result:Bool = true
                for (index, element) in enumerate(lEntries){
                    let relement = rEntries[index]
                    result = result && (element == relement)
                }
                return result
            }
            
        }else{
            println("error: \(error)")
        }
        
    }else{
        println("error: \(error)")
    }
    
    return false
}

//MARK: - Operator Function

public func +(lhs: Matrix, rhs:Matrix) -> Matrix? {
    var error:NSError?
    let m = lhs.matrixWithSum(rightMatrix: rhs, error:&error)
    if error != nil {
        println("error: \(error)")
    }
    return m
}

public func -(lhs: Matrix, rhs:Matrix) -> Matrix? {
    
    var error:NSError?
    let m = lhs.matrixWithDifference(rightMatrix: rhs, error:&error)
    if error != nil {
        println("error: \(error)")
    }
    return m
}

public prefix func -(rhs: Matrix) -> Matrix? {
    
    var error:NSError?
    let m = rhs.matrixWithInverse(&error)
    if error != nil {
        println("error: \(error)")
    }
    return m
}

public func *(lhs: Matrix, rhs:Matrix) -> Matrix? {
    
    var error:NSError?
    let m = lhs.matrixWithProduct(rightMatrix: rhs, error: &error)
    if error != nil {
        println("error: \(error)")
    }
    return m
    
}

public func ~>(lhs:Matrix, rhs:Matrix) -> Matrix? {
    
    var error:NSError?
    let m = lhs.matrixWithSolve(rightMatrix: rhs, error: &error)
    if error != nil {
        println("error: \(error)")
    }
    return m
}

