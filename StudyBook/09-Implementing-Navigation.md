Navigation を実装しよう

前回までで 2 つの ViewController の UI を作成しました。
今節では Navigation Controller を使って画面遷移を学びます。

今回の環境は、

macOS Big Sur 11.4
Xcode 12.5.1 (12E507)
です。

前回までに作成したプロジェクトは こちら です。

目次
【実習】Navigation Controller を組みこもう
【実習】Navigation Bar を設定しよう
【実習】新しいデータを保存する準備をしよう
【実習】戻るための Segue を作成しよう
【実習】ボタンの状態を制御しよう
【実習】データ入力をキャンセルしよう
まとめ
【実習】Navigation Controller を組みこもう
「フードトラッカー」アプリを起動すると Meal List Scene が表示されます。
ここから Meal Detail Scene に遷移をさせることを目的とします。

iOS 開発では Scene 間の遷移のことを Segue (セグウェイ) と呼びます。

Segue を作成する前に、 Scene を修正します。
まず、 Table View Controller に Navigation Controller を組み込みます。Navigation Controller は ViewController の遷移を管理するものです。

以下の手順に従って Navigation Controller を組み込みましょう。

Main.storyboard を開きます。
Meal List Scene の Scene dock をクリックします。
Scene dock は下図の場所にあります。

Scene dock
メニューから Editor > Embed In > Navigation Controller を選択します。
下図のような状態になり Navigation Controller が組み込まれます。
Navigation Controller
Storyboard Entry Point が Navigation Controller になり、さらにそこから Meal List Scene へ 矢印が繋がれました。
この矢印は Relationship といい、二つの Controller の関係を表します。
今回は Meal List Scene が Navigation Controller の Root View Controller になったことを表しています。

Navigation Controller は ViewController の遷移を管理します。
Navigation Controller が作成された時に最初に表示する ViewController を Root View Controller といいます。

また、 Meal List Scene の上部に Navigation Bar が追加されたのもわかります。

Navigation Bar が追加された
Navigation Controller は基本的に Navigation Bar を持っており、ここに現在の画面が何であるかを表すラベルや、 前の画面に戻るためのコントロールを備えています。
そのため Navigation Controller と関連付けられた ViewController は Navigation Bar を持つようになります。

ここまでできたらシミュレーターで実行をしてみましょう。
下図のように Navigation Bar がついた Meal List Scene が表示されます。

Navigation Bar がついた Meal List scene
【実習】Navigation Bar を設定しよう
Navigation Bar には現在表示されている ViewController のタイトルを表示することができます。
また Navigation Bar の左右にはボタンを設置できます。
それぞれの ViewController は navigationItem プロパティを持っており、これで Navigation Bar の 表示を ViewController ごとに切り替えることができます。

InterfaceBuilder にてこれらを設定できるので早速やっていきましょう。

Main.storyboard を開き、 Meal List Scene を選択します。

Navigation Bar をクリックします。
Navigation Bar が選択された状態
Attributes inspector を開き、Title に Your Meals と入力して return を押します。
Navigation Bar に title を設定
Library のfilter に bar button item と入力して Bar Button Item Object を探します。
Bar の右側にドラッグ&ドロップします。
Bar Button Item の設置
  ボタンを追加できました。どのような動作をするボタンなのかわかりやすくするためにこのボタンを設定しましょう。

ボタンを選択し、 Attributes inspector を開きます。
Bar Button Item の System Item のプルダウンから Add を選択します。
  ボタンの見た目が + に変わります。

+ の見た目
  システムであらかじめ用意されているボタンの種類については UIBarButtonSystemItem を参照してください。

ここまでできたらシミュレーターで実行してみましょう。
Navigation Bar にタイトルとボタンがつきました。

ボタンを押しても何も起きません。
次に、このボタンを押したら Meal Detail Scene に遷移するよう設定していきましょう。

先ほど追加した + ボタンを選択します。

control ⌃ +ドラッグで Meal Detail Scene へドラッグ&ドロップします。

すると Action Segue のポップアップが現れます。これは + ボタンを押した際にどのような動作で遷移するかの選択になります。

