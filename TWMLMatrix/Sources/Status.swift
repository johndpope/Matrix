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
public struct Status: RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible {
    
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
    
    public var description : String {
        
        let represent:String
        
        switch self {
        case Status.Success :
            represent = "Success"
        case Status.WarningPoorlyConditioned:
            represent = "WarningPoorlyConditioned"
        case Status.Internal:
            represent = "Internal"
        case Status.InvalidParameterError:
            represent = "InvalidParameterError"
        case Status.DimensionMismatchError:
            represent = "DimensionMismatchError"
        case Status.PrecisionMismatchError:
            represent = "PrecisionMismatchError"
        case Status.SingularError:
            represent = "SingularError"
        case Status.SliceOutOfBoundsError:
            represent = "SliceOutOfBoundsError"
        default:
            represent = "Undefined"
        }
        
        return represent
        
    }
    
    
    
    public var debugDescription: String {
        return "Status : \(self)"
    }
    
}

func ~=(lhs: Status, rhs: Status)->Bool{
    return lhs.rawValue == rhs.rawValue
}
