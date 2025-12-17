基本的な UI を作ろう 2

前回に引き続き、「フードトラッカー」アプリを開発していきます。
今回は UI をカスタマイズしていきます。

今回の環境は、

macOS Big Sur 11.4
Xcode 12.5.1 (12E507)
です。

前回までに作成したプロジェクトは こちら です。

目次
【講義】ViewController の働きを知ろう
viewDidLoad()
viewWillAppear()
viewDidAppear()
【実習】フォトライブラリから画像を取得しよう
Image View を追加する
デフォルトの画像を表示しよう
Image View とコードを繋げよう
タップジェスチャーを取得しよう
Image Picker から画像を取得し、表示しよう
【実習】UI をカスタマイズしよう
カスタムされた View を作成しよう
UIStackView のサブクラスを作成しよう
初期化関数をオーバーライドしよう
カスタム View を表示しよう
View を表示しよう
View にボタンを追加しよう
View でボタンを作成しよう
プロパティを追加しよう
まとめ
【講義】ViewController の働きを知ろう
前回までに作成したフードトラッカーアプリは一つの Storyboard と ViewController で構成されています。
Storyboard の表示のことを Scene と呼びます。
もっとアプリの構造が複雑になると複数の Scene に対処する必要が出てきます。
すると Scene を切り替えることで View が現れたり消えたりするようになります。
その時にプログラムは View をロードしたり破棄したりするということになります。

ロードや破棄などで View の表示状態が変化することをライフサイクルと言います。
これから UIViewController のライフサイクルについて学習し、状態に応じた処理ができるようになりましょう。

UIViewController クラスやそのサブクラスには View の階層を管理するメソッドがあります。
ViewController が状態を変えるタイミングで、 iOS は自動的にそれらのメソッドを呼びます。
UIViewController のサブクラスを作った場合は、それらのメソッドを継承してそれぞれのメソッドに独自の処理を実装することができます。
それらのメソッドが呼ばれるタイミングを知ることで View を制御できます。
以下の図はアプリの状態変化とそれに対応するメソッドを表しています。

UIViewController のライフサイクル
UIViewController の状態変化に対して呼ばれるメソッドは以下のようなものがあります。

viewDidLoad()
viewWillAppear(_:)
viewDidAppear(_:)
viewDidLoad()
ViewController の最背面の View が Storyboard から作られ、ロードされた時に呼ばれます。
このメソッドは生成時に一度だけ呼ばれることになっているため、ここで初期設定を行うことが多いです。

viewWillAppear()
View が出現する直前に呼ばれます。
View は他の View に隠されたり、アプリがバックグラウンドに行ったりした後に再び出現することがあるので、 このメソッドは何度も呼ばれることがあります。

viewDidAppear()
View が出現した直後に呼ばれます。
viewWillAppear() と同じく何度も呼ばれることがあります。

さて、ここで前回実装を進めた FoodTracker アプリの ViewController クラスを見てみると、すでに viewDidLoad() を実装しています。

override func viewDidLoad() {
  super.viewDidLoad()

  // Handle the text field’s user input through delegate callbacks.
  nameTextField.delegate = self
}

View がロードされた段階で nameTextField のデリゲートを設定しています。

このように ViewController が View とデータモデルを繋ぐ設計を、 MVC (Model-View-Controller) といいます。
MVC では Model がアプリのデータを保持し、 View は UI を表示し、コンテンツを作ります。そして Controller はビューの管理をします。
ユーザのアクションに反応して Controller が Model と View をつなぎます。

iOS アプリは基本的に MVC で開発をします。
もちろん他の手法もいくつか存在しますが、今回は基本的な MVC で開発していくこととします。

【実習】フォトライブラリから画像を取得しよう
次に、 Main.storyboard で　UI を作成していた ViewController scene に変更を加えていきます。
食事の写真を表示する UI を追加します。

Image View を追加する
画像を取り扱う UI は、 Image View (UIImageView) といいます。

まず、 Main.storyboard を開き、Stack View を選択します。

Stack View の選択
次に command ⌘　＋　shift ⇧　＋　L で Library を開きます。
そこで filter に image view と入力すると Image View が見つかります。

Image View を StackView に加えます。
Image View を StackView 内のSet Default Label Text ボタンの下に配置しましょう。

Image View の配置
Image View が下の写真のように Stack View の中に入っていることを確認しましょう。 （うまく入っていない場合は、ドラッグして Stack View の中に入れましょう）

