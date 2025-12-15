//
//  ViewController.swift
//  FoodTracker
//
//  Created by Sigma7863 on 2025/12/12.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
    }


    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.(Image View をタップする前に Text Field をタップしていて編集中だった場合にキーボードが 出ているので、そのための対策)
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // フォトライブラリからの読み込みを指定(Only allow photos to be picked, not taken)
        // シミュレーターで実行するため、カメラが使えないので photoLibrary を指定している
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLabel.text = "Default Text"
    } // Swift は関数呼び出しの際は基本的に引数名を書かないといけないが、アンダースコアをつけることで省略できる
}

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        // ラベル(Meal Name)のテキストをテキストフィールドに入力されたテキストに変換
        mealNameLabel.text = textField.text
    }
}

// MARK: UIImagePickerControllerDelegate+UINavigationControllerDelegate
// ユーザが Image View をタップしたら、フォトライブラリから画像を選択できるようにする
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
