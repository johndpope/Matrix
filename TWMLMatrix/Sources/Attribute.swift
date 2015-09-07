//
//  Attribute.swift
//  TWMLMatrix
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Grady Zhuo. All rights reserved.
//

import Foundation
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
    
    
    public static let Default = Attribute(rawValue: la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    public static let EnableLogging = Attribute(rawValue: la_attribute_t(LA_ATTRIBUTE_ENABLE_LOGGING))
}
