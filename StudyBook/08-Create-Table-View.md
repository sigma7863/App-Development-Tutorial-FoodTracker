le View を作ろう

「フードトラッカー」アプリ開発も後半に入りました。
前回までに ViewController scene を実装し、その View に必要なデータモデルを作成し、ユニットテストも行いました。

今回は新しい ViewController を作成します。
カスタムした Table View を作成し、食事のリストが一覧できるようにしていきます。

今回の環境は、

macOS Big Sur 11.4
Xcode 12.5.1 (12E507)
です。

前回までに作成したプロジェクトは こちら です。

目次
【実習】Table View を作ろう
Meal List を作ろう
Meal List を最初の scene にしよう
Table View の設定をしよう
【実習】カスタムセルを作ろう
UITableViewCell のサブクラスを作ろう
Table View にカスタムセルを設定しよう
セルの UI をデザインしよう
UI をプレビューしよう
画像を追加しよう
セルの UI とコードを繋げよう
初期データを作成しよう
データを表示しよう
まとめ
【実習】Table View を作ろう
今までの学習で食事の名前と写真、レーティングを表示する ViewController を実装しました。
これから新しい scene を作成します。

iOS にはリストを表示するためのクラスである UITableView が用意されています。
コード上では scene は ViewController に対応しています。
リストを表示する scene は UIViewController の上に UITableView を載せることで実現できます。
しかしこれもまた UITableViewController が UIViewController のサブクラスとして用意されているので これを使います。

Meal List を作ろう
Storyboard には複数の scene を置くことができます。
Main.storyboard に新しい scene を作りましょう。

まず Main.storyboard を開きます。
Library のフィルタに Table View Controller と入力します。
すると Table View Controller オブジェクトが見つかるので、これを既存の scene の左側にドラッグ&ドロップします。
以下のような状態になります。

Table View Controller
Table View Controller ができました。名前を変更しておきましょう。
Table View Controller Scene を選択して、Inspectors の Attributes inspector を開きます。
View Controller の Title を Meal List にします。

Meal List に設定
Meal List Scene ができました。これをアプリ起動時に表示させる ViewController にしましょう。

Meal List を最初の scene にしよう
まず、 Main.storyboard を表示するのに十分なスペースがなければ Navigator, Inspector を非表示にして
スペースを確保しましょう。

ViewController scene に下図のような左向きの矢印がついています。
これは Storyboard Entry Point といい、この矢印がついている scene がこの Storyboard を読み込んだ時に最初に表示される scene となります。
つまり今は ViewController scene が最初に表示される状態になっています。

この矢印をドラッグ&ドロップして Meal List Scene に移動させましょう。

Storyboard を読み込んだ時に最初に表示される scene

ここでシミュレーターで実行をしてみましょう。
Text Field や画像、レーティングの View の代わりに空の Table View が表示されました。

Storyboard Entry Point を操作することで起動時の表示を変化させることができました。

起動時の表示
真っ黒の画面が表示される場合
シミュレーターを起動したとき、次の図のように、真っ黒の画面が表示される場合があります。

真っ黒の画面が表示される
このような場合は、シミュレーターの設定でダークモードがオンになっている可能性があります。次の手順で、ダークモードをオフにしてください。

まず、次のようなアイコンの Settings アプリを見つけます。

Settings アプリのアイコン
このアプリを開いて、「Developer」の項目を探します。

Developer の項目を探す
この項目を開いて、「Dark Appearance」の項目を探し、オフに設定しましょう。

「Dark Appearance」を探す。画像はオンになっているので、これをオフにする
オフに設定すると、ダークモードが解除されるので、この状態でもう一度 FoodTracker アプリを確認してみてください。


iOS 15 以降は UITableView の空行は表示されない
iOS 15 以降、デフォルトでは UITableView の空行は表示されなくなりました。
そのため、iOS 15 以降のシミュレーターで実行すると、以下のように罫線が表示されていないと思います。

iOS 15 以降は空行（罫線）が表示されない
この動作は fillerRowHeight に automaticDimension を設定することで、iOS 14 以前のデフォルトの動作に戻すことができます。
後ほど実装する MealTableViewController の viewDidLoad() に以下のコードを追記してください。

        if #available(iOS 15, *) {
            // iOS 15 以降の場合にのみ実行される
            tableView.fillerRowHeight = UITableView.automaticDimension
        }
Please Type!
fillerRowHeight は iOS 15 以降で使用できるプロパティのため、使用する際は注意が必要です。
ここでは #available を使用して iOS 15 以降の場合にのみ実行するようにしています。