Image View が Stack View の中に入っている
この状態ではデフォルトのサイズになっているので、縦横のサイズを 320 にします。
Image View をクリックして選択したら、 utility area の Size inspector を開きましょう。
Size inspector ではオブジェクトのサイズや位置を編集することができます。
Width と Height にそれぞれ 320 と入力し return を押しましょう。

Width と Height の設定
すると Image View のサイズが変化しました。
このように Size inspector でプロパティを変更すると即座に Storyboard で確認することができます。

まだこの状態では Image View の場所が決まらず Constraints のエラーが出るので、 Add New Constraints ボタンを押して Constraints を設定していきます。

Add New Constraints ボタンを押すと Constraints のポップアップが現れます。
Image View は画像を表示するので、デバイスによって縦横比が変わらないようにします。
Aspect Ratio にチェックを入れましょう。
そのあとに Add 1 Constraint ボタンを押します。

Image View の Constraints 設定
この Image View は表示上の縦と横がそれぞれ 320 になっている時に Aspect Ratio の Constraint を加えたので、常に縦横比が 1:1 になります。
縦または横の大きさについては制約を加えていないので、大きさは表示する画像によります。
これで Constraints のエラーが解消されました。

次に、 Image View をタップできるようにします。
デフォルトで Image View はユーザの入力を受け付けません。
Attributes inspector を開き、 View の項目の User Interaction Enabled にチェックを入れましょう。
こうすることでユーザのタップやスワイプといった入力を受け取れるようになります。

User Interaction Enabled のチェック
デフォルトの画像を表示しよう
Storyboard 上では Image View が設置されましたが、まだこの段階ではユーザからは何も見えません。
アプリを開いた際に表示する、デフォルトの画像を設定しましょう。

まずは以下から FoodTracker アプリで使用する画像をダウンロードしましょう。

Images.zipをダウンロード

画像を Project に追加します。
project navigator から Assets.xcassets を開きましょう。
Assets.xcassets は　asset catalog と呼ばれるものですが、 これはアプリで使用する画像リソースを管理するためのものです。
iOS 端末は複数の解像度のものがあるので、それに合わせて画像も三種類用意する必要があります。
また、アプリアイコンや起動時の画像なども必要です。
それらを管理するのが asset catalog です。

editor area の左下にある + ボタンを押し、 Image Set を選択します。

Image Set のありか
Image という名前の Image Set ができています。
名前をダブルクリックして、 defaultPhoto と入力し return を押しましょう。
すると defaultPhoto という名前の Image Set になります。

Image Set の名前設定
Image Set にはスロットが 3 つ用意されています。
これは先ほど述べたように iOS 端末の画面解像度に合わせて適切なものを表示するようにするためです。
1x, 2x, 3x とありますがそれぞれ元の画像サイズの 1 倍、2 倍、3 倍のサイズを表しています。
Image Set にまとめることで同じ画像でサイズの違うものがプロジェクト上に溢れてしまうことを防ぎ、 管理しやすくしています。

３つのスロット
defaultPhoto.png をこの Image Set に追加します。
画像をドラッグして、 2x のスロットにドロップします。
実際にアプリをリリースするにはすべてのスロット用の画像を用意すべきですが、今回は iPhone 11 Pro のシミュレータを 使用するので 2x のみでよいことになります。

画像のドラッグ
これで画像が Project に追加されたので、 Storyboard で Image View に画像を設定していきます。

Main.storyboard の Image View を選択します。
utility area の Attributes inspector を開きます。
Image プロパティに defaultPhoto と入力（またはプルダウンから選択）します。

defaultPhoto のプルダウン
ここまでできたらビルドを iPhone 11 Pro のシミュレータで行いましょう。
デフォルトの画像が現れることを確認します。

Image View とコードを繋げよう
これまででデフォルトの画像を表示できました。
これからはこの画像を変更できるような処理を実装していきます。

まずは Assistant editor モードにして、左側に Main.storyboard 、右側に ViewController.swift を 表示させましょう。

Assistant editor
この際に画面が狭く感じるようなら project navigator や utility area を非表示にしておきましょう。

画面はこのような状態になっていると思います。

画面の整理
Image View とコードを繋げます。
Image View から control ⌃ を押しながらドラッグし、mealNameLabel の宣言の下でドロップします。

control を押しながらドラッグ
ダイアログが現れるので、名前を photoImageView として Connect をクリックします。
すると以下の一行が追加され、 Image View とコードが接続されました。

