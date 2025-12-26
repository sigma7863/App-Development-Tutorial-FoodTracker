//
//  Meal.swift
//  FoodTracker
//
//  Created by Sigma7863 on 2025/12/19.
//

import UIKit
import os.log

class Meal: NSObject, NSSecureCoding {
    // MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    // MARK: Types
    // static キーワードはこのプロパティがこの構造体自身に所属しており、インスタンスではないことを表しています。
    // そのためアクセスする際は構造体名に続けてプロパティ名を書くことになります。
    //（例： PropertyKey.name）
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }

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
    
    // MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
    }
    
    // 保存したデータを読み込む
    required convenience init?(coder: NSCoder) {
        // 名前は必須です。名前文字列をデコードできない場合、初期化は失敗します。(The name is required. If we cannot decode a name string, the initializer should fail.)
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal Object.", log: OSLog.default, type: .debug) // Mealオブジェクトの名前をデコードできません。
            return nil
        }
            
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        
        // 指定された初期化子を呼び出す必要があります。(Must call designated initializer.)
        self.init(name: name, photo: photo, rating: rating)
    }
    
    // MARK: NSSecureCoding
    static var supportsSecureCoding: Bool = true
}