Table View の設定をしよう
Storyboard の Inspectors で Table View の設定を変更できます。
セルの高さを変更してみましょう。

Meal List Scene > Meal List > Table View を選択し、 Inspectors の Size inspector を開きましょう。
Row Height の項目を 90 に変更し return を押します。

Row Height 90 の設定
Storyboard 上でセルの高さが変わりました。
まだ Table View に要素がないので変更がわかりづらいですが、シミュレーターで実行してもセルが高くなっていることがわかります。

次からはセルをカスタマイズしていきましょう。

【実習】カスタムセルを作ろう
カスタムセル
上図のように食事の写真・名前・レーティングが一目でわかるようなセルを作成していきます。
UITableView のセルは UITableViewCell というクラスによって作られています。
デフォルトのセルをカスタマイズしていきましょう。

UITableViewCell のサブクラスを作ろう
Navigator area の Project navigator を開きます。
Project navigator のフォルダーアイコン
メニューから File > New > File (または command ⌘ + N ) を選択します。
iOS のカテゴリから、 Cocoa Touch Class を選択し、 Next を押します。
Class に Meal と入力します。
Subclass of は UITableViewCell を選択します。
選択すると Class が MealTableViewCell に変化します。
Also create XIB file は選択しません。
Language は Swift を選択します。
Next を押します。
実際に設定した画面
保存先がプロジェクトディレクトリで、 Group は FoodTracker、 Target に FoodTracker が選択されていることを確認して Create を押します。
すると MealTableViewCell.swift が作成され、 Project navigator でも確認できます。

次に、これを Meal List Scene のカスタムセルに設定していきましょう。

Table View にカスタムセルを設定しよう
Main.storyboard を開きます。
Meal List Scene の Table View Cell を選択します。

直接オブジェクトを選択する他に、画像のように Meal List Scene > Meal List > Table View > Table View Cell でも選択できます。

Table View Cell の選択
Inspectors の Attributes inspector を開きます。
Identifier の欄を MealTableViewCell に変更して return を押します。
カスタムセルを使用するには Identifier が必要になります。
これは UITableView が生成するセルを、どのクラスで生成するかのキーになります。
一つの UITableViewCell のサブクラスに一つの Identifier を割り当てることになります。
今回は MealTableViewCell という Identifier で MealTableViewCell クラスのセルを生成させるようにしました。

次に Size inspector を開きます。
Automatic のチェックボックスがある場合は、チェックを外します。
Row Height を 90 に変更して return を押します。
先ほど Table View のセルの高さを変更しました。
そのため、 MealTableViewCell クラスの高さも同じ 90 に揃える必要があります。
そうしないと余白ができたり表示が切れたりするからです。

次に Identity inspector を開きます。
Class を MealTableViewCell に変更して return を押します。
これで Table View は MealTableViewCell クラスをセルとして表示するようになりました。

準備が整ったので UI をカスタマイズしていきましょう。

セルの UI をデザインしよう
セルが設定できたので、カスタム UI を作成していきます。
基本的な UI の作成時と同じく、 Storyboard に直接オブジェクトを配置していきます。
画像・食事の名前・レーティングを以下のように配置していきます。

Main.storyboard を開きます。
Library のフィルタに Image View と入力し、 Image View をセルの上にドラッグ&ドロップします。
Image View をセルの上にドラッグ&ドロップ
ドラッグとリサイズをして左端、上端、下端が密着した正方形を作ります（下図）。
ドラッグとリサイズをして左端、上端、下端が密着した正方形を作ります
Image View を選択し、 Inspectors の Attributes inspector を開きます。

Image を defaultPhoto に変更します。

Library のフィルタに label と入力し、 Label をセルの上にドラッグ&ドロップします。

下図のように青色のガイドに合わせて配置します。

Label 右端をセル右端の青色のガイドまで広げます（下図）。