@IBOutlet weak var photoImageView: UIImageView!

これで Image View の画像を変更できますが、 iOS はイベント駆動です。
どのイベントを元に変更するかを決める必要があります。
今回は、 Image View のユーザのタップによってイベントが開始するようにします。

タップジェスチャーを取得しよう
タップジェスチャーを設定するには、 Gesture Recognizer を使用します。
Gesture Recognizer は View に対してなされたアクションを制御するオブジェクトです。
タップやスワイプ、ピンチや回転などのアクションを判定することができます。
早速 Image View に追加してみましょう。

command ⌘　＋　shift ⇧　＋　L でLibrary を開き、フィルタに tap gesture と入力します。
すると Tap Gesture Recognizer が現れます。
これを Image View の上にドラッグ&ドロップします。

Tap Gesture Recognizer
すると View Controller の上部に Tap Gesture Recognizer が現れます。
ここの部分を Scene dock と呼びます。

Scene dock と Tap Gesture Recognizer
この Tap Gesture Recognizer をコードと繋げます。
Tap Gesture Recognizer から control ⌃ を押しながらドラッグし、 ViewController.swift の // MARK: Actions の下で ドロップします。

Tap Gesture Recognizer をコードに繋げる
ダイアログが現れるので、 Connection を Action 、 Name を selectImageFromPhotoLibrary 、 Type を UITapGestureRecognizer にして Connect をクリックします。

Tap Gesture Recognizer の設定
すると以下の二行が追加されます。

@IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
}

これで Image View をタップしたら selectImageFromPhotoLibrary が呼ばれるようになりました。

Image Picker から画像を取得し、表示しよう
ユーザが Image View をタップしたら、フォトライブラリから画像を選択できるようにします。
iOS には UIImagePickerController クラスが用意されているのでこれを使用します。
Image Picker Controller はフォトライブラリへのアクセスとカメラへのアクセスを行い 画像を取得することができます。

ViewController クラスに UIImagePickerControllerDelegate プロトコルを適用させます。
こうすることで UIImagePickerController の処理をデリゲートメソッドで受け取ることができる ようになります。また、 UIImagePickerControllerDelegate を適用する際には UINavigationControllerDelegate プロトコルの 適用も必要なのでこちらもまとめて行います。

ViewController.swift を開きます。
一番下の行に以下の実装を加え、 UIImagePickerControllerDelegate と UINavigationControllerDelegate を適用させます。

// MARK: UIImagePickerControllerDelegate+UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
}

基本的には一つのプロトコルにつき一つの extension を作りますが、今回 UINavigationControllerDelegate は 重要ではなく、 UIImagePickerControllerDelegate に付随するものなので一つにまとめました。
複数のプロトコルを適用するときはカンマ , で区切って宣言をします。

次に ViewController クラスの selectImageFromPhotoLibrary(_:) アクションメソッドの中身を実装していきます。
現在は以下のようになっています。

@IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
}

このメソッドに以下を実装していきます。

まずはキーボードを隠します。

// Hide the keyboard.
nameTextField.resignFirstResponder()

これは、 Image View をタップする前に Text Field をタップしていて編集中だった場合にキーボードが 出ているので、そのための対策です。
このメソッドで行う処理はキーボードが FirstResponder である必要がないので解除しておきます。

次に UIImagePickerController のインスタンスを作成します。

// UIImagePickerController is a view controller that lets a user pick media from their photo library
let imagePickerController = UIImagePickerController()

次に、フォトライブラリからの読み込みを指定します。

// Only allow photos to be picked, not taken.
imagePickerController.sourceType = .photoLibrary

imagePickerController.sourceType は列挙型になっており、他にはカメラやカメラロールを選択できます。
今回はシミュレーターで実行するため、カメラが使えないので photoLibrary を指定しています。

これを指定するには、右辺は UIImagePickerControllerSourceType.photoLibrary である必要があります。
しかし左辺から型推論により、右辺の型は UIImagePickerControllerSourceType であると決定されます。
そのため型を明記しなくても列挙型の case (.photoLibrary) を書くだけで指定できるということです。

次に、デリゲートを設定してユーザが画像を選択した際に通知を受け取れるようにします。

// Make sure ViewController is notified when the user picks an image.
imagePickerController.delegate = self

最後に以下のコードを加えて imagePickerController を表示させます。

present(imagePickerController, animated: true, completion: nil)