Show を選択します。

Show を選択
すると下図のように Meal List と Meal Detail が繋がれます。

Meal List と Meal Detail が繋がれる
また、ここで選択できる Action Segue と動作を以下にまとめます。

Action Segue	動作
Show	新しい Scene を Navigation のスタックに積む
Show Detail	Detail View に分かれている場合に Detail View を置き換える
Present Modally	画面に覆いかぶさるように新しい Scene を表示する
Present as Popover	画面の一部に Modal を表示する
Custom	自作の遷移方法にする
ここまでできたらシミュレーターで実行してみましょう。
Meal List にて Navigation Bar の + ボタンを押すと画面が Meal Detail へ遷移します。
また Meal Detail の画面では Navigation Bar に戻るボタンが現れます。
Show Segue ではこのように自動的に前の画面へ戻るボタンが Navigation Bar に出現します。
戻るボタンを押すと Meal List に戻ります。

Show Segue での動きは プッシュ と呼ばれます。
プッシュナビゲーションはユーザが選択したものに関する詳細情報を表示する際に使用します。
今回のように、新しいアイテムを追加する画面を表示するのには向いていません。
新しいアイテムを追加するというのは独立した動作になります。
これを表すのに適切なのは Modal Segue になります。
また Modal Segue は モーダル と呼ばれます。

先ほど作成した Show Segue を変更してみましょう。
また、 Segue に Identifier を設定しましょう。
これは後ほど、コードで遷移させる際に使用します。

先ほど作成した Segue を選択します。
Segue
Attributes inspector の Kind を Present Modally に変更します。
Identifier を AddItem に変更します。
Segue の Attributes 設定
モーダルは Navigation Controller にスタックされません。
Meal Detail Scene に Navigation Bar をつけるには、新たに Navigation Controller を組み込む必要があります。
以下の手順で組み込んでみましょう。

Meal Detail Scene の Scene dock をクリックします。
メニューから Editor > Embed In > Navigation Controller を選択します。
すると下図のように、 Meal List Scene と同じように Navigation Controller が作成され、 今度は Meal Detail Scene が Root View Controller となりました。

Root View Controller
この時に表示がおかしいようであれば、表示を更新する必要があります。
Meal Detail Scene に制約のワーニングが出ているなら画面右下の更新ボタンを押して再描画させましょう。

次に、新しくできた Navigation Bar にタイトルとボタンを追加していきます。
ボタンは 2 つで、キャンセルと保存ができるものにします。

Meal Detail Scene の Navigation Bar をダブルクリックします。
Navigation Bar の中央をダブルクリック
タイトルが編集できるようになるので、 New Meal と入力し return を押します。そうすると Scene の名前も New Meal Scene に変わるかと思います。
Library から Bar Button Item を選択し、 Navigation Bar の左側にドラッグ&ドロップします。
ボタンを選択し、 Attributes inspector を開いて System Item から Cancel を選択します。
再び Library から Bar Button Item を選択し、 Navigation Bar の右側にドラッグ&ドロップします。
ボタンを選択し、 Attributes inspector を開いて System Item から Save を選択します。
以下のようになります。

ナビゲーションバーの設定
ここまでできたらシミュレーターで実行してみましょう。
+ ボタンを押すと New Meal Scene が下から覆いかぶさるように出現します。
先ほどと異なり、戻るボタンの代わりに Cancel と Save ボタンが Navigation Bar に表示されています。

これらのボタンを押しても何も起きません。
Cancel を押したら画面が閉じ、 Save を押したら Meal List に登録できるようにアクションを設定する必要があります。
UI とコードをつなぎ、その処理を実装していきましょう。

【実習】新しいデータを保存する準備をしよう
New Meal Scene で各項目を入力し、 Save ボタンを押したら、その食事データが Meal List Scene に反映されるようにします。
MealDetailViewController で Meal オブジェクトを作成し、 MealTableViewController にそのオブジェクトを渡す、という実装をしていきましょう。

まずは MealDetailViewController に Meal 型のプロパティを追加します。