Label 右端をセル右端の青色のガイドまで広げます
Library のフィルタに Horizontal Stack View と入力し、 Stack View をセルの上にドラッグ&ドロップします。
Stack View を選択し、名前を Rating Control に変更します。
続けて Inspectors の Size inspector を開きます。
Height を 50 に、 Width を 282 に変更し return を押します。
Rating Control をドラッグし左端を Label と合わせ、下端をセルの青色のガイドに合わせます（下図）。
Rating Control をドラッグし左端を Label と合わせ、下端をセルの青色のガイドに合わせます
Rating Control を選択したまま Identity inspector を開きます。
Class を RatingControl に変更し return を押します。
RatingControl が描画されることを確認します。ただし、一番右の星が伸びて表示されています。
この手順で星が表示されない場合は Star Size の Width と Height を 50, Star Count を 5 にしてビルドしてください。
Stack View を選択したまま Attributes inspector を開きます。
Spacing を 8 に変更します。
スペースが入り、星の形も全て整いました。
Attributes inspector の User Interaction Enabled のチェックを外します。
Meal List ではレーティングを変更できないようにするためです。
現在の UI は下図のようになっています。

現在の UI
ここまでできたらシミュレーターで実行してみましょう。

シミュレーターで実行
しかしこのように何も表示されません。
Storyboard で UI を作成したのに、なぜでしょうか。

Storyboard で Table View の表示を設定するデータの種類は 2 種類あります。

Static Data
Dynamic Data
Static Data は Storyboard から提供されるデータで、 Dynamic Data はコードから動的に提供されるデータです。

Table View Controller はデフォルトで Dynamic Data を使います。
Storyboard で作成した UI は単なるセルのプロトタイプになっており、実際に表示するためには データをコードで提供する必要があるということです。

ではセルを表示させるためにコードでデータを用意していきましょう。

UI をプレビューしよう
Editor selector bar にて Preview を選択しましょう（下図）。
Xcode のバージョンによっては Preview がメニューにないことがあります。
その場合は下記の手順でプレビューを選択してください。
アプリケーションメニューの [Editor] > [Assistant] を選択します。
表示されたコード エディタにフォーカスして、アプリケーションメニューの [Editor] > [Preview] を選択します。
画面が狭い場合は Navigator, Inspectors のトグルボタンを押して広げましょう。
Editor selector bar から Preview を選択
すると下図のような表示になります。

Preview
プレビューでは Image View と Label はありますが、 RatingControl が表示されません。
もしも図のようになっておらず ViewController scene が表示されていたら Meal List Scene を選択してください。

画像を追加しよう
次に、 Meal List に要素を追加するために画像を追加しましょう。

まず、 Navigator, Inspectors が表示されていない場合は表示させておきましょう。

それができたら以下から今回使用する画像をダウンロードしてください（前回までにダウンロード済みならば必要ありません）。

Images.zipをダウンロード

以下の手順で画像を追加していきます。

Project navigator から Assets.xcassets を開きます。
何も選択されていない状態になっていることを確認します。
左下の + ボタンを押して Folder を選択します。
ディレクトリができるので、これの名前を Sample Images に変更します。
ディレクトリを選択して左下の + ボタンを押し、 Image Set を選択します。
Image Set ができるのでこれの名前を画像の名前と同じものにします。 (例: meal1, meal2, meal3)
2x のスロットに画像をドラッグ&ドロップします。
5 から 7 の手順を画像の分だけ繰り返します。
それが終わると以下のような状態になります。

画像の追加
セルの UI とコードを繋げよう
Dynamic Data を Table View のセルに表示するために、コードと UI を接続しておく必要があります。
今までに行ったのと同じように Outlet を作成しておきましょう。

Main.storyboard を開き、Editor のプルダウンメニューから Assistant editor を開きます。
画面が狭い場合は Navigator, Inspectors を非表示にしておきましょう。

Assistant editor を開く
Meal List Scene > Meal List > Table View > Meal Table View Cell > Content View を選択した状態で、 Assistant editor の上部にある表示から Automatic > MealTableViewCell.swift を選択し、 左側に Main.storyboard 、右側に MealTableViewCell.swift が表示されている状態にします。

Automatic > MealTableViewCell.swift
MealTableViewCell.swift は生成時に以下のようになっています。

import UIKit

class MealTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
Please Type!
クラス宣言の下に以下のコメントを追加します。

// MARK: Properties

このコメントの下にプロパティを追加していきます。

Storyboard の Meal List Scene にて Label を選択し control ⌃ を押しながら先ほどのコメントの下にドラッグ&ドロップします。

ダイアログが現れるので、名前を nameLabel にします。
他の項目はそのままにして（下図を参照してください）Connect を押します。

nameLabel
次に Image View(defaultPhoto) を選択して同じように control ⌃ を押しながら nameLabel の下にドラッグ&ドロップします。
ダイアログが現れるので、名前を photoImageView にします。
他の項目はそのままにして Connect を押します。