present(_:animated:completion:) は ViewController のメソッドです。
第一引数に指定した ViewController を現在の ViewController の上に被せます（これを モーダル といいます）。

今回であれば imagePickerController を ViewController の上に被せて表示をさせるという動作になります。
第二引数の animated は被せる際にアニメーションをするかどうかです。 true だとアニメーションをします。
第三引数の completion は被せる動作が完了した後に呼ばれるコールバックです。今回は nil を指定しているので何もしません。

ここまでで selectImageFromPhotoLibrary(_:) メソッド全体は以下のようになっています。

@IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
  // Hide the keyboard.
  nameTextField.resignFirstResponder()

  // UIImagePickerController is a view controller that lets a user pick media from their photo library.
  let imagePickerController = UIImagePickerController()

  // Only allow photos to be picked, not taken.
  imagePickerController.sourceType = .photoLibrary

  // Make sure ViewController is notified when the user picks an image.
  imagePickerController.delegate = self
  present(imagePickerController, animated: true, completion: nil)
}

ここまでで、ユーザが Image View をタップしたら Image Picker Controller を表示させることができました。

Image Picker Controller
次にユーザがフォトライブラリから画像を選択した後の処理を実装します。
以下の二つのデリゲートメソッドを実装していきます。

func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])

imagePickerControllerDidCancel(_:) はユーザが画像の選択をキャンセルした場合に呼ばれます。
imagePickerController(_:didFinishPickingMediaWithInfo:) はユーザが画像を選択し終わった後に呼ばれます。

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {} の中に実装をしていきましょう。

まずは imagePickerControllerDidCancel と入力すると補完がされ、補完に従うと以下のようにメソッドが挿入されます。

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

}

このメソッドに以下の行を書きましょう。

// Dismiss the picker if the user canceled.
dismiss(animated: true, completion: nil)

dismiss(animated:completion:) は present(_:animated:completion) と対になるメソッドで、 モーダルの ViewController を閉じる動作をします。

imagePickerControllerDidCancel(_:) 全体は以下のようになっています。

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
  // Dismiss the picker if the user canceled.
  dismiss(animated: true, completion: nil)
}

次に、 imagePickerController(_:didFinishPickingMediaWithInfo:) を実装します。
同じように imagePickerController と入力するとメソッドが補完され、補完に従うと以下のように挿入されます。

 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

}

このメソッドにはユーザが画像を選択した後の処理を実装します。
まずはエラー処理を行います。以下のコードを書いてみましょう。

// The info dictionary may contain multiple representations of the image. You want to use the original.
guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
  fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
}

guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {} の説明をします。
これは guard 文です。
guard 文は主に早期リターン (Early Exit) に使用される文で、今後の処理を行う上でまず弾いておきたい例外条件を判定します。
以下のような文法です。

guard 評価式 else {

}

else は評価式が false の場合に実行されます。 if 文の逆ですね。
評価式は真偽値だけでなく Optional Binding も使用できます。この場合は nil の場合に else が実行されます。
また、 else 内では必ず return またはそれに準ずるものを書き、このスコープを抜けたら guard 以下が実行されない ようにする必要があります。

今回は Optional Binding で info[UIImagePickerController.InfoKey.originalImage] as? UIImage が nil かどうかを 判定しています。また nil でない場合に selectedImage は guard 文の後で UIImage 型の定数として使用できます。

次に info[UIImagePickerController.InfoKey.originalImage] as? UIImage が何を表すか見ていきます。
まず info ですが、 これは　imagePickerController(_:didFinishPickingMediaWithInfo:) の引数で、[UIImagePickerController.InfoKey : Any] 型です。
これは Dictionary 型です。
Dictionary 型はキーに対応する値を格納しておくコレクションです。
Dictionary の値にアクセスするには角括弧 [] の中にキーを指定します。

Dictionary の動作を確認してみましょう。
ターミナルを開き、swift repl コマンドを実行します。

swift repl

すると Swift の REPL が立ち上がるので、以下のコードを書いてみましょう。

Dictionary の宣言

var sampleDictionary = [
  1: "ひ",
  2: "ふ",
  3: "み",
  4: "よ",
  5: "いつ"
]

値の取り出し

sampleDictionary[3]   // "み"

値の変更

sampleDictionary[4] = "よん"
sampleDictionary[4]   // "よん"

値の追加

sampleDictionary[6] = "む"
sampleDictionary[6]   // "む"

