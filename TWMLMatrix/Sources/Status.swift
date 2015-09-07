//
//  Status.swift
//  TWMLMatrix
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Grady Zhuo. All rights reserved.
//

import Foundation
import Accelerate

//MARK: Status Type Redefined
public struct Status: RawRepresentable {
    
    public typealias RawValue = la_status_t
    internal var value:RawValue
    
    /// Convert from a value of `RawValue`, succeeding unconditionally.
    public init(rawValue: RawValue){
        self.value = rawValue
    }
    
    public var rawValue: RawValue { return value }
    
    
    public static let Success = Status(rawValue: la_status_t(LA_SUCCESS))
    public static let WarningPoorlyConditioned = Status(rawValue: la_status_t(LA_WARNING_POORLY_CONDITIONED))
    public static let Internal = Status(rawValue: la_status_t(LA_INTERNAL_ERROR))
    public static let InvalidParameterError = Status(rawValue: la_status_t(LA_INVALID_PARAMETER_ERROR))
    public static let DimensionMismatchError = Status(rawValue: la_status_t(LA_DIMENSION_MISMATCH_ERROR))
    public static let PrecisionMismatchError = Status(rawValue: la_status_t(LA_PRECISION_MISMATCH_ERROR))
    public static let SingularError = Status(rawValue: la_status_t(LA_SINGULAR_ERROR))
    public static let SliceOutOfBoundsError = Status(rawValue: la_status_t(LA_SLICE_OUT_OF_BOUNDS_ERROR))
    
}