次に Rating Control を選択して control ⌃ を押しながら photoImageView の下にドラッグ&ドロップします。
ダイアログが現れるので、名前を ratingControl にします。
他の項目はそのままにして Connect を押します。

これでセルの UI が MealTableViewCell.swift に接続されました。
// MARK: Properties 以下は以下のようになりました。

// MARK: Properties
@IBOutlet weak var nameLabel: UILabel!
@IBOutlet weak var photoImageView: UIImageView!
@IBOutlet weak var ratingControl: RatingControl!

初期データを作成しよう
Dynamic Data を Table View に表示するには、コードから読み込む必要があります。
前回作成した Meal クラスのオブジェクトを ViewController に作成します。

まず、 Table View Controller のサブクラスを Meal List Scene に対応する ViewController として作成します。
以下の手順に従って作成をしていきましょう。

メニューから File > New > File を選択します（または command ⌘ + N を押します）。
iOS のカテゴリの Cocoa Touch Class を選択し、 Next を押します。
Class 名を Meal にします。
Subclass of のフィールドを UITableViewController にします。
すると名前が MealTableViewController に変わります。
Also create XIB file のチェックは入れません。
Language は Swift を選択します。
Next を押します。
保存先をプロジェクトディレクトリにし、 Group が FoodTracker 、 Target に FoodTracker が選択されていることを確認します。
Create を押します。
Project navigator で MealTableViewController.swift が作成されていることを確認します。
MealTableViewController.swift は以下のようなテンプレートで作成されます。

import UIKit

class MealTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
Please Type!
MealTableViewController は UITableViewController のサブクラスです。
UITableViewController は UIViewController のサブクラスで、 UITableViewDelegate と UITableViewDataSource を適用しています。

numberOfSections(in:) と tableView(_:cellForRowAt:) は UITableViewDataSource の必須メソッドです。
tableView(_:cellForRowAt:) はコメントアウトされていますが実装する必要があります。
他のメソッドはオプショナルな UITableViewDataSource のデリゲートメソッドとなっています （MARK: - Navigation 以下のメソッドは除きます）。

この MealTableViewController で Meal クラスのオブジェクトを宣言します。

Navigator, Inspectors が出ていない場合はトグルボタンを押して表示させましょう。

MealTableViewController.swift を開きます。

クラス宣言の下に以下のコメントとプロパティを宣言します。

// MARK: Properties

var meals = [Meal]()

Meal List には Meal オブジェクトがいくつも並ぶので、 Array で宣言をします。
この meals に Table View で表示させるデータを入れていきます。

次に、クラスの一番下に以下のコメントとメソッドを追加します。

// MARK: Private Methods

private func loadSampleMeals() {

}

このメソッドでサンプルデータを挿入します。
このメソッド内に以下の実装をしていきます。

まずは画像を用意します。

let photo1 = #imageLiteral(resourceName: "meal1")
let photo2 = #imageLiteral(resourceName: "meal2")
let photo3 = #imageLiteral(resourceName: "meal3")

#imageLiteral(resourceName:) は UIImage を返す画像リテラルです。
Assets に含まれるものは、 Xcode で画像名を入力すると（例： meal1）サムネイルとともに補完されます。
画像名がわからない場合は imageLiteral と入力すると補完されます。

表示は以下のようになります。

imageLiteral
次に Meal クラスのオブジェクトを作成します。
Meal クラスの初期化関数はオプショナルなので guard 文で nil を返す場合を除きます。

guard let meal1 = Meal(name: "Hamburger", photo: photo1, rating: 4) else {
    fatalError("Unable to instantiate meal1")
}

guard let meal2 = Meal(name: "Sushi Bento", photo: photo2, rating: 5) else {
    fatalError("Unable to instantiate meal2")
}

guard let meal3 = Meal(name: "Grilled Beef", photo: photo3, rating: 3) else {
    fatalError("Unable to instantiate meal3")
}

このオブジェクトを meals に追加します。

meals += [meal1, meal2, meal3]

loadSampleMeals() 全体は以下のようになっています。

    // MARK: Private Methods

    private func loadSampleMeals() {
        let photo1 = #imageLiteral(resourceName: "meal1")
        let photo2 = #imageLiteral(resourceName: "meal2")
        let photo3 = #imageLiteral(resourceName: "meal3")

        guard let meal1 = Meal(name: "Hamburger", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }

        guard let meal2 = Meal(name: "Sushi Bento", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }

        guard let meal3 = Meal(name: "Grilled Beef", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }

        meals += [meal1, meal2, meal3]
    }