なお、 let で宣言をすると値の変更、追加はできません。

REPL の終了

:exit

Swift Standard Library の挙動を試したい場合はターミナルで REPL 実行するのが手軽で便利です。

先ほどの info[UIImagePickerController.InfoKey.originalImage] as? UIImage は info Dictionary の UIImagePickerController.InfoKey.originalImage のキーに対応する値を取り出し、それを UIImage にダウンキャストしています。
また UIImagePickerController に関係する定数は こちら で一覧できます。

つまり、 guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {} は info に UIImagePickerController.InfoKey.originalImage をキーとする値が存在し、 UIImage にキャストできるかどうかを調べています。
UIImagePickerController.InfoKey.originalImage をキーとする値が存在しなかったり、存在しても UIImage にキャストできなかった場合は else の中の fatalError("Expected a dictionary containing an image, but was provided the following: \(info)") が 実行されます。

fatalError(_:file:line:) はアプリを強制終了させるメソッドです。
基本的には起こり得ることがない箇所に記述し、アプリを終了させます。
今回は guard 文に引っかかることは想定しておらず、常に info[UIImagePickerController.InfoKey.originalImage] が UIImage にキャストできるとするので、それが失敗した場合はアプリを終了させます。

さて、ここまででフォトライブラリから取得した画像を UIImage として取り出すことができたので、この画像を UI に反映させていきます。
以下のコードを書いてみましょう。

// Set photoImageView to display the selectedImage
photoImageView.image = selectedImage

取得した画像を photoImageView に反映させたら imagePickerController を閉じます。

// Dismiss the picker.
dismiss(animated: true, completion: nil)

ここまでで、 imagePickerController(_:didFinishPickingMediaWithInfo:) を含めた、 UIImagePickerControllerDelegate+UINavigationControllerDelegate 全体は以下のようになっています。

// MARK: UIImagePickerControllerDelegate+UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // Dismiss the picker if the user canceled.
    dismiss(animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // The info dictionary may contain multiple representations of the image.
    // You want to use the original.
    guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
      fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }

    // Set photoImageView to display the selected image.
    photoImageView.image = selectedImage

    // Dismiss the picker.
    dismiss(animated: true, completion: nil)
  }
}

ここまでできたらシミュレーター実行をしてみましょう。
Image View をタップするとすると画像のようにフォトライブラリが現れます。

Cancel ボタンを押すと Picker が閉じること、 カメラロールから画像を選択すると Picker が閉じて Image View に画像が設定されていることを確認しましょう。

カメラロール

動作確認はできましたが、カメラロールの画像には残念ながら食べ物の写真がないことに気づきます。
FoodTracker アプリを開発する上で食べ物の写真がなければ様にならないのでシミュレーターに写真を追加しておきましょう。

シミュレーターでデバッグ実行をします（すでに実行中の場合はそのままでよいです）。
ダウンロードした Images フォルダの meal1.jpeg をシミュレーターにドラッグ&ドロップします。
するとフォトライブラリに画像が追加されるので、 Image View をタップしてフォトライブラリを開き、先ほど追加した画像を選択しましょう。
Image View がその画像になっていればこのセクションは完了となります。

食べ物の写真をドラッグ&ドロップで追加

【実習】UI をカスタマイズしよう
次に、 FoodTracker アプリにレーティングの機能を追加します。
今節と次節の学習を終えると以下のような UI になります。

FoodTracker

レーティングの UI はデフォルトでは提供されていないので独自に実装する必要があります。
カスタム UI 、カスタムクラスを作成していきましょう。

カスタムされた View を作成しよう
食事のレーティングを行うためには、ユーザの操作で星の数を制御する必要があります。
これを実現するには様々な方法がありますが、 iOS の流儀に合わせるために既存の View や Control を 組み合わせることでカスタム Control を実装していきます。
Stack View (UIStackView) のサブクラスを作成しそこにボタンを並べていきましょう。
カスタム Stack View の完成図は以下のようなものです。

カスタム Stack View の完成図
ユーザは食事のレーティングをすることができます。
星をタップするとタップされた星までが塗りつぶされレーティングされるようにします。

