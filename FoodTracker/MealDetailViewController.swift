//
//  ViewController.swift
//  FoodTracker
//
//  Created by Sigma7863 on 2025/12/12.
//

import UIKit
import os.log

class MealDetailViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    // @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     この値は、`prepare(for:sender:)` の `MealTableViewController` によって渡されるか、新しい食事の追加時に構築されます。
     */
    var meal: Meal? // Optional型なので?を付けている

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        // ViewController のロード時に meal が nil でなければあらかじめ各オブジェクトに値を入れておきます。
        // nil でない場合は ShowDetail で遷移した場合で、 nil の場合は AddItem で遷移した場合です。
        // このように、この if let でどちらの場合も正しい表示にできました。
        // Set up views if editing an exsisting Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // テキスト フィールドに有効な食事名が入力されている場合にのみ、保存ボタンを有効にします。(Enable the Save button only if the text text field has a valid Meal name.)
        updateButtonState()
    }
    
    // MARK: Navigation
    // キャンセル(×ボタン)を押して写真を追加するタブを閉じる
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // プレゼンテーションのスタイル (モデルまたはプッシュ プレゼンテーション) に応じて、このビュー コントローラーを 2 つの異なる方法で閉じる必要があります。(Depending on style of presentation (model or push presentation), this view controller needs to be dismissed in two different ways.)
        let isPresentingInAddMealMode = presentingViewController is UINavigationController // 現在どのような方法（モーダルかプッシュか）で表示されているのかを判定するのに使用する定数
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil) // dismiss(animated:completion:) メソッドはモーダルを閉じるメソッド, 引数には閉じる際にアニメーションをするかどうか、閉じ終わった後に行う処理を指定
        } else if let owingNavigationController = navigationController {
            owingNavigationController.popViewController(animated: true)
        } else { // この else 節はなくても問題はないですが、今後変更があった際に fatalError となり未実装の部分を 把握できるのであったほうが保守性が上がります。
            fatalError("The MealDatailViewController is not inside a navigation controller.") // MealDetailViewController はナビゲーション コントローラー内にありません。
        }
        
    }
    // (このメソッドを使用すると、ビュー コントローラが表示される前に構成できます。)This method lets you configure a view controller befor it's presented.
    // オーバーライドしたメソッドは、そのままではスーパークラスの実装を引き継ぎません。
    // スーパークラスの挙動に追加してカスタムしたい場合はスーパークラスのメソッドを呼ぶことで スーパークラスの実装をサブクラスでも利用できるようになります。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // 保存ボタンが押されたときにのみ、宛先ビュー コントローラーを構成します。(Configure the destination view controller only when the save button is pressed.)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? "" // nil結合演算子(??): オプショナル型が nil でなければ左側の値をアンラップしたものを、 nil ならば右側の値を返すもの
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // unwind segue（戻る遷移）が実行されたあと、MealTableViewController に渡す meal オブジェクトを設定する(Set the meal to be passed to MealTableViewController after the unwind seque.)
        meal = Meal(name: name, photo: photo, rating: rating)
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
    // @IBAction func setDefaultLabelText(_ sender: UIButton) {
    //     mealNameLabel.text = "Default Text"
    // } // Swift は関数呼び出しの際は基本的に引数名を書かないといけないが、アンダースコアをつけることで省略できる
}

// MARK: UITextFieldDelegate
extension MealDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
        navigationItem.title = textField.text
    }
        
    func textFieldDidBeginEditing(_ textField: UITextField) { // Text Field が編集され始めた時またはキーボードが出現した場合に呼ばれるメソッド
        // ラベル(Meal Name)のテキストをテキストフィールドに入力されたテキストに変換
        // mealNameLabel.text = textField.text
        
        // 編集中は保存ボタンを無効にする。(Disable the Save button while editing.)
        saveButton.isEnabled = false
    }
    
    // MARK: Private Methods
    private func updateButtonState() {
        // テキスト フィールドが空の場合は保存ボタンを無効にする。(Disable the Save button if the text field is empty.)
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

// MARK: UIImagePickerControllerDelegate+UINavigationControllerDelegate
// ユーザが Image View をタップしたら、フォトライブラリから画像を選択できるようにする
extension MealDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
