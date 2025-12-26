データを操作しよう

前回までで「フードトラッカー」アプリで UI の作成と遷移を作成して、アイテムの一覧と新規データの追加を行えるようになりました。
今回はデータの編集、削除と永続化を行い、データ管理に必要なものを実装していきます。
いよいよ今回の学習を終えると「フードトラッカー」アプリが完成します。

今回の環境は、

macOS Big Sur 11.4
Xcode 12.5.1 (12E507)
です。

前回までに作成したプロジェクトは こちら です。

目次
【実習】データを編集しよう
編集用の Segue を作成しよう
【実習】データの編集をキャンセルしよう
【実習】データの削除をしよう
データを削除しよう
【実習】データの永続化をしよう
オブジェクトを保存可能な形式に変換しよう
Meal List を保存・読み込みしよう
まとめ
【実習】データを編集しよう
今まで作成してきた「フードトラッカー」アプリは、一度食事データを登録したらそれまでで、後からデータを編集することができません。
これでは名前を間違えた場合やレーティングを後から変更したい場合、また写真を差し替えたい場合に対応できません。
データを編集できるように編集用の Segue の作成とデータの再代入を行っていきます。

編集用の Segue を作成しよう
編集画面へは Table View のセルをタップしたら遷移できるようにします。
編集画面は新しい画面のようですが、 New Meal Scene を使用すればよいです。
New Meal Scene の各項目に最初からデータを入れた状態で表示するようにします。

以下の手順で Segue を作成しましょう。

もし Assistant editor モードになっているなら Standard ボタンを押して Standard editor にします。
Main.storyboard を開き、 Meal List scene の MealTableViewCell を選択します。
control ⌃ を押しながら New Meal Scene へドラッグ&ドロップします。
セルのドラッグ
Segue を選択するポップアップが現れます。
Show を選択します。すると Segue が作成されます。
Navigation Controller に線が重なっているので Navigation Controller を下にドラッグして見やすくします。場合に応じて倍率を調節してください。下図を参考にしてください。
倍率の調節
今作成した Segue を選択します。
Segue の選択
Attributes inspector にて Storyboard Segue の Identifier を ShowDetail に変更し return を押します。
これでセルをタップしたら New Meal Scene へプッシュ遷移するようになりました。
最後に Identifier を設定したのは後ほどこの遷移を prepare(for:sender:) で処理できるようにするためです。

ここまでできたらシミュレーターで実行してみましょう。
Meal List scene でセルをタップしたら右から New Meal Scene が覆いかぶさるように出現します。

しかしこのままでは問題もあります。
Meal List scene にて + ボタンを押した時と全く同じ登録画面が現れたことです。

prepare(for:sender:) にて遷移前に処理を行いましょう。
先ほど Segue の Identifier を設定したことがここで役に立ちます。

まずは MealTableViewController.swift を開きます。

ファイル先頭の import UIKit の下にログシステムをインポートします。

import os.log

prepare(for:sender:) メソッドを探します。
// MARK: - Navigation セクションにあり、現在はコメントアウトされています。
このコメントアウトを外します。

// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
}

テンプレートのコメントが入っているのでこれを削除します。
そしてメソッドの先頭でスーパークラスのメソッドを呼びます。

super.prepare(for: segue, sender: sender)

その後に以下の switch 文を書きます。

switch segue.identifier ?? "" {

}

switch 文は与えられた値をパターンマッチにより行う処理を変える際に使用します。
segue.identifier の型は Optional<String> で nil になりえます。
しかし今回 nil の場合は想定していないので nil 結合演算子により nil の場合は空文字に変換して String 型を switch 文に渡しています。

現在 Segue の Identifier としては Meal List scene で + ボタンを押した際の AddItem そして今追加したセルからの遷移の ShowDetail があります。
それぞれのケースの処理を実装していきましょう。

まずは AddItem のケースを書きます。

case "AddItem":
    os_log("Adding a new meal.", log: .default, type: .debug)

Meal List scene では新しくデータを追加する場合の New Meal Scene に影響を与えません。
そのためログ出力を行うだけです。