UIStackView のサブクラスを作成しよう
メニューの File > New > File... を選択します（または command ⌘ + N を押します）。
iOS のカテゴリを選択します。
Cocoa Touch Class を選択し、 Next を押します。
Class 名は RatingControl と入力します。
Subclass は UIStackView と入力します（プルダウンにあれば選択します）。
Language は Swift となっていることを確認します。もしなっていなかったら Swift を選択してください。
Next を押します。
保存場所を選択します。
デフォルトのプロジェクトディレクトリ FoodTracker に保存します。
Group も FoodTracker となっていることを確認してください。
Create を押します。
すると RatingControl.swift が作成されます。以下のような中身になっている場合もありますが、

import UIKit

class RatingControl: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

このコメントはテンプレートで、今回は必要ないので削除しましょう。

import UIKit

class RatingControl: UIStackView {

}

View を作成するには二つの方法があり、それぞれ初期化関数が異なります。

作成方法	初期化関数
コードで初期化をする	init(frame:)
Storyboard から初期化をする	init?(coder:)
これらの初期化関数をどちらも実装する必要があります。

初期化関数をオーバーライドしよう
RatingControl.swift を開き、 class 宣言の下に以下のコメントを記述します。

// MARK: Initialization

このコメントの下に初期化関数を実装します。

init とタイプすると以下のような補完がされると思います。

init(frame: CGRect) の補完
init(frame: CGRect) を選択すると以下の初期化関数が挿入されます。

override init(frame: CGRect) {
  code
}

init(frame:) はスーパークラスで定義されているので、サブクラスでも実装する場合はオーバーライドする必要があります。
この初期化関数に一行を加え、親クラスの初期化関数を呼びます。

super.init(frame: frame)

赤い丸のエラーが出ているので、これを解消しましょう。
赤い丸をクリックすると 'required' initializer 'init(coder:)' must be provided by subclass of 'UIStackView'" という詳細と、

insert '
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
'

というサジェストが現れます。

Fix を押すと、 init(coder:) 初期化関数が挿入されます。

required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

required キーワードはサブクラスに初期化関数のオーバーライドを強制する場合に使用します。
今回の例では、 UIStackView が init(coder:) の実装を強制していたため RatingControl も 実装する必要があったということです。

init(coder:) にはすでに fatalError が書かれていますが、これを削除して 以下の一行に書き換えましょう。

super.init(coder: coder)

ここまでで初期化関数は以下のようになっています。

override init(frame: CGRect) {
    super.init(frame: frame)
}

required init(coder: NSCoder) {
    super.init(coder: coder)
}

今はスーパークラスの初期化関数を呼んでいるだけですが、このセクションの後ほどに独自の実装を加えていきます。

カスタム View を表示しよう
RatingControl を表示するには、 Storyboard に Stack View を追加してコードと接続する必要があります。

View を表示しよう
まずは Main.storyboard を開きます。

Library から Horizontal Stack View オブジェクトを選択し、 Stack View に追加します。
Stack View を選択した状態で、位置は画像のように Image View の下にしましょう。
Stack View の中に Stack View が入っている状態です。

追加できたら Horizontal Stack View を選択し、 return を押して名前を Rating Control に変更します。

Stack View の名前変更
続けて Identity inspector を開きます。
Custom Class の Class を RatingControl にします。

RatingControl Class に設定
これで Storyboard 上の Horizontal Stack View は RatingControl クラスを指すようになりました。

続けて Size inspector を開きます。
Width を 282 に、Height を 50 に設定します。

高さと横幅のサイズ調節
View にボタンを追加しよう
ここまでで、 UIStackView のサブクラスである RatingControl の基本的な部分を実装できました。
これからユーザがレーティングできるようにボタンを追加していきましょう。
まずはシンプルに、赤色のボタンが見れるようにします。

View でボタンを作成しよう
初期化関数が呼ばれたらボタンを View に追加するようにします。
setupButtons() というメソッドを二つの初期化関数に追加しましょう。

RatingControl.swift を開きます。
まず、初期化関数の下（二つの init 関数の下）に以下のコメントを追加します。

// MARK: Private Methods

このコメントの下には private メソッドを実装します。
以下のコードを書いてみましょう。

private func setupButtons() {

}

func の前に private と書いてあります。
これはアクセス修飾子 (Access Control) といい、 func がどこからアクセス可能かを表します。
private 修飾子を使用すると、このメソッドが定義されたクラス、または同じファイルの extension からのみアクセスできるようになり、他のクラスからはアクセスできなくなります。

他のアクセス修飾子は以下のようなものがあります。