Please Type!
これで loadSampleMeals() ができました。

次に viewDidLoad() を見てみます。

override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
}

生成時にコメントが書かれていますが、今回はこれを使用しないので削除し、代わりに以下のコードを挿入します。

// Load the sample data.
loadSampleMeals()

viewDidLoad() 全体は以下のようになっています。

override func viewDidLoad() {
    super.viewDidLoad()

    // Load the sample data.
    loadSampleMeals()
}
Please Type!
ここまでできたら、メニューの Product > Build（または ⌘ + B）を選択してプロジェクトをビルドし コンパイルエラーが起こらないことを確認しましょう。
いくつかのワーニングが出ますが次の節で修正するので今は無視して構いません。

データを表示しよう
引き続き MealTableViewController クラスの実装をすすめていきます。

Dynamic Data を表示するためには 2 つの重要なプロトコルがあります。

UITableViewDataSource
UITableViewDelegate
UITableViewDataSource は主に Table View が表示するデータを与えるものです。
UITableViewDelegate はセルの選択やセルの高さなど Table View の操作に関するものです。

UITableViewController はこの 2 つのプロトコルをデフォルトで適用しています。

今回はデータの表示に必要な以下のデリゲートメソッドを実装します。

func numberOfSections(in tableView: UITableView) -> Int
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
numberOfSections(in:) は、 Table View のセクション数を決めるデリゲートメソッドです。
MealTableViewController.swift では以下のようになっています。

override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 0
}

データを表示するためにセクションは 1 以上である必要があります。
今回は 1 セクションに表示するので、ここを以下のように書き換えます。

override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

tableView(_:numberOfRowsInSection:) はセクションに対する行数を決めるデリゲートメソッドです。
MealTableViewController.swift では以下のようになっています。

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 0
}

行数は　meals の要素数と等しいので、これを以下のように書き換えます。

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return meals.count
}

セクションによって行数が異なる場合は引数の section の値で場合分けをしますが、今回は 1 セクションのみなので必要ありません。

tableView(_:cellForRowAt:) は列ごとに表示するセルを決めるデリゲートメソッドです。
MealTableViewController.swift ではコメントアウト (/* ... */) されているので、それを外すと以下のようになっています。

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

    // Configure the cell...

    return cell
}

dequeueReusableCell(withIdentifier:for:) はセルを取得するメソッドです。
ユーザが Table View をスクロールすると新しいセルが作られ、見えなくなったセルが削除される代わりに Table View はセルを再利用しようとします。
再利用できない場合は新しくセルを作成することをします。
これによりスクロールしてもアプリが重くなることなく利用できるようになっています。

ここで渡す withIdentifier はどの型セルを再利用または作成するかを決めるものです。

このコードを動くようにするには以下の実装をする必要があります。

withIdentifier を Storyboard で設定したものに変える
dequeueReusableCell(withIdentifier:for:) で得られたセルを MealTableViewCell に変換する
得られた MealTableViewCell にデータを反映させる
セルを返す
実際にコードを書いていきましょう。
tableView(_:cellForRowAt:) のデフォルト実装を一度削除してから、以下のコメントと Identifier の宣言をします。

// Table view cells are reused and should be dequeued using a cell identifier
let cellIdentifier = "MealTableViewCell"

次にこの cellIdentifier を使って dequeueReusableCell(withIdentifier:for:) を呼びます。

guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
    fatalError("The dequeued cell is not instance of MealTableViewCell.")
}

UITableViewCell から MealTableViewCell へのダウンキャストが発生するので guard 文で早期リターンをさせます。

次にセルに表示させるデータを取得します。

// Fetches the appropriate meal for the data source layout.
let meal = meals[indexPath.row]

indexPath は IndexPath 型の引数で、 section と row を持っています。

次にセルにこのデータを適用させます。

cell.nameLabel.text = meal.name
cell.photoImageView.image = meal.photo
cell.ratingControl.rating = meal.rating

最後にセルを返します。

return cell

tableView(_:cellForRowAt:) 全体は以下のようになっています。

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Table view cells are reused and should be dequeued using a cell identifier
    let cellIdentifier = "MealTableViewCell"

    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
        fatalError("The dequeued cell is not instance of MealTableViewCell.")
    }

    // Fetches the appropriate meal for the data source layout .
    let meal = meals[indexPath.row]

    cell.nameLabel.text = meal.name
    cell.photoImageView.image = meal.photo
    cell.ratingControl.rating = meal.rating

    return cell
}
Please Type!
ここまでで必要なデリゲートメソッドが実装できました。
最後に、Storyboard から呼べるように MealTableViewController を Storyboard と接続しましょう。

