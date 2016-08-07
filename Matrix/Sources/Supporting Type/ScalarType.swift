//
//  ScalarType.swift
//  TWMLMatrix
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Limbic. All rights reserved.
//

import Accelerate

//MARK: Scalar Type Redefined
public struct ScalarType: RawRepresentable {
    
    public typealias RawValue = la_scalar_type_t
    internal var value:RawValue
    
    /// Convert from a value of `RawValue`, succeeding unconditionally.
    public init(rawValue: RawValue){
        self.value = rawValue
    }
    
    public var rawValue: RawValue { return value }
    
    public static let Default = ScalarType.Double
    public static let Float = ScalarType(rawValue: la_scalar_type_t(LA_SCALAR_TYPE_FLOAT))
    public static let Double = ScalarType(rawValue: la_scalar_type_t(LA_SCALAR_TYPE_DOUBLE))
    
}
