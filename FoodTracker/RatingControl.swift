//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Sigma7863 on 2025/12/17.
//

import UIKit

class RatingControl: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: Properties
    private var ratingButtons = [UIButton]() // ボタンは複数あるので配列で宣言

    var rating = 0
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button Action
        @objc func ratingButtonTapped(button: UIButton) {
            print("Button pressed 👍")
        }
    
    // MARK: Private Methods
    // アクセス修飾子    役割
    // private        同じクラス以外からはアクセスできない
    // fileprivate    同じファイル内でしかアクセスできない
    // internal       同じモジュール内でしかアクセスできない
    // public         外のモジュールからアクセスできるがオーバーライドできない
    // open           外のモジュールからアクセスでき、オーバーライドもできる
    
    private func setupButtons() {
        for _ in 0..<5 {
            // Create the button
            let button = UIButton()
            button.backgroundColor = UIColor.red
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to rating button array
            ratingButtons.append(button)
        }
    }
}