次に ShowDetail のケースを書きます。

case "ShowDetail":
    guard let mealDetailViewController = segue.destination as? MealDetailViewController else {
        fatalError("Unexpected destination: \(segue.destination)")
    }

    guard let selectedMealCell = sender as? MealTableViewCell else {
        fatalError("Unexpected sender: \(String(describing: sender))")
    }

    guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
        fatalError("The selected cell is not being displayed by the table")
    }

    let selectedMeal = meals[indexPath.row]
    mealDetailViewController.meal = selectedMeal

guard 文が並んでいますが、ここで行いたい処理は最後の二行です。
meals から現在選択したセルのモデルを取得し、遷移先の mealDetailViewController の meal プロパティに代入することです。

最初の guard 文は、遷移先の ViewController を MealDetailViewController にダウンキャストしています。
ShowDetail の Segue は Meal List scene から New Meal Scene への遷移なのでダウンキャストできない場合は想定していません。
そのため、もし起こった場合は fatalError() でアプリを強制終了させるようにしています。

次の guard 文は sender を MealTableViewCell にダウンキャストしています。
sender は Segue の起点となったオブジェクトが渡されます。
ShowDetail は Meal List のセルをタップした場合なのでダウンキャストできない場合は想定していません。
その場合は同じく fatalError() を呼んでいます。

また、この fatalError() で sender を文字列に展開する部分は String(describing:) で囲われています。 文字列を展開する部分は Optional にできないため、 Optional 型を String 型に変換をしています。

最後の guard 文は Table View にモデルを渡してそのモデルがある indexPath を取得しています。
selectedMealCell は選択されたセルのオブジェクトなので必ず Table View に存在するオブジェクトです。
そのため取得できない場合は想定していません。
取得できない場合は fatalError() を呼んでいます。

これですべての Segue を網羅できましたが、 switch 文ではコンパイルエラーが出ています。
switch 文では与えられる値をすべて網羅しなければいけません。
つまり今回は String 型の取りうる値を網羅するということです。
もちろん一つずつケースを書く必要はないので、想定していないものはデフォルトケースとします。

default:
    fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

これで switch 文が完成し、Segue を処理できるようになりました。
もしも新しく Segue が増えた場合はデフォルトケースが実行され強制終了するようになるのでそのメッセージを読んで ケースを追加することになります。

prepare(for:sender:) 全体は以下のようになっています。

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    switch segue.identifier ?? "" {
    case "AddItem":
        os_log("Adding a new meal.", log: .default, type: .debug)
    case "ShowDetail":
        guard let mealDetailViewController = segue.destination as? MealDetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }

        guard let selectedMealCell = sender as? MealTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }

        guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }

        let selectedMeal = meals[indexPath.row]
        mealDetailViewController.meal = selectedMeal
    default:
        fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
    }
}

MealDetailViewController にも修正を加える必要があります。
それは ViewController の生成時にデータを入れる処理がないため、遷移時にデータを渡しても表示しないからです。

MealDetailViewController.swift を開き、 viewDidLoad() メソッドを探します。

override func viewDidLoad() {
    super.viewDidLoad()

    // Handle the text field’s user input through delegate callbacks.
    nameTextField.delegate = self

    // Enable the Save button only if the text field has a valid Meal name.
    updateSaveButtonState()
}

nameTextField.delegate = self の行の下に以下のコードを追加しましょう。

// Set up views if editing an existing Meal.
if let meal = meal {
    navigationItem.title = meal.name
    nameTextField.text   = meal.name
    photoImageView.image = meal.photo
    ratingControl.rating = meal.rating
}

ViewController のロード時に meal が nil でなければあらかじめ各オブジェクトに値を入れておきます。
nil でない場合は ShowDetail で遷移した場合で、 nil の場合は AddItem で遷移した場合です。
このように、この if let でどちらの場合も正しい表示にできました。

viewDidLoad() 全体は以下のようになっています。

