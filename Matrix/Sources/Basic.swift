//
//  Basic.swift
//  Matrix
//
//  Created by Grady Zhuo on 11/28/15.
//  Copyright © 2015 Limbic. All rights reserved.
//

import Accelerate


/**
 (protocol) Basic, define the common feature both in Vector and Matrix.
 */
public protocol Basic : RawRepresentable, Hashable, CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundQuickLookable, ExpressibleByArrayLiteral {
    associatedtype Count:Strideable
    associatedtype RawValue: la_object_t
    
    var rowsCount:Count { get }
    var colsCount:Count { get }
    
    var hint:Hint { get }
    var attributes:Attribute { get }
    
    init(object: RawValue, hint: Hint, attributes: Attribute)
}

internal protocol _Basic : Basic {
    var rawValue: RawValue { set get }
}


//MARK: -
extension Basic where Count == la_count_t, RawValue == la_object_t {
    
    /**
     Implement the initializer to convert between Matrix and Vector.
     
     - parameter matrixOrVector:  other Basic you want to convert.
     
     - returns: Basic that you want to implement.
     */
    public init!<T:Basic where Count == la_count_t, RawValue == la_object_t>(matrixOrVector object:T){
        
        let mirror = Mirror(reflecting: object)
        
        guard let object = mirror.descendant("object") as? RawValue else {
            return nil
        }
        
        guard let hint = mirror.descendant("hint") as? Hint else {
            return nil
        }
        
        guard let attributes = mirror.descendant("attributes") as? Attribute else {
            return nil
        }
        
        self = Self.init(object: object, hint: hint, attributes: attributes)
        
    }
    
}


extension Basic where Count == la_count_t, RawValue == la_object_t {
    /**
     (readonly) Get count of rows in current object.
     */
    public var rowsCount:Count {
        return rawValue.rowsCount
    }
    
    /**
     (readonly) Get count of columns in current object.
     */
    public var colsCount:Count {
        return rawValue.colsCount
    }
}

//MARK: -
extension _Basic where Count == la_count_t, RawValue == la_object_t  {
    
    
    internal mutating func _sum<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(right basic: U) throws {
        rawValue = try _summed(basic.rawValue)
    }
    
    //-
    internal mutating func _difference<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(right basic: U) throws {
        
        rawValue = try _differenced(basic.rawValue)
        
    }
    
    //*
    internal mutating func _product<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(right basic: U) throws{
        
        rawValue = try _producted(basic.rawValue)
        
    }
    
    
    //逆矩陣
    internal mutating func _inverse() throws {
        rawValue = try _inversed()
    }
    
    
    //轉置
    internal mutating func _transpose(){
        rawValue = _transposed()
    }
    
}

extension Basic where Count == la_count_t, RawValue == la_object_t {
    
    //+
    public func summed<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(right basic: U) throws -> Self{
        
//        guard self.colsCount == object.colsCount && self.rowsCount == object.rowsCount else {
//            throw MatrixError.sizeNotEqual(function: "objectWithSum", position: .left(object: self, size: [.Rows, .Cols]), otherPosition: .right(object: object, size: [.Rows, .Cols]))
//        }
        
        let result = try _summed(basic.rawValue)
        return Self(object: result, hint: self.hint, attributes: self.attributes)
        
    }
    
    //-
    public func differenced<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(right basic: U) throws -> Self{
        
        let result = try _differenced(basic.rawValue)
        return Self(object: result, hint: self.hint, attributes: self.attributes)
        
    }
    
    //*
    public func producted<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(right basic: U) throws -> Self{
        
        let result = try _producted(basic.rawValue)
        return Self(object: result, hint: self.hint, attributes: self.attributes)
        
    }
    
    public func producted<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(elementwise basic: U) throws -> Self{
        
        let result = try _elementwised(basic.rawValue)
        return Self(object: result, hint: self.hint, attributes: self.attributes)
        
    }
    
    public func producted(scalar double: Double) -> Self{
        let result = _producted(double)
        return Self(object: result, hint: self.hint, attributes: self.attributes)
    }
    
    public func producted(scalar float: Float) -> Self{
        let result = _producted(float)
        return Self(object: result, hint: self.hint, attributes: self.attributes)
    }
    
    //解聯立
    public func solved<U:Basic where U.Count == la_count_t, U.RawValue == la_object_t>(rightObject basic: U) throws -> Self{
        let result = try _solved(basic.rawValue)
        return Self(object: result, hint: self.hint, attributes: self.attributes)
    }
    
    //逆矩陣
    public func inversed() throws ->Self {
        
        guard self.rowsCount == self.colsCount else  {
            //不是方陣
            
            //仿逆 P^+ = (P^T X P)^-1 X P^T
            let fake = try! (transposed * self).inversed() * transposed
            return fake
            
        }
        
        let result = try self._inversed()
        return Self(object: result, hint: hint, attributes: attributes)
    }
    
    //轉置
    public var transposed: Self {
        return Self(object: _transposed(), hint: self.hint, attributes: self.attributes)
    }
    
}

extension Basic where Count == la_count_t, RawValue == la_object_t {
    
    //get entries
    public func entries() throws -> ContiguousArray<Double> {
        
        let totalCount = Int(self.rowsCount * self.colsCount)
        
        let p =  UnsafeMutablePointer<Double>.allocate(capacity: totalCount)
        p.initialize(to: 0.0)
        
        let res = la_matrix_to_double_buffer(p, Count(colsCount), rawValue)
        
        let cArray = UnsafeMutableBufferPointer<Double>(start: p, count: totalCount)
        
        let status = Status(rawValue: res)
        
        //If no error occurred, print result
        if status == .success {
            return ContiguousArray<Double>(cArray)
        }else{
            throw LAError.errorWithStatus(status: status)
        }
    }
    
}

