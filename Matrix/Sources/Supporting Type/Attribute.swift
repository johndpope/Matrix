//
//  Attribute.swift
//  TWMLMatrix
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Limbic. All rights reserved.
//

import Accelerate

//MARK: Attribute Type Redefined
public struct Attribute: RawRepresentable {
    
    public typealias RawValue = la_attribute_t
    internal var value:RawValue
    
    /// Convert from a value of `RawValue`, succeeding unconditionally.
    public init(rawValue: RawValue){
        self.value = rawValue
    }
    
    public var rawValue: RawValue { return value }
    
    
    public static let `default` = Attribute(rawValue: la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    public static let enableLogging = Attribute(rawValue: la_attribute_t(LA_ATTRIBUTE_ENABLE_LOGGING))
}
