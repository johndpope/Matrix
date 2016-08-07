//
//  Norm.swift
//  Matrix
//
//  Created by Grady Zhuo on 11/28/15.
//  Copyright © 2015 Limbic. All rights reserved.
//

import Accelerate

public struct Norm {
    
    public struct Level : CustomStringConvertible, CustomDebugStringConvertible {
        
        public internal(set) var rawValue: la_norm_t
        
        internal init(rawValue p: la_norm_t){
            
            rawValue = p
        }
        
        public static let l1   = Level(rawValue: la_norm_t(LA_L1_NORM))
        public static let l2   = Level(rawValue: la_norm_t(LA_L2_NORM))
        public static let linf = Level(rawValue: la_norm_t(LA_LINF_NORM))
        
        public var description: String{
            return debugDescription
        }
        
        public var debugDescription: String{
            return "Norm.Level: {\(rawValue)}"
        }
    }
    
    
    public struct Value : CustomDebugStringConvertible, CustomStringConvertible {
        
        public internal(set) var double: Double
        public internal(set) var float:Float
        public internal(set) var level: Level
        
        internal init<T:Basic>(matrixOrVector basic: T, level: Level){
            double = la_norm_as_double(basic.rawValue, level.rawValue)
            float = la_norm_as_float(basic.rawValue, level.rawValue)
            self.level = level
        }
        
        public var description: String{
            return debugDescription
        }
        
        public var debugDescription: String{
            return "Norm.Value: {\(double)}"
        }
        
    }

}