override func viewDidLoad() {
    super.viewDidLoad()

    // Handle the text field’s user input through delegate callbacks.
    nameTextField.delegate = self

    // Set up views if editing an existing Meal.
    if let meal = meal {
        navigationItem.title = meal.name
        nameTextField.text   = meal.name
        photoImageView.image = meal.photo
        ratingControl.rating = meal.rating
    }

    // Enable the Save button only if the text field has a valid Meal name.
    updateSaveButtonState()
}

ここまでできたらシミュレーターで実行してみましょう。
Meal List scene でアイテムを選択するとその情報が入った New Meal Scene へ遷移します。
しかし、情報を変更して Save を押すと更新される代わりに新しくデータが追加されてしまいます。
次はここを修正しましょう。

すでに存在するデータを更新するには unwindToMealList(sender:) アクションメソッドを修正する必要があります。
アクションメソッドの中で、新しいデータを追加するかすでに存在するデータを更新するかを分岐処理することになります。

MealTableViewController.swift を開き、 unwindToMealList(sender:) メソッドを探します。
現在は以下のようになっています。

@IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? MealDetailViewController, let meal = sourceViewController.meal {
        // Add a new meal.
        let newIndexPath = IndexPath(row: meals.count, section: 0)

        meals.append(meal)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}

この if 文の中の先頭に以下の if 文を追加します。

if let selectedIndexPath = tableView.indexPathForSelectedRow {

}

このコードは Table View のどのセルが選択されたのかをチェックしています。
データの編集ならばセルを選択してから遷移するため、 indexPathForSelectedRow は nil になりません。
新規追加ならば + ボタンを押して遷移するため indexPathForSelectedRow は nil になります。
つまり、この if 文でこの遷移が新規追加か編集かを判定しています。

この if 文中に以下のコードを書きます。

// Update an existing meal.
meals[selectedIndexPath.row] = meal
tableView.reloadRows(at: [selectedIndexPath], with: .none)

これは実際に編集を反映させている箇所です。

meals[selectedIndexPath.row] = meal で選択された位置のデータを更新し、 tableView.reloadRows(at: [selectedIndexPath], with: .none) で Table View の表示を 更新しています。

次に else 節を書きます。
else 節の中身はすでに書かれているものになります。

else {
    // Add a new meal.
    let newIndexPath = IndexPath(row: meals.count, section: 0)

    meals.append(meal)
    tableView.insertRows(at: [newIndexPath], with: .automatic)
}

else { とタイプし、下の行までカーソルを持って行き } をタイプします。
するとインデントが揃わないので、 else 節全体を選択して control ⌃ + I を押すとインデントが整理されます。

このコードブロックではデータの新規追加を行っています。

unwindToMealList(sender:) 全体は以下のようになっています。

@IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? MealDetailViewController, let meal = sourceViewController.meal {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Update an existing meal.
            meals[selectedIndexPath.row] = meal
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            // Add a new meal.
            let newIndexPath = IndexPath(row: meals.count, section: 0)

            meals.append(meal)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}

ここまでできたらシミュレーターで実行してみましょう。
以下の手順で動作確認を行います。

セルを選択して New Meal Scene に遷移します。
何かデータの編集を行ってから Save ボタンを押します。
Meal List scene に戻り、データが更新されていることを確認します。
【実習】データの編集をキャンセルしよう
ユーザは Save ボタンを押さなくとも編集をやめることができるようにします。
具体的には Cancel ボタンを押したら編集画面から戻るようにします。

現在の画面から戻る操作では、現在の画面がどのような方法で表示されているかに依存します。
そのため Cancel ボタンを押した時にその方法を判定し、方法にあった適切なメソッドを呼んで戻るようにします。

MealDetailViewController.swift を開き、 cancel(_:) アクションメソッドを探します。

@IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
}

dismiss(animated:completion:) はモーダルで表示した場合に戻るメソッドです。
編集画面ではプッシュで表示されるので、それを判定してプッシュを閉じるメソッドを呼ぶように修正します。

このメソッド内の先頭に以下のコードを書きます。

// Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
let isPresentingInAddMealMode = presentingViewController is UINavigationController

これは現在どのような方法（モーダルかプッシュか）で表示されているのかを判定するのに使用する定数です。
presentingViewController が UINavigationController であるかの Bool を取得します。
presentingViewController はオプショナルで、 nil でない場合はモーダルで遷移していることを表します。
また、遷移元の ViewController は UINavigationController になるため、この判定文でモーダルかプッシュかを 判定できます。

モーダルならば dismiss(animate:completion:) を呼びます。

if isPresentingInAddMealMode {
    dismiss(animated: true, completion: nil)
}

プッシュならば popViewController(animated:) を呼びます。

else if let owingNavigationController = navigationController {
    owingNavigationController.popViewController(animated: true)
}

それ以外の場合は想定していないので fatalError(_:) を呼びます。

else {
    fatalError("The MealDetailViewController is not inside a navigation controller.")
}

この else 節はなくても問題はないですが、今後変更があった際に fatalError となり未実装の部分を 把握できるのであったほうが保守性が上がります。

アクションメソッド全体は以下になります。

@IBAction func cancel(_ sender: UIBarButtonItem) {
    // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
    let isPresentingInAddMealMode = presentingViewController is UINavigationController

    if isPresentingInAddMealMode {
        dismiss(animated: true, completion: nil)
    } else if let owingNavigationController = navigationController {
        owingNavigationController.popViewController(animated: true)
    } else {
        fatalError("The MealDetailViewController is not inside a navigation controller.")
    }
}

ここまでできたらシミュレーターで実行してみましょう。
Meal List scene でセルを選択し、遷移先で Cancel ボタンを押しましょう。
また、同じく Meal List scene で + ボタンを押し、遷移先で Cancel ボタンを押しましょう。
どちらも画面が閉じて前の画面に戻ることを確認してください。

プッシュとモーダルの遷移方法を表にまとめます。

プッシュ	モーダル
開くメソッド	pushViewController(_:animated:)	present(_:animated:completion:)
閉じるメソッド	popViewController(animated:)	dismiss(animated:completion:)
プッシュは UINavigationController のメソッドで、モーダルは UIViewController のメソッドです。
行いたい遷移によってこれらのメソッドを使い分けましょう。

【実習】データの削除をしよう
次に、ユーザがアイテムを間違えて登録してしまった場合や必要ないと思った場合に削除できるようにします。
Meal List の Table View を編集モードにし、そこでセルを削除できるようにします。

まずは Navigation Bar に編集モードに移行するためのボタンを追加しましょう。

MealTableViewController.swift を開き、 viewDidLoad() を探します。

override func viewDidLoad() {
    super.viewDidLoad()

    // Load the sample data.
    loadSampleMeals()
}

super.viewDidLoad() の下に次のコードを追加します。

// Use the edit button item provided by the table view controller.
navigationItem.leftBarButtonItem = editButtonItem

editButtonItem は編集モードに入るためのあらかじめ用意された UIBarButtonItem です。
これを Navigation Bar の左側に追加しました。

viewDidLoad() 全体は以下のようになっています。

override func viewDidLoad() {
    super.viewDidLoad()

    // Use the edit button item provided by the table view controller.
    navigationItem.leftBarButtonItem = editButtonItem

    // Load the sample data.
    loadSampleMeals()
}

ここまでできたらシミュレーターで実行してみましょう。
Navigation Bar の左側に Edit ボタンが追加されています。
これを押すと編集モードに入ります。

Edit ボタン
しかし Delete を押してもセルは消えません。
これはまだ削除のロジックを実装していないからです。

データを削除しよう
Table View の編集時にはデリゲートメソッドが呼ばれます。
tableView(_:commit:forRowAt:) と tableView(_:canEditRowAt:) を使用します。

まずは tableView(_:commit:forRowAt:) のコメントアウトを外しましょう。

// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
}

// Delete the row from the data source のコメントの下に以下のコードを挿入します。

meals.remove(at: indexPath.row)

