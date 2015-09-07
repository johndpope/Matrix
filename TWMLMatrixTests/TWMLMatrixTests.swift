//
//  TWMLMatrixTests.swift
//  TWMLMatrixTests
//
//  Created by Grady Zhuo on 2015/9/8.
//  Copyright © 2015年 Grady Zhuo. All rights reserved.
//

import XCTest
@testable import TWMLMatrix

class TWMLMatrixTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConstructor() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        do{
            let m = try Matrix(entries: [[1,2],[2,3],[4,5]])
            XCTAssertEqual(m.rowsCount, 3)
        }catch{
            XCTFail("error:\(error)")
        }
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