アクセス修飾子	役割
private	同じクラス以外からはアクセスできない
fileprivate	同じファイル内でしかアクセスできない
internal	同じモジュール内でしかアクセスできない
public	外のモジュールからアクセスできるがオーバーライドできない
open	外のモジュールからアクセスでき、オーバーライドもできる
private が一番制限が強く、 open が一番弱いというようになっています。
ここで モジュール が出てきましたが、これは UIKit や Foundation のように ソースコードにインポートする単位のことで、主にライブラリやフレームワーク単位で 区切られます。

さて、 setupButtons() を実装していきます。
以下のコードを追加して赤色のボタンを作成します。

// Create the button
let button = UIButton()
button.backgroundColor = UIColor.red

ここで、 UIButton クラスの convenience な初期化関数を使用しました。
これは init(frame:) にサイズがゼロの四角を指定して初期化するのと同じ意味を持ちます。
フレーム（位置とサイズ）がゼロで初期化されますが、問題ありません。
サイズは後ほど制約を決めますし、位置は StackView によって決定されるので初期化時に設定する必要がないからです。

今回、背景色には赤を指定しました。後ほど画像を指定しますが、ひとまず View の位置をわかりやすくするために 赤色にしてあります。 View の背景色に合わせて青や緑に適宜変更してもよいでしょう。

続けて以下を書き、ボタンの制約を指定します。

// Add constraints
button.translatesAutoresizingMaskIntoConstraints = false
button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
button.widthAnchor.constraint(equalToConstant: 50.0).isActive = true

button.translatesAutoresizingMaskIntoConstraints = false は、 View の自動的にボタンに制約がかかるのをやめています。
その下の二行は制約をコードで作成しています。
今回は縦と横の幅を決めています。
これによりボタンのサイズが縦横 50 x 50 になりました。

最後に以下のコードを加えてボタンを Stack View に追加します。

// Add the button to the stack
addArrangedSubview(button)

ここまでできたら、 setupButtons() を 2 つの初期化関数から呼びましょう。

override init(frame: CGRect) {
    super.init(frame: frame)
    setupButtons()
}

required init(coder: NSCoder) {
    super.init(coder: coder)
    setupButtons()
}

ここまでで、 RatingControl クラス全体は以下のようになっています。

class RatingControl: UIStackView {

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    // MARK: Private Methods

    private func setupButtons() {
        // Create the button
        let button = UIButton()
        button.backgroundColor = UIColor.red

        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50.0).isActive = true

        // Add the button to the stack
        addArrangedSubview(button)
    }
}

シミュレーターでアプリを実行し、動作確認をしてみましょう。
画像のように赤く四角いのボタンが追加されていれば OK です。

赤く四角いボタン
次にボタンが押された時のアクションを実装します。
まずは RatingControl.swift の // MARK: Initialization セクションの下に次のコメントを加えます。

// MARK: Button Action

そのコメントの下に以下のコードを加えます。

@objc func ratingButtonTapped(button: UIButton) {
    print("Button pressed 👍")
}

👍 は Mac 標準の IME で「ぐっど」で変換できます。

print() 関数は ratingButtonTapped(_:) アクションが呼ばれた時にログ出力を行うものです。
ログ出力はデバッグの際に有用です。
さて、 setupButtons() メソッドに変更を加えてボタンのタップをハンドリングします。

現在は以下のようになっています。

private func setupButtons() {
    // Create the button
    let button = UIButton()
    button.backgroundColor = UIColor.red

    // Add constraints
    button.translatesAutoresizingMaskIntoConstraints = false
    button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    button.widthAnchor.constraint(equalToConstant: 50.0).isActive = true

    // Add the button to the stack
    addArrangedSubview(button)
}

ここで、 // Add the button to the stack と書かれている部分の上に以下のコードを書き足してボタンタップをハンドリングします。

// Setup the button action
button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)

今までは UI のアクションを Storyboard と接続をして行っていました。
その場合は addTarget(_, action:, for:) メソッドを書いたことはありませんでしたが、 動作としては同じになります。
Storyboard でもコードでも UI のアクションをハンドリングできるということです。

今回加えたコードは、 button がタップされた場合に ratingButtonTapped(_:) を呼び出すという動作をします。
第一引数の self は、どのオブジェクトがタップイベントを受け取るかということを示します。
今回は RatingControl クラスでタップイベントを受け取ります。
第二引数はタップ時にどのメソッドを呼ぶかを示します。
#selector はメソッドを指定する時のセレクタです。
第三引数は第二引数のメソッドを呼ぶタイミングを示します。
基本的に .touchUpInside を指定します。
これはボタンをタップしてボタン上で指が離れた場合に発火します。
他にはボタンをタップした瞬間に発火する .touchDown があります。