Main.storyboard を開き、 Table View Controller (Meal List) を選択します。
Inspectors の Identity inspector を開き、 Class 名を MealTableViewController に変更し return を押します。

Table View Controller (Meal List) の Class名
ここまでできたらシミュレーターで実行してみましょう。
以下のような表示になるはずです。

シミュレーターで実行してみましょう。
うまく起動しない場合はメニューの Product > Clean Build Folder (または command ⌘ + shift ⇧ + K ) を行って再度ビルドしてみましょう。
それでもクラッシュする場合は Main.storyboard でセルを選択し、 Identity inspector の Identifier をもう一度タイプして return を押してみましょう。

Navigation 実装の準備をしよう
これで Table View Controller scene と View Controller scene ができました。
今は Table View Controller scene を表示させるだけですが List の要素を選択したら View Controller scene へ遷移させることを考えます。
画面遷移は Navigation を使用します。

Navigation の実装をする前に View Controller scene を修正しておきます。

まず、 Main.storyboard を開き View Controller scene を選択します。
下図のようになっています。

View Controller scene
これの Meal Name Label を削除します。
選択してから delete キーを押します。
すると下図のようになります。

Label の削除
この scene は ViewController.swift と接続されています。
今削除した Meal Name Label への参照も消す必要があります。

ViewController.swift を開き、 textFieldDidEndEditing(_:) メソッドを見ます。

func textFieldDidEndEditing(_ textField: UITextField) {
    mealNameLabel.text = textField.text
}

これの

mealNameLabel.text = textField.text

を削除します。

次に mealNameLabel の宣言を削除します。
同じく ViewController.swift に以下のような宣言箇所があるので削除しましょう。

@IBOutlet var mealNameLabel: UILabel!

次に、 ViewController.swift の名前を変えます。
今節で新しく ViewController を作成したことで、 ViewController といった時にどちらを指すかが明確でないからです。

Project navigator で ViewController.swift をクリックし長押しすると(Force Touch に対応していない端末の場合はクリックして再度クリックすると)名前が編集できるようになります。
MealDetailViewController.swift に変更し return を押します。

次にクラス名も変えます。
クラス宣言は以下のようになっています。

class ViewController: UIViewController {

これを以下のように書き換えます。

class MealDetailViewController: UIViewController {

同じように以下のような extension の宣言も変更します。

extension ViewController: UITextFieldDelegate {

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

これらを

extension MealDetailViewController: UITextFieldDelegate {

extension MealDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

このように編集します。

クラス名が変わったので、 Storyboard との接続部分も変更します。
Main.storyboard を開き、 View Controller scene を選択します。
Inspectors の Identity inspector を開き、 Class 名を MealDetailViewController に変更し return を押します。

ここまでできたらプロジェクトをビルドしてみましょう。
ビルドが成功したら今回は完了です。
次回は Meal List から Meal Detail へ遷移できるような Navigation を実装します。

今回のプロジェクトは こちら です。

まとめ
リストは Table View を使って作成できる
Table View は UITableViewDataSource, UITableViewDelegate で設定を行う
ViewController が複数ある場合はそれぞれにユニークな命名を行う

---
リンク

[UITableview](https://developer.apple.com/documentation/uikit/uitableview)

[UITableViewController](https://developer.apple.com/documentation/uikit/uitableviewcontroller)

[fillerRowHeight](https://developer.apple.com/documentation/uikit/uitableview/fillerrowheight)

[UITableViewCell](https://developer.apple.com/documentation/uikit/uitableviewcell)

[UITableViewController](https://developer.apple.com/documentation/uikit/uitableviewcontroller)

[UITableViewDelegate](https://developer.apple.com/documentation/uikit/uitableviewdelegate)

[UITableViewDatasource](https://developer.apple.com/documentation/uikit/uitableviewdatasource)

[numberOfSections(in:)](https://developer.apple.com/documentation/uikit/uitableviewdatasource/numberofsections(in:))

[tableView(_:numberOfRowsInSection:)](https://developer.apple.com/documentation/uikit/uitableviewdatasource/tableview(_:numberofrowsinsection:))

[tableView(_:cellForRowAt:)](https://developer.apple.com/documentation/uikit/uitableviewdatasource/tableview(_:cellforrowat:))
