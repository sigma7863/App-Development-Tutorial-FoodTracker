//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Sigma7863 on 2025/12/12.
//

import Testing
@testable import FoodTracker

struct FoodTrackerTests {
    
    // @Test func example() async throws {
    //     Write your test here and use APIs like `#expect(...)` to check expected conditions.
    // }

    // MARK: Meal Class Tests
    // 有効なパラメータが渡されたときに、Meal 初期化子が Meal オブジェクトを返すことを確認します。(Confirm that the Meal initializer return a Meal object when passed valid parameters.)
    @Test func testMealInitializationSucceeds() {
        // Zero rating
        let zeroRatingMeal = Meal(name: "Zero", photo: nil, rating: 0)
        #expect(zeroRatingMeal != nil)
        
        // Highest positive rating
        let positiveRatingMeal = Meal(name: "Positive", photo: nil, rating: 5)
        #expect(positiveRatingMeal != nil)
    }
    
    @Test 
}