これは indexPath.row 番目のモデルを meals から削除しています。
この後、 tableView.deleteRows(at: [indexPath], with: .fade) で Table View にも反映させています。

次に tableView(_:canEditRowAt:) メソッドのコメントアウトを外しましょう。

// Override to support conditional editing of the table view.
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
}

また、 tableView(_:commit:forRowAt:) メソッド全体は以下のようになっています。

override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        meals.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
}

ここまでできたらシミュレーターで実行してみましょう。
Edit ボタンを押して編集モードに入り、セルの左のボタンを押すか左にスワイプして Delete ボタンを出し、 それをクリックします。
するとそのセルが削除されることを確認します。

セルの削除
これでデータの追加、編集、削除ができるようになりました。
遷移も網羅できています。
アプリとしての機能を一通り備えたように思えますが、まだ一つだけやるべきことがあります。
現在のままでは、アプリを終了して再び立ち上げるとデータが初期化されています。
アプリは継続して使用されるので、データの保存をする必要があります。

これからデータをアプリ内に保存してみましょう。

【実習】データの永続化をしよう
オブジェクトを保存可能な形式に変換しよう
データを保存するには NSCoding プロトコルを使用します。
NSCoding はオブジェクトや構造体を保存するための軽量な解決法です。

Meal オブジェクトを保存、読み込みをしましょう。

Meal オブジェクトにはプロパティがありますが、NSCoding はこれをキーと組み合わせてエンコード、デコードする方法をとります。
キーは単純な文字列になります。
どのような文字列かは実装によりますが、単純にプロパティ名と同じにしておきます。
例えば name プロパティに対応するキーは name という文字列にします。

実際にやってみましょう。
Meal.swift を開き、 // MARK: Properties セクションの下に以下の構造体を宣言します。

// MARK: Types

struct PropertyKey {

}

今回は PropertyKey 構造体に NSCoding で使用するキーをまとめておきます。
ここに以下のプロパティを宣言します。

static let name = "name"
static let photo = "photo"
static let rating = "rating"

これらのプロパティは Meal のプロパティと対応しています。
static キーワードはこのプロパティがこの構造体自身に所属しており、インスタンスではないことを表しています。
そのためアクセスする際は構造体名に続けてプロパティ名を書くことになります。
（例： PropertyKey.name）

PropertyKey 構造体全体は以下のようになっています。

struct PropertyKey {
    static let name = "name"
    static let photo = "photo"
    static let rating = "rating"
}

次に、 Meal クラスに　NSSecureCoding プロパティを継承させます。
NSSecureCoding は NSCoding を継承した、より安全性の高いクラスです。
NSCoding を継承するクラスは NSObject のサブクラスである必要があるので、それも加えます。

Meal.swift のクラス宣言は以下のようになっています。