//MARK: - Calculate by BLAS
extension Basic where Count == la_count_t, RawValue == la_object_t {
    
    //+
    internal func _summed(_ right : RawValue) throws -> RawValue{

        let result = rawValue.summed(right)
        
        do{
            try Status.check(status: result.status)
        }catch{
            throw LAError.blas(function: "la_sum", status: result.status)
        }
        
        return result
        
    }
    
    //-
    internal func _differenced(_ right : RawValue) throws -> RawValue{
        
        let result = rawValue.differenced(right)
        
        do{
            try Status.check(status: result.status)
        }catch{
            throw LAError.blas(function: "la_difference", status: result.status)
        }
        
        return result
        
    }
    
    //*
    internal func _producted(_ right : RawValue) throws -> RawValue{
        let result = rawValue.producted(right)
        
        do{
            try Status.check(status: result.status)
        }catch{
            throw LAError.blas(function: "la_matrix_product", status: result.status)
        }
        
        return  result
    }
    
    internal func _elementwised(_ right : RawValue) throws -> RawValue{
        let result = rawValue.elementwised(right)
        
        do{
            try Status.check(status: result.status)
        }catch{
            throw LAError.blas(function: "la_elementwise_product", status: result.status)
        }
        
        return  result
    }
    
    internal func _producted(_ scalar : Double) -> RawValue{
        
        let result = rawValue.scaled(scalar)
        return  result
    }
    
    internal func _producted(_ scalar : Float) -> RawValue{
        
        let result = rawValue.scaled(scalar)
        return  result
    }
    
    //解聯立
    internal func _solved(_ right : RawValue) throws -> RawValue{
        let result = rawValue.solved(right)
        
        do{
            try Status.check(status: result.status)
        }catch{
            throw LAError.blas(function: "la_solve", status: result.status)
        }
        
        return result
        
    }
    
    
    //逆矩陣
    internal func _inversed() throws -> RawValue {
        
        let result = rawValue.inversed()
        
        do{
            try Status.check(status: result.status)
        }catch{
            throw LAError.blas(function: "la_identity_object", status: result.status)
        }
        
        return result
    }
    
    
    //轉置
    internal func _transposed() -> RawValue {
        
        let result = rawValue.transposed()
        return result
        
    }
    
}

//MARK: - Protocol Implement
extension Basic where Count == la_count_t, RawValue == la_object_t  {
    
    public func toString(format: Bool = true)->String{
        
        
        let typeName = "\(self.dynamicType)"
        let isVector = self is Vector
        
        if format && !isVector {
            do{
                let entriesStrings:String = try entries().enumerated().reduce("\n"){ (str, item:(offset: Int, element: Double)) -> String in
                    
                    let result = str + " " + String(format: "%.3lf", item.element)
                    
                    if ((item.offset + 1) % Int(colsCount)) == 0 {
                        return result + "\n"
                    }
                    else{
                        return result
                    }
                    
                }
                return typeName + "(\(self.rowsCount)X\(self.colsCount)): \n" + "[\(entriesStrings)]"
                
            }catch{
                return toString(format: false)
            }
            
        }else{
            
            let entriesStrings:String = (try? self.entries().map{ String(format: "%.3lf", $0) }.joined(separator: " ")) ?? "failed"
            return typeName + "(\(self.rowsCount)X\(self.colsCount)) => [\(entriesStrings)]"
            
        }
    }
    
    public var description:String{
        return debugDescription
    }
    
    public var debugDescription: String{
        return toString()
    }
    
    public var customPlaygroundQuickLook: PlaygroundQuickLook{
        return PlaygroundQuickLook.text(toString(format: false))
    }
    
}

extension Basic where Count == la_count_t, RawValue == la_object_t {
    public var hashValue: Int {
        return rawValue.hash
    }
}

extension Basic where Count == la_count_t, RawValue == la_object_t {
    
    public func normed(byLevel level: Norm.Level)->Norm.Value{
        return Norm.Value(matrixOrVector: self, level: level)
    }
    
    public func normalized(level: Norm.Level)->Matrix{
        let object = la_normalized_vector(rawValue, level.rawValue)
        return Matrix(object: object)
    }
    
}


extension Basic where Count == la_count_t, RawValue == la_object_t {
    
    //+
    public func summed(by value: Double) ->Self {
        let object = rawValue.summed(value)
        return Self(object: object, hint: hint, attributes: attributes)
    }
    
    
    //-
    public func differenced(by value: Double)->Self {
        let object = rawValue.differenced(value)
        return Self(object: object, hint: hint, attributes: attributes)
    }
    
    //*
    public func producted(by value: Double)->Self {
        let object = rawValue.producted(value)
        return Self(object: object, hint: hint, attributes: attributes)
    }
    
}

extension Basic where Count == la_count_t, RawValue == la_object_t {
    
    //+
    public func summed(by value: Float) ->Self {
        let object = rawValue.summed(value)
        return Self(object: object, hint: hint, attributes: attributes)
    }
    
    
    //-
    public func differenced(by value: Float)->Self {
        let object = rawValue.differenced(value)
        return Self(object: object, hint: hint, attributes: attributes)
    }
    
    //*
    public func producted(by value: Float)->Self {
        let object = rawValue.producted(value)
        return Self(object: object, hint: hint, attributes: attributes)
    }

}