setupButtons() は以下のようになっています。

private func setupButtons() {
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
}

ここまでできたらシミュレーターでアプリを実行し、赤い四角のボタンをタップしてみましょう。
以下の図のようにログが出たら成功です。

ログ
さて、ここまでで RatingControl でレーティングをする準備が整いました。
これからはボタンを増やすことと、 ボタンをタップされた場合にレーティングがいくつかという情報を保持することを行います。

プロパティを追加しよう
RatingControl.swift の class RatingControl: UIStackView { の一行下に以下のコードを加えます。

// MARK: Properties
private var ratingButtons = [UIButton]()

var rating = 0

2 つのプロパティが加わりました。
1 つめは ratingButtons です。Stack View に載るボタンです。複数あるので配列で宣言をします。
このクラス以外からアクセスする必要はないので private にしています。
2 つめは rating です。この Control のレーティングを保持します。
このクラス以外から読み書きできるように internal にしています。
Swift ではデフォルトのアクセス修飾子が internal なため、明示しなくてもよいです。

次に、 5 つのボタンを表示するようにします。現在は 1 つのボタンしか表示できないので、 setupButtons() メソッドにループを加えます。
以下のように for-in ループで複数のボタンのインスタンスを作成します。

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
}

for-in ループで囲ったのち、このループ全体を選択してから control ⌃ + I を押すと Xcode が整形をしてくれるので 利用してみてください。

この作成されたボタンに後からアクセスできるように、 ratingButtons に割り振りをします。
for-in ループの最後に以下のコードを加えます。

// Add the new button to rating button array
ratingButtons.append(button)

append(_:) は配列の末尾に引数の要素を加えるメソッドです。

setupButtons() 全体は以下のようになっています。

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

ここまでできたらシミュレーターで実行してみましょう。
以下の図のように、横長の四角が現れたら OK です。
ここには 5 つのボタンが並んでいますがスペースがないためくっついて表示されています。

５つ並んだボタン
これを直すために Storyboard を使います。
Main.storyboard を開き、 RatingControl Stack View を選択します。
Attributes inspector を開き、 Spacing の項目を 8 にします。
こうすることでボタンの間に全て 8px のスペースができました。

8px のスペース
再度シミュレーターで実行をしてみましょう。
上図のように等間隔でボタンが配置されていることを確認します。
また、ボタンを押すと ratingButtonTapped(button:) が呼ばれてログ出力されることも確認しましょう。

今回はここまでです。
レーティングのカスタム View を配置まで行えました。
次回はボタンの画像を設定したり、レーティングを行う際の処理を実装したりしていきます。

今回のプロジェクトは こちら です。

まとめ
ViewController のライフサイクルによって呼び出されるメソッドを利用して View の初期化などを行う
UIImagePickerController を使用してフォトライブラリから画像を取得できる
コード上でカスタマイズすることで独自の View を作成できる

---
## リンク

[viewDidLoad()](https://developer.apple.com/documentation/uikit/uiviewcontroller/viewdidload())

[viewWillAppear(_:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/viewwillappear(_:))

[viewdidappear(_:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/viewdidappear(_:))

[UIImageView](https://developer.apple.com/documentation/uikit/uiimageview)

[UIGestureRecognizer](https://developer.apple.com/documentation/uikit/uigesturerecognizer)

[UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller)

[UIImagePickerController.SourceType](https://developer.apple.com/documentation/uikit/uiimagepickercontroller/sourcetype-swift.enum)

[present(_:animated:completion:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/present(_:animated:completion:))

[Checking API Availability](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/controlflow/#Checking-API-Availability)

[Dictionary](https://developer.apple.com/documentation/swift/dictionary)

[originalImage](https://developer.apple.com/documentation/uikit/uiimagepickercontroller/infokey/originalimage)

[UiimagePickerController.Infokey](https://developer.apple.com/documentation/uikit/uiimagepickercontroller/infokey)

[fatalerror(_:file:line:)](https://developer.apple.com/documentation/swift/fatalerror(_:file:line:))

[UIStackview](https://developer.apple.com/documentation/uikit/uistackview/)

[init(frame:)](https://developer.apple.com/documentation/uikit/uiview/init(frame:))

[Access Control](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/)