class Meal {

これをまず NSObject のサブクラスにします。

class Meal: NSObject {

次に NSSecureCoding を継承させます。

class Meal: NSObject, NSSecureCoding {

親クラスはコロン (:) の直後に来る必要があるため、この順番が反対になるとコンパイルエラーになるので注意してください。

NSCoding プロトコルは実装しなければいけないメソッドがあります。

encode(with coder: NSCoder)
init?(coder: NSCoder)
encode(with:) メソッドはクラスの情報をデータ化するメソッドで、　init?(coder:) メソッドは 保存されたデータからクラスを作成する初期化関数です。

Meal クラスの末尾の波括弧 (}) の一行上に以下のコメントを書きます。

// MARK: NSCoding

その下に以下のメソッドを加えます。

func encode(with coder: NSCoder) {

}

このメソッドに以下のコードを書きます。

coder.encode(name, forKey: PropertyKey.name)
coder.encode(photo, forKey: PropertyKey.photo)
coder.encode(rating, forKey: PropertyKey.rating)

これでクラスのプロパティを保存する形に変換します。

次に保存したデータの読み込みをします。

まずはログ出力をするために、ファイルの上部に以下を書いて os.log をインポートします。

import os.log

encode(with:) メソッドの下に以下の初期化関数を追加します。

required convenience init?(coder coder: NSCoder) {

}

この初期化関数は ? がついているので失敗する可能性があることを示しています。
この中に以下のコードを書いてみましょう。

// The name is required. If we cannot decode a name string, the initializer should fail.
guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
    os_log("Unable to decode the name for a Meal Object.", log: OSLog.default, type: .debug)
    return nil
}

decodeObject(forKey:) メソッドは Any? 型を返すのでこれを String にダウンキャストしています。
キャストできない場合は変換失敗のログを出力して nil を返します。

次に以下のコードを追加します。

// Because photo is an optional property of Meal, just use conditional cast.
let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage

これは photo プロパティを読み込んでいます。
photo プロパティの型は UIImage? なのでそのまま変換をしています。

最後に rating プロパティを読み込みます。

let rating = coder.decodeInteger(forKey: PropertyKey.rating)

rating プロパティの型は Int なので Int を返す decodeInteger(forKey:) メソッドを使います。
これによりダウンキャストが発生せず guard 文を書かずに済みました。

最後に、これらの定数を使って Meal オブジェクトを生成します。

// Must call designated initializer.
self.init(name: name, photo: photo, rating: rating)

convenience キーワードがついた初期化関数は自身のクラスの初期化関数を呼ぶ必要があります。

init?(coder:) 初期化関数は以下のようになりました。

required convenience init?(coder coder: NSCoder) {
    // The name is required. If we cannot decode a name string, the initializer should fail.
    guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
        os_log("Unable to decode the name for a Meal Object.", log: OSLog.default, type: .debug)
        return nil
    }

    // Because photo is an optional property of Meal, just use conditional cast.
    let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage

    let rating = coder.decodeInteger(forKey: PropertyKey.rating)

    // Must call designated initializer.
    self.init(name: name, photo: photo, rating: rating)
}

これで NSCoding の実装すべきメソッドをすべて実装できたのでデータのエンコード・デコードができるようになりました。

NSSecureCoding の必須のプロパティも実装しておきましょう。
Meal クラスの末尾の波括弧 (}) の一行上に以下のコメントを書きます。

// MARK: NSSecureCoding

その下に以下のプロパティを加えます。

static var supportsSecureCoding: Bool = true

これで Meal クラスが NSSecureCoding に適合するようになりました。

次に、このエンコードしたデータを保存する場所を決めます。

// MARK: Properties セクションの下に以下のコードを追加します。

// MARK: Archiving Paths
static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")

DocumentsDirectory はアプリのドキュメントがあるディレクトリを指します。
そのためアプリごとに独立した記憶領域に保存されます。
より詳しく知りたければ FileManager のドキュメントを参照してください。
ArchiveURL はそれに　meals というパスを加えています。

これらのプロパティは static で宣言されているので、アクセスするときは Meal.ArchiveURL.path のようになります。
後ほど MealTableViewController にて保存・読み出しをするメソッドの引数にこのパスを渡して利用します。

ここまで出来たら command⌘　+　B を押してビルドし、問題がないことを確認しましょう。

Meal List を保存・読み込みしよう
MealTableViewController.swift を開きます。
// MARK: Private Methods セクションの末尾に以下のメソッドを加えます。

private func saveMeals() {

}

meals を保存するタイミングになったらこのメソッドを呼び出すようにします。
このメソッドには保存できる形式にした Meal オブジェクトを適切な場所に保存する処理を書きます。

guard let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false) else {
    fatalError("Unable to archive meals")
}

保存には NSKeyedArchiver を使用します。
archivedData(withRootObject:requiringSecureCoding:) メソッドは例外を投げますが、ここでは例外の内容に関わらず guard 文で例外処理したいので try? で例外を捨てています。

アーカイブしたデータをファイルに保存し、結果に対してログ出力をします。

do {
    try archivedData.write(to: Meal.ArchiveURL)
    os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
} catch {
    os_log("Failed to save meals...", log: OSLog.default, type: .error)
}

