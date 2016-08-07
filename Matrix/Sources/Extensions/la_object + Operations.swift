//
//  la_object+Operations.swift
//  Matrix
//
//  Created by Grady Zhuo on 11/28/15.
//  Copyright © 2015 Limbic. All rights reserved.
//

import Accelerate

extension la_object_t {
    
    internal var status: Status {
        return Status(rawValue: la_status(self))
    }
    
}

extension la_object_t  {

    internal func makeRepeatedObject(repeating: Double)->la_object_t{
        let doubles = [Double](repeating: repeating, count: Int(colsCount * rowsCount))
        
        return  la_matrix_from_double_buffer(doubles, rowsCount, colsCount, colsCount, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    }
    
    internal func makeRepeatedObject(repeating: Float)->la_object_t{
        let floats = [Float](repeating: repeating, count: Int(colsCount * rowsCount))
        
        return  la_matrix_from_float_buffer(floats, rowsCount, colsCount, colsCount, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
    }
    
    /**
     (readonly) Get count of rows in current object.
     */
    internal var rowsCount:la_count_t {
        return la_matrix_rows(self)
    }
    
    /**
     (readonly) Get count of columns in current object.
     */
    internal var colsCount:la_count_t {
        return la_matrix_cols(self)
    }
    
    //+
    internal func summed(_ right : la_object_t) -> la_object_t{
        let result = la_sum(self, right)
        return result
    }
    
    //+
    internal func summed(_ right : Double) -> la_object_t{
        let result = la_sum(self, makeRepeatedObject(repeating: right))
        return result
    }
    
    //+
    internal func summed(_ right : Float) -> la_object_t{
        let result = la_sum(self, makeRepeatedObject(repeating: right))
        return result
    }
    
    //-
    internal func differenced(_ right : la_object_t) -> la_object_t{
        
        let result = la_difference(self, right)
        return result
        
    }
    
    //-
    internal func differenced(_ right : Double) -> la_object_t{
        let result = la_difference(self, makeRepeatedObject(repeating: right))
        return result
    }
    
    //-
    internal func differenced(_ right : Float) -> la_object_t{
        let result = la_difference(self, makeRepeatedObject(repeating: right))
        return result
    }
    
    //*
    internal func producted(_ scalar : Double) -> la_object_t{
        let result = la_scale_with_double(self, scalar)
        return  result
    }
    
    //*
    internal func producted(_ scalar : Float) -> la_object_t{
        let result = la_scale_with_float(self, scalar)
        return  result
    }

    //*
    internal func producted(_ right : la_object_t) -> la_object_t{
        let result = la_matrix_product(self, right)
        return  result
    }
    
    internal func elementwised(_ right : la_object_t) -> la_object_t{

        let result = la_elementwise_product(self, right)
        return  result
    }
    
    internal func scaled(_ scalar : Double) -> la_object_t{
        return  la_scale_with_double(self, scalar)
    }
    
    internal func scaled(_ scalar : Float) -> la_object_t{
        return  la_scale_with_float(self, scalar)
    }
    
    //解聯立
    internal func solved(_ right : la_object_t) -> la_object_t{
        let result = la_solve(self, right)
        return result
        
    }
    
    
    //逆矩陣
    internal func inversed() -> la_object_t {
        let rowsCount = la_matrix_rows(self)
        let identity = la_identity_matrix(rowsCount, la_scalar_type_t(LA_SCALAR_TYPE_DOUBLE), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        return solved(identity)
    }
    
    
    //轉置
    internal func transposed() -> la_object_t {
        let result = la_transpose(self)
        return result
        
    }
    
    //外積
    internal func outerProducted(_ right : la_object_t) -> la_object_t{
        
        let result = la_outer_product(self, right)
        return result
        
    }
    
    //內積
    internal func innerProducted(_ right : la_object_t) -> la_object_t{
        let result = la_inner_product(self, right)
        return result
    }
    
}