MealDetailViewController.swift を開きます。
プロパティ宣言の、 ratingControl の下に以下のコメントとプロパティを書きます。
/*
This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
or constructed as part of adding a new meal.
*/
var meal: Meal?

Optional の Meal 型として meal プロパティを宣言します。
Optional なのは初期化が失敗する場合があり、その場合に nil になることを示しています。

次に、 Save ボタンとコードを繋ぎます。

Main.storyboard を開きます。
Editor のプルダウンメニューから Assistant をクリックして Assistant editor を開きます。
画面が狭い場合は Navigator, Utility を非表示にしておきましょう。
Save ボタンを選択します。
MealDetailViewController.swift が右画面に表示されていることを確認します。表示されていない場合は Add Editor on Right ボタンをクリックして出した画面で MealDetailViewController.swift を表示しましょう。
エディタ追加ボタン
Save ボタンから control ⌃ を押しながら ratingControl の Outlet の下までドラッグ&ドロップをして Outlet を作成します。
Save をドラッグ
名前を saveButton にします。
他の要素はデフォルトのまま（下図）にします。
名前を `saveButton` に設定
Connect をクリックします。
これで Save ボタンをコードと繋ぐことができました。

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!

もし Connect を押した時に以下の図のようなエラーが出てうまくできない場合は

Connect を押した時にエラーが出る場合
MealDetailViewController.swift の @IBOutlet weak var ratingControl: RatingControl! の下に @IBOutlet var saveButton: UIBarButtonItem! を追加して以下のように先に書き

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!

Save ボタンから control ⌃ を押しながら saveButton: UIBarButtonItem! へドラッグ&ドロップをして Outlet を接続してください。

Connect Outlet
【実習】戻るための Segue を作成しよう
Save ボタンを押して Meal オブジェクトを MealTableViewController に渡すか、 Cancel ボタンを押して変更をやめた場合に New Meal Scene を閉じて Meal List Scene に戻る必要があります。

これを達成するために Unwind Segue を使用します。
Unwind Segue とは現在の一つ前の Scene に戻る Segue のことです。
通常の Segue では ViewController のインスタンスを生成しますが、 Unwind Segue ではすでにあるインスタンスに戻るという動作をします。

Storyboard で設定された Segue が実行される際はいつでも prepare(for:sender:) メソッドが呼ばれます。
そしてその際にデータを遷移先に受け渡すことができます。

MealDetailViewController にて prepare(for:sender:) メソッドを実装しましょう。

まず、 Editor area のプルダウンメニューから Show Editor Only をクリックして Standard editor に戻しましょう。
Navigator, Utility area が出ていない場合は出しておきましょう。

次に MealDetailViewController.swift を開き、import UIKit の下の行に以下の行を追加します。

import os.log

これはログシステムをインポートしています。　print() 関数のようにログ出力を行うものです。

MealDetailViewController.swift の // MARK: Actions セクションの上に以下のコメントを追加します。

// MARK: Navigation

このセクションはナビゲーションに関連するメソッドをまとめておくセクションです。

このセクションに prepare(for:sender:) メソッドを宣言します。コメントも書きます。

// This method lets you configure a view controller before it's presented.
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
}

prepare と入力すると Xcode がいろいろなメソッドをサジェストしてくれるので、そこから選択をすると タイピングを少なく済ませることができます。

まずこのメソッド内の先頭でスーパークラスのメソッドを呼びます。

super.prepare(for: segue, sender: sender)

オーバーライドしたメソッドは、そのままではスーパークラスの実装を引き継ぎません。
スーパークラスの挙動に追加してカスタムしたい場合はスーパークラスのメソッドを呼ぶことで スーパークラスの実装をサブクラスでも利用できるようになります。

この下に以下のコードを追加しましょう。

// Configure the destination view controller only when the save button is pressed.
guard let button = sender as? UIBarButtonItem, button === saveButton else {
    os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
    return
}

この guard 文は引数の sender がボタンであるか、また === 演算子を使ってそのボタンが saveButton と同一であるかを判定しています。=== 演算子は、比較する 2 つのオブジェクトが同じものを指していた場合に true を返す演算子です。詳細は、Apple のドキュメントを参照してください。
もしも sender がボタンでなかったり、ボタンであっても saveButton でなかった場合はログ出力をしてリターンします。

