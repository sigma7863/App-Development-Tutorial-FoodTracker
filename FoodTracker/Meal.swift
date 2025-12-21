//
//  Meal.swift
//  FoodTracker
//
//  Created by Sigma7863 on 2025/12/19.
//

import UIKit

class Meal {
    // MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int

    // MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        // 名前がない場合、または評価が否定的である場合、初期化は失敗します。(Initialization should fail if there is no name or if the rating is negative.)
        // 初期化が失敗した場合は nil を返す
        // if name.isEmpty || rating < 0 {
        //     return nil
        // }
        
        // 名前は空欄にできません(The name must not be empty)
        guard !name.isEmpty else {
            return nil
        }
        
        // 評価は0から5までの範囲でなければなりません(The rating must be  between 0 and 5  inclusively)
        guard rating >= 0 && rating <= 5 else {
            return nil
        }
        
        // 保存されたプロパティを初期化する(Initialize stored properties)
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