do-catch 文は Swift における例外処理の構文です。
do 句に例外が発生する可能性のあるコードを記述して、catch 句に例外を処理するコードを記述します。
catch 句にパターンを指定することで、例外の種類によって処理を分けることもできます。
例外が発生しなかった場合は catch 句は実行されません。

保存できたかどうかがログ出力されるようになりました。

saveMeals() メソッド全体は以下のようになっています。

private func saveMeals() {
    guard let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false) else {
        fatalError("Unable to archive meals")
    }
    
    do {
        try archivedData.write(to: Meal.ArchiveURL)
        os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
    } catch {
        os_log("Failed to save meals...", log: OSLog.default, type: .error)
    }
}

次にデータの読み出し部分を実装します。
saveMeals() の下に以下のメソッドを追加します。

private func loadMeals() -> [Meal]? {

}

meals に追加できるものを返すので、返り値の型は Meal の配列にします。
また、読み出しはデータが存在しない場合に失敗する場合があるのでオプショナルにして nil が返ってもよいことにします。

この中身は以下のようにします。

        do {
            let data = try Data(contentsOf: Meal.ArchiveURL)
            if let loadedData = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Meal.self, NSString.self, UIImage.self], from: data) as? [Meal] {
                os_log("Meals successfully loaded.", log: OSLog.default, type: .debug)
                return loadedData
            }
        } catch {
            os_log("Failed to load meals...", log: OSLog.default, type: .error)
        }
        return nil

読み出しには NSKeyedUnarchiver を使用します。

loadMeals() 全体は以下のようになっています。

    private func loadMeals() -> [Meal]? {
        do {
            let data = try Data(contentsOf: Meal.ArchiveURL)
            if let loadedData = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Meal.self, NSString.self, UIImage.self], from: data) as? [Meal] {
                os_log("Meals successfully loaded.", log: OSLog.default, type: .debug)
                return loadedData
            }
        } catch {
            os_log("Failed to load meals...", log: OSLog.default, type: .error)
        }
        return nil
    }

これで MealTableViewController からデータの保存と読み込みをする準備が整いました。
あとはしかるべきタイミングでこれらのメソッドを呼びましょう。

まずは保存する場合です。
unwindToMealList(sender:) で新規オブジェクトの追加を行っていたので、このメソッドになります。

@IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? MealDetailViewController, let meal = sourceViewController.meal {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Update an existing meal.
            meals[selectedIndexPath.row] = meal
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            // Add a new meal.
            let newIndexPath = IndexPath(row: meals.count, section: 0)

            meals.append(meal)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}

if 文が二重になっていますが、中の if 文ではオブジェクトの追加・更新が行われています。
外側の if 文の中の末尾に以下のコードを追加します。

// Save the meals.
saveMeals()

メソッド全体は以下のようになりました。

@IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? MealDetailViewController, let meal = sourceViewController.meal {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Update an existing meal.
            meals[selectedIndexPath.row] = meal
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            // Add a new meal.
            let newIndexPath = IndexPath(row: meals.count, section: 0)

            meals.append(meal)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        // Save the meals.
        saveMeals()
    }
}

他にデータの変更がある場所があります。
tableView(_:commit:forRowAt:) メソッドでデータの削除を行っているので、この処理の際にも保存を行います。

override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        meals.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
}

meals.remove(at: indexPath.row) の下に saveMeals() を追加します。

tableView(_:commit:forRowAt:) 全体は以下のようになりました。

override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        meals.remove(at: indexPath.row)
        saveMeals()
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
}

次に、保存データの読み出し部分を実装します。
viewDidLoad() で loadMeals() を呼びます。

現在 viewDidLoad() は以下のようになっています。

override func viewDidLoad() {
    super.viewDidLoad()

    // Use the edit button item provided by the table view controller.
    navigationItem.leftBarButtonItem = editButtonItem

    // Load the sample data.
    loadSampleMeals()
}

navigationItem.leftBarButtonItem = editButtonItem の下に以下のコードを加えます。