guard 文の下に以下のコードを書きます。

let name = nameTextField.text ?? ""
let photo = photoImageView.image
let rating = ratingControl.rating

このコードは現在の Text Field のテキスト、 Image View の画像、 RatingControl のレーティングから 定数を宣言しています。

name の行に ?? という演算子があります。
これは nil結合演算子 といい、オプショナル型が nil でなければ左側の値をアンラップしたものを、 nil ならば右側の値を返すものです。
コードで表すと以下と同様の動作になります。

let name: String
if let unwrappedName = nameTextField.text {
  name = unwrappedName
} else {
  name = ""
}

次に、これらの定数を使って Meal オブジェクトの生成を試みます。

// Set the meal to be passed to MealTableViewController after the unwind segue.
meal = Meal(name: name, photo: photo, rating: rating)

ここで思い出して欲しいのが、 Meal の初期化関数は失敗する可能性があるということです。
その条件は、

名前が空文字だった場合
レーティングが 0 から 5 の範囲外だった場合
でした。

ここまでで、 prepare(for:sender:) メソッド全体は以下のようになっています。

// This method lets you configure a view controller before it's presented.
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    // Configure the destination view controller only when the save button is pressed.
    guard let button = sender as? UIBarButtonItem, button === saveButton else {
        os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
        return
    }

    let name = nameTextField.text ?? ""
    let photo = photoImageView.image
    let rating = ratingControl.rating

    // Set the meal to be passed to MealTableViewController after the unwind segue.
    meal = Meal(name: name, photo: photo, rating: rating)
}

次にアクションメソッドを実装します。
これは MealTableViewController に実装をします。
Unwind Segue 作成のためのアクションメソッドは、遷移先の ViewController (Destination View Controller といいます)に実装します。

このメソッドでは、 MealViewController で作成された新しい Meal オブジェクトを MealTableViewController に追加し反映することを行います。

まず、 MealTableViewController.swift を開きましょう。

// MARK: Private Methods セクションの上に以下のコメントを追加します。

// MARK: Actions

このセクションに以下のメソッドを宣言します。

@IBAction func unwindToMealList(sender: UIStoryboardSegue) {

}

このメソッドに中に以下のコードを追加します。

if let sourceViewController = sender.source as? MealDetailViewController, let meal = sourceViewController.meal {

}

引数の Segue は二つの ViewController をプロパティとして持っています。
それは source と destination です。
source は遷移元の ViewController 、 destination は遷移先の ViewController を指します。

if let 文では複数の let を宣言することができます。
その場合、後で宣言される let では前で宣言された定数を使用することができます。
let meal = sourceViewController.meal は、前の let sourceViewController = sender.source as? MealViewController の sourceViewController が束縛できた時に実行されるため、判定文に sourceViewController を使えるというわけです。

つまりこの if 文は、遷移元の ViewController が MealViewController にダウンキャストでき、そのプロパティの meal が nil でない場合に 中のブロックが実行されることになります。

そのブロックに以下のコードを追加します。

// Add a new meal.
let newIndexPath = IndexPath(row: meals.count, section: 0)

これは新しいデータを Table View に挿入する場所を指定しています。
row は 0 から meals.count-1 まで存在しているので末尾に新しいデータを挿入することになります。

次に、データを meals の末尾に追加します。

meals.append(meal)

append(_:) は配列の末尾に要素を追加するメソッドです。

次に、 Table View に行を追加します。
追加箇所は IndexPath で指定します。
ここでは先ほど宣言した newIndexPath を追加します。

tableView.insertRows(at: [newIndexPath], with: .automatic)

insertRows(at:with:) メソッドを使用します。
第一引数は IndexPath の配列なので、 [newIndexPath] と配列で渡します。
第二引数は挿入時のアニメーションを指定します。
UITableViewRowAnimation 型が指定できます。
今回は UITableViewRowAnimation.automatic を指定しています。

これで unwindToMealList(sender:) メソッドができました。
全体は以下のようになっています。

@IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? MealDetailViewController, let meal = sourceViewController.meal {
        // Add a new meal.
        let newIndexPath = IndexPath(row: meals.count, section: 0)

        meals.append(meal)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}

このメソッドは IBAction 属性をつけて宣言をしました。
InterfaceBuilder と紐付けられるメソッドなので、早速紐付けていきましょう。

Main.storyboard を開き、 New Meal Scene の Save ボタンを選択します。

control ⌃ +ドラッグをして Exit item と繋ぎます。Exit item は Scene dock にあります（下図を参照してください）。

Exit item でドロップ
Action Segue のメニューが現れるので、 unwindToMealListWithSender: を選択します。
これで Save ボタンを押すと unwindToMealList(sender:) アクションメソッドが呼ばれるようになります。
unwindToMealListWithSender: が選択できない場合はメソッドの宣言が正しいかを確認してください。

@IBAction func unwindToMealList(sender: UIStoryboardSegue)

ここまでできたらシミュレーターで実行してみましょう。

以下の手順を実行して unwindToMealList(sender:) が動作しているかを確認しましょう。

Meal List Scene で + ボタンを押します。
New Meal Scene が現れます。
Save ボタンを押します。
Meal List Scene に戻ります。
Meal List Scene で + ボタンを押します。
New Meal Scene が現れます。
Text Field に何らかの入力をします。
Image View をタップして写真を選択します。
レーティングを選択します。
Save ボタンを押します。
Meal List Scene に戻ります。
先ほど入力した食事が Meal List に追加されていることを確認します。
【実習】ボタンの状態を制御しよう
先ほどの動作確認で、何も Text Field に入力されていなくても Save ボタンを押せることがわかっています。
しかしその場合は新しいデータは作成されず、 Meal List Scene は元のままになっています。
これは Meal オブジェクトの初期化に失敗しているからです。

今のままの動作では問題があります。
ユーザは保存したつもりでも保存されていないことになるからです。
Save できない場合がわかってるならば Save できない場合にはボタンを押せなくすることでこれを防げます。
早速修正をしていきましょう。

MealDetailViewController.swift を開き、 // MARK: UITextFieldDelegate セクションを探します。

このコードブロックの中に以下のデリゲートメソッドを宣言します。

func textFieldDidBeginEditing(_ textField: UITextField) {
}

textFieldDidBeginEditing(_:) は Text Field が編集され始めた時またはキーボードが出現した場合に 呼ばれるメソッドです。
これに以下のコメントとコードを加えます。

// Disable the Save button while editing.
saveButton.isEnabled = false

これで、テキストを編集し始める時またはキーボードが出現した場合に Save ボタンを押せなくなりました。

続いて、func textFieldDidBeginEditing(_ textField: UITextField) の定義の直後に、以下のコメントを追加してプライベートメソッドを実装していきます。

// MARK: Private Methods

以下のプライベートメソッドを実装します。

private func updateSaveButtonState() {
    // Disable the Save button if the text field is empty.
    let text = nameTextField.text ?? ""
    saveButton.isEnabled = !text.isEmpty
}

これは Text Field が空文字であれば Save ボタンを押せなくし、空文字でなければ Save ボタンを押せるようにするメソッドです。

これを textFieldDidEndEditing(_:) から呼びます。
現在このメソッドは何もない状態なので、以下の二行を加えます。

updateSaveButtonState()
navigationItem.title = textField.text

navigationItem.title = textField.text で、 Navigation Bar のタイトルを食事名に変更しています。

全体は以下のようになります。

// MARK: UITextFieldDelegate
extension MealDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }

    // MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

これでテキストを編集し始めたら Save ボタンが押せなくなり、編集が終われば押せるかの判定を行うようになりました。
次に初期状態を設定します。
ViewController の初期状態は viewDidLoad() で設定します。

今、 viewDidLoad() は以下のようになっています。

override func viewDidLoad() {
    super.viewDidLoad()

    // Handle the text field’s user input through delegate callbacks.
    nameTextField.delegate = self
}

ここの最後で updateSaveButtonState() を呼びます。コメントも書きます。

// Enable the Save button only if the text field has a valid Meal name.
updateSaveButtonState()

