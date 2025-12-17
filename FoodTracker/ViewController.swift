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
    // ユーザが画像の選択をキャンセルした場合に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // ユーザーがキャンセルした場合はピッカーを閉じる。(Dismiss the picker if the user canceled.)
        dismiss(animated: true, completion: nil)
    }
    
    // ユーザが画像を選択し終わった後に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 情報辞書には画像の複数の表現が含まれている可能性があります。(The info dictionary may contain multiple representations of the image.)
        // 元の画像を使用してください。(You want to use the original.)
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
          fatalError("Expected a dictionary containing an image, but was provided the following: \(info)") // アプリを強制終了させる
        }
        
        // 選択した画像を表示するように photoImageView を設定する(Set photoImageView to display the selectedImage.)
        photoImageView.image = selectedImage
        
        // ピッカーを閉じる(Dismiss the picker.)
        dismiss(animated: true, completion: nil)
    }
}
