//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Sigma7863 on 2025/12/17.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: Properties
    // observer には以下の二種類がある
    // イベント    発火タイミング
    // willSet   値が変更される直前に発火
    // didSet    値が変更された直後に発火
    
    @IBInspectable var starSize: CGSize = CGSize(width: 50.0, height: 50.0) {
        didSet { // property observer を設定, property observer: プロパティの値の変化を監視してなんらかの処理が行えるようにする機能
            setupButtons()
        }
    }

    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }

    private var ratingButtons = [UIButton]() // ボタンは複数あるので配列で宣言

    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }

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
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // 選択したボタンの評価を計算する(Calculate the rating of the selected button)
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // 選択した星が現在の評価を表している場合は、評価を 0 にリセットする(If the selected star represents the current rating, reset the rating to 0.)
            rating = 0
        } else {
            // それ以外の場合は選択した星に評価を設定する(Otherwise set the rating to the selected star)
            rating = selectedRating
        }
    }

    // MARK: Private Methods
    // アクセス修飾子    役割
    // private        同じクラス以外からはアクセスできない
    // fileprivate    同じファイル内でしかアクセスできない
    // internal       同じモジュール内でしかアクセスできない
    // public         外のモジュールからアクセスできるがオーバーライドできない
    // open           外のモジュールからアクセスでき、オーバーライドもできる
    
    private func setupButtons() {
        // Clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll() // ratingButtons を空配列にして ratingButtons を初期化
        
        // assets catalog から画像を取得する(Load Button Images)
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)

        for index in 0..<starCount { // ratingButtons のボタンを View から取り除く
            // Create the button
            let button = UIButton()

            // Set the button images
            button.setImage(emptyStar, for: .normal) // 未選択時
            button.setImage(filledStar, for: .selected) // タップ中などのハイライト時
            button.setImage(highlightedStar, for: .highlighted) //  選択時
            button.setImage(highlightedStar, for: [.highlighted, .selected]) // ハイライト時と選択時の両方

            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"

            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)

            // Add the button to the stack
            addArrangedSubview(button)

            // Add the new button to rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }

    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() { // 配列のenumerated()でメソッド添字と要素がタプルで取得できる
            // ボタンのインデックスが評価より小さい場合、そのボタンが選択される(If the index of a button is less than the rating, that button should be selected.)
            button.isSelected = index < rating

            // 現在選択されている星のヒント文字列を設定(Set the hint string for the currently selected star)
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }

            // Calculate the value string
            let valueString: String
            switch rating {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }

            // ヒント文字列と値文字列を割り当てる(Assign the hint string and value string)
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