// Load any saved meals, otherwise load sample data.
if let savedMeals = loadMeals() {
    meals += savedMeals
} else {
    // Load the sample data.
    loadSampleMeals()
}

末尾の loadSampleMeals() を呼び出すところは else 節の中に移動させます。

loadMeals() が配列を返す場合はその配列を meals に加えます。
そうでない場合はデフォルトのデータを読み込みます。

これにより初期時はデフォルトのデータを表示し、その後なんらかの操作をして保存が行われた後はそのデータを使うようになります。

viewDidLoad() 全体は以下のようになりました。

override func viewDidLoad() {
    super.viewDidLoad()

    // Use the edit button item provided by the table view controller.
    navigationItem.leftBarButtonItem = editButtonItem

    // Load any saved meals, otherwise load sample data.
    if let savedMeals = loadMeals() {
        meals += savedMeals
    } else {
        // Load the sample data.
        loadSampleMeals()
    }
}

ここまでできたらシミュレーターで実行してみましょう。
新しくデータを追加して一度アプリを終了させます。
そのあと再度実行した際にそのデータが追加されていることを確認しましょう。

データの永続化

これでデータの保存と読み取りができました。
アプリはデータを失うことなく安全に終了することができるようになりました。

今まで 8 節に渡り「フードトラッカー」アプリを開発してきましたが、ついに必要な機能をすべて実装できました。
これで完成です。お疲れ様でした。

今回作成したプロジェクトは こちら です。

まとめ
Segue の Identifier でどの遷移なのかを特定できる
遷移方法により前の画面に戻る方法が異なる
NSSecureCoding を継承してアプリ内にデータを保存できる
「フードトラッカー」アプリが完成した
お疲れさまでした！
学習したことをSNSで報告しよう！



---
## リンク

(prepare(for:sender:))[https://developer.apple.com/documentation/uikit/uiviewcontroller/prepare(for:sender:)]

(init(describing:))[https://developer.apple.com/documentation/swift/string/init(describing:)-67ncf]

(indexpathforselectedrow)[https://developer.apple.com/documentation/uikit/uitableview/indexpathforselectedrow]

(dismiss(animated:completion:))[https://developer.apple.com/documentation/uikit/uiviewcontroller/dismiss(animated:completion:)]

(presentingviewcontroller)[https://developer.apple.com/documentation/uikit/uiviewcontroller/presentingviewcontroller]

(popviewcontroller(animated:))[https://developer.apple.com/documentation/uikit/uinavigationcontroller/popviewcontroller(animated:)]

(pushviewcontroller(_:animated:))[https://developer.apple.com/documentation/uikit/uinavigationcontroller/pushviewcontroller(_:animated:)]

(editbuttonitem)[https://developer.apple.com/documentation/uikit/uiviewcontroller/editbuttonitem]

(tableview(_:commit:forrowat:))[https://developer.apple.com/documentation/uikit/uitableviewdatasource/tableview(_:commit:forrowat:)]

(tableView(_:canEditRowAt:))[https://developer.apple.com/documentation/uikit/uitableviewdatasource/tableview(_:caneditrowat:)]

(deleteRows(at:with:))[https://developer.apple.com/documentation/uikit/uitableview/deleterows(at:with:)]

(NSCoding)[https://developer.apple.com/documentation/foundation/nscoding]

(encode(with:))[https://developer.apple.com/documentation/foundation/nscoding/encode(with:)]

(init(coder:))[https://developer.apple.com/documentation/appkit/nslayoutmanager/init(coder:)]

(decodeobject(forkey:))[https://developer.apple.com/documentation/foundation/nscoder/decodeobject(forkey:)]

(decodeInteger(forKey:)/)[https://developer.apple.com/documentation/foundation/nscoder/decodeinteger(forkey:)/]

(FileManager)[https://developer.apple.com/documentation/foundation/filemanager]

(NSKeyedarchiver)[https://developer.apple.com/documentation/foundation/nskeyedarchiver]

(NSKeyedUnarchiver)[https://developer.apple.com/documentation/foundation/nskeyedunarchiver]
