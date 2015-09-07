//
//  Hint.swift
//  TWMLMatrix
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Grady Zhuo. All rights reserved.
//

import Foundation
import Accelerate

//MARK: Hint Type Redefined
public struct Hint:OptionSetType {
    
    public typealias RawValue = la_hint_t
    internal var value:RawValue
    
    public typealias Element = Hint
    /// Convert from a value of `RawValue`, succeeding unconditionally.
    public init(rawValue: RawValue){
        self.value = rawValue
    }
    
    public var rawValue: RawValue { return value }
    
    public static let Default = Hint.NoHint
    public static let NoHint = Hint(rawValue: la_hint_t(LA_NO_HINT))
    public static let ShapeDiagonal = Hint(rawValue: la_hint_t(LA_SHAPE_DIAGONAL))
    public static let LowerTriangular = Hint(rawValue: la_hint_t(LA_SHAPE_LOWER_TRIANGULAR))
    public static var UpperTriangular = Hint(rawValue: la_hint_t(LA_SHAPE_UPPER_TRIANGULAR))
    public static var FeatureSymmetric = Hint(rawValue: la_hint_t(LA_FEATURE_SYMMETRIC))
    public static var FeaturePositiveDefinite = Hint(rawValue: la_hint_t(LA_FEATURE_POSITIVE_DEFINITE))
    public static var FeatureDiagonallyDominant = Hint(rawValue: la_hint_t(LA_FEATURE_DIAGONALLY_DOMINANT))
}