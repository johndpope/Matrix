//
//  Hint.swift
//  TWMLMatrix
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Limbic. All rights reserved.
//

import Accelerate

//MARK: Hint Type Redefined
public struct Hint:OptionSet {
    
    public typealias RawValue = la_hint_t
    internal var value:RawValue
    
    public typealias Element = Hint
    /// Convert from a value of `RawValue`, succeeding unconditionally.
    public init(rawValue: RawValue){
        self.value = rawValue
    }
    
    public var rawValue: RawValue { return value }
    
    public static let `default` = Hint.noHint
    public static let noHint = Hint(rawValue: la_hint_t(LA_NO_HINT))
    public static let shapeDiagonal = Hint(rawValue: la_hint_t(LA_SHAPE_DIAGONAL))
    public static let lowerTriangular = Hint(rawValue: la_hint_t(LA_SHAPE_LOWER_TRIANGULAR))
    public static var upperTriangular = Hint(rawValue: la_hint_t(LA_SHAPE_UPPER_TRIANGULAR))
    public static var featureSymmetric = Hint(rawValue: la_hint_t(LA_FEATURE_SYMMETRIC))
    public static var featurePositiveDefinite = Hint(rawValue: la_hint_t(LA_FEATURE_POSITIVE_DEFINITE))
    public static var featureDiagonallyDominant = Hint(rawValue: la_hint_t(LA_FEATURE_DIAGONALLY_DOMINANT))
}
