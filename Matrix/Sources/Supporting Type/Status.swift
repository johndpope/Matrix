//
//  Status.swift
//  TWMLMatrix
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Limbic. All rights reserved.
//

import Accelerate

//MARK: Status Type Redefined
public struct Status: RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible {
    
    public typealias RawValue = la_status_t
    internal var value:RawValue
    
    
    internal static func check(status: Status) throws{
        
        guard status >= 0 else {
            throw LAError.errorWithStatus(status: status)
        }
        
        if status > 0 {
            print("[Warn] status description:\(status)")
        }
        
    }
    
    /// Convert from a value of `RawValue`, succeeding unconditionally.
    public init(rawValue: RawValue){
        self.value = rawValue
    }
    
    public var rawValue: RawValue { return value }
    
    
    public static let success = Status(rawValue: la_status_t(LA_SUCCESS))
    public static let warningPoorlyConditioned = Status(rawValue: la_status_t(LA_WARNING_POORLY_CONDITIONED))
    public static let `internal` = Status(rawValue: la_status_t(LA_INTERNAL_ERROR))
    public static let invalidParameterError = Status(rawValue: la_status_t(LA_INVALID_PARAMETER_ERROR))
    public static let dimensionMismatchError = Status(rawValue: la_status_t(LA_DIMENSION_MISMATCH_ERROR))
    public static let precisionMismatchError = Status(rawValue: la_status_t(LA_PRECISION_MISMATCH_ERROR))
    public static let singularError = Status(rawValue: la_status_t(LA_SINGULAR_ERROR))
    public static let sliceOutOfBoundsError = Status(rawValue: la_status_t(LA_SLICE_OUT_OF_BOUNDS_ERROR))
    
    public var description : String {
        
        let represent:String
        
        switch self {
        case Status.success :
            represent = "Success"
        case Status.warningPoorlyConditioned:
            represent = "WarningPoorlyConditioned"
        case Status.internal:
            represent = "Internal"
        case Status.invalidParameterError:
            represent = "InvalidParameterError"
        case Status.dimensionMismatchError:
            represent = "DimensionMismatchError"
        case Status.precisionMismatchError:
            represent = "PrecisionMismatchError"
        case Status.singularError:
            represent = "SingularError"
        case Status.sliceOutOfBoundsError:
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

public func >(lhs: Status, rhs: Status.RawValue)->Bool{
    return lhs.rawValue > rhs
}

public func >=(lhs: Status, rhs: Status.RawValue)->Bool{
    return lhs.rawValue >= rhs
}

public func <(lhs: Status, rhs: Status.RawValue)->Bool{
    return lhs.rawValue < rhs
}

public func <=(lhs: Status, rhs: Status.RawValue)->Bool{
    return lhs.rawValue <= rhs
}

public func !=(lhs: Status, rhs: Status.RawValue)->Bool{
    return lhs.rawValue != rhs
}