先ほど updateSaveButtonState() を private のアクセス修飾子をつけて実装しました。
アクセス修飾子をつけた型、プロパティ、メソッドはアクセス領域を制限させられます。
updateSaveButtonState() メソッドは ViewController 以外から呼ぶ必要がないため、 private をつけました。

アクセスレベルに応じて以下のアクセス修飾子が用意されています。

アクセス修飾子	役割
private	同じクラス以外からはアクセスできない
fileprivate	同じファイル内でしかアクセスできない
internal	同じモジュール内でしかアクセスできない
public	外のモジュールからアクセスできるがオーバーライドできない
open	外のモジュールからアクセスでき、オーバーライドもできる
アクセスレベルは適切に設定すべきです。

ここまでできたらシミュレーターを実行して動作確認をしましょう。

Meal List Scene で + ボタンを押します。
New Meal Scene が現れます。
Save ボタンが押せない状態になっていることを確認します。
Text Field に文字を入力し、キーボードを閉じます。
Save ボタンが押せる状態になり、 Navigation Bar のタイトルが変更されていることを確認します。
【実習】データ入力をキャンセルしよう
Save ボタンの挙動を正しく実装できたので、次は Cancel ボタンの挙動を実装しましょう。
Cancel ボタンを押したら New Meal Scene を閉じるようにします。
IBAction を設定していきましょう。

Storyboard とコードの作業になるので、 Xcode の Editor area のプルダウンメニューから Assistant を選択して Assistant editor を開きます。
そして左側に Main.storyboard と右側に MealDetailViewController.swift を開きます。

New Meal Scene の Cancel ボタンを選択します。

control ⌃ を押しながら // MARK: Navigation コメントの下にドラッグ&ドロップします。

するとダイアログが現れるので Connection を Action に変更します。
Name を cancel に、Type を UIBarButtonItem にします。
下図の状態を確認してください。

cancel のアクションメソッドを作成
ここまでできたら Connect をクリックします。

すると以下のようにアクションメソッドが作成されます。

@IBAction func cancel(_ sender: UIBarButtonItem) {
}

もしエラーが出てうまく設定できない場合は、先に上記のアクションメソッドを MealDetailViewController.swift に書き、そこに Connect するようにドラッグ&ドロップします。

次にこのメソッドに次の一行を書きます。

dismiss(animated: true, completion: nil)

dismiss(animated:completion:) メソッドはモーダルを閉じるメソッドです。
引数には閉じる際にアニメーションをするかどうか、閉じ終わった後に行う処理を指定します。

この場合は遷移が発生しますが prepare(for:sender:) は呼ばれません。
そのためデータの追加は行いません。

cancel(_:) アクションメソッド全体は以下のようになっています。

@IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
}

ここまでできたらシミュレーターで実行してみましょう。

+ ボタンを押して New Meal Scene を表示させます。
Cancel ボタンを押します。
Meal List Scene に戻り、新しくデータが追加されていないことを確認します。
今回はここまでです。
Navigation Controller を使いどのようにプッシュで遷移させるのかを学びました。
またどのようにモーダルで遷移させるのかを学びました。
Navigation を戻る際に Unwind Segue を使ってデータを異なる ViewController に渡すこともできました。

次回はデータを編集、削除することを学んでいきます。

今回のプロジェクトは こちら です。

まとめ
Navigation Controller を使って画面遷移できる
画面間に関係が薄い場合はモーダルで遷移させる
Unwind Segue を使って遷移先の ViewController にデータを渡せる
お疲れさまでした！
学習したことをSNSで報告しよう！



---
## リンク

[Scene](https://developer.apple.com/documentation/swiftui/scene)

[UIBarButtonItem.SystemItem](https://developer.apple.com/documentation/uikit/uibarbuttonitem/systemitem)

[prepare(for:sender:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/prepare(for:sender:))

[===(_:_:)](https://developer.apple.com/documentation/swift/===(_:_:))

[append(_:)](https://developer.apple.com/documentation/swift/array/append(_:))

[dismiss(animated:completion:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/dismiss(animated:completion:))
