基本的な UI を作ろう

今回は、いよいよ初めての iOS アプリを作成していきます。

2 節にまたがって作成をしていきます。今節では UI の部分を作成します。

今回の環境は、

macOS Big Sur 11.4
Xcode 12.5.1 (12E507)
です。

目次
【講義】Xcode とは
【実習】Xcode でプロジェクトを作成しよう
【実習】アプリをシミュレータで実行しよう
【講義】プロジェクトの構成ファイルを知ろう
AppDelegate.swift
ViewController.swift
Main.storyboard
【実習】基本的な UI を作成しよう
Text Field を配置する
プレースホルダーを設定する
テキストフィールドのキーボードを設定する
ラベルを配置する
ボタンを配置する
プレビューする
Auto Layout
【実習】UI とコードを繋げよう
Storyboard とコードのつながり
UI のオブジェクトから Outlet を作ろう
Action を定義しよう
ユーザの入力を処理しよう
UITextFieldDelegate を実装しよう
まとめ
【講義】Xcode とは
Xcode とは、 Apple が提供する統合開発環境(IDE)です。
iOS アプリを開発するのに必要なことは全て Xcode で行えるので Xcode に慣れることは iOS 開発を行う上で非常に大切です。

3 節では Playground を使って学習をしました。
Playground は対話的に Swift のコードを実行できるものでした。

iOS アプリは「Project」で開発を行います。
Project は Swift のコードと UI を直感的に作成できる InterfaceBuilder 、 設定ファイルや外部ライブラリをひとまとめにするものです。

さあ、 Project を作成して初めての iOS アプリを作成していきましょう。

【実習】Xcode でプロジェクトを作成しよう
これから「フードトラッカー」という名前のアプリを開発します。
食事の名前と画像を記録し、それを評価するというものです。
何を食べたか、何がよかったかを記録できるようになります。

welcome 画面で Create a new Xcode project を選択します。
または、上部メニューから File > New > Project と選択します。

Create a new Xcode project
File > New > Project
するとウィンドウが開き、プロジェクトのテンプレートを選択する画面になります。
ここでは iOS の項目の App を選択し次に進みます。

App を選択
ここでいくつかの設定をします。

Product Name は FoodTracker
Team は自分の所属するチームですが、今回は None もしくは Add account... のままにします。
Organization Identifier は自分の組織の Identifier を入れます。ない場合は com.example と入力します。
Bundle Identifier は自動的に決まります。今は com.example.FoodTracker となっているはずです。
Interface は Storyboard
Language は Swift
Use Core Data は未選択
Include Tests は選択
とします。そして次に進みます。

project の設定画面
次に保存する場所を選択します。
Xcode は保存する際のデフォルトのディレクトリはないので、好きな場所でよいでしょう。
Create ボタンを押すと、プロジェクトが作成されます。

プロジェクト作成直後のスクショ
Navigator area では選択中のファイルの詳細設定ができます。
Navigator area から編集したいファイルを選択し、 Editor area でそのファイルを編集していきます。
Inspector area では選択中のファイルやオブジェクトの詳細設定を行えます。
Debug area は、最初は表示されていませんが、シミュレーションをしたりテストをしたりするときに使います。
また、 Toolbar ではビルドやテスト、エディタの表示設定ができます。

各エリアの名称
ファイルの拡張子を表示する
Xcode 13 以降、デフォルトでファイルの拡張子が非表示になっています。
ここでは、拡張子を表示する方法を紹介します。

アプリケーションメニューの [Xcode] から [Settings] を選択します。
Xcode のバージョンによっては [Preferences] を選択します。
[General] の [File Extensions] を [Show All] に変更します。


【実習】アプリをシミュレータで実行しよう
これからアプリを作成していくにはデバッグは避けて通れません。
アプリを実際に起動して動作を確認してみましょう。
…とは言っても今は作成したばかりなので何も中身がありませんが。

デバッグはシミュレータまたは実機で行うことができます。
実機でデバッグができると良いですが今はシミュレータで行います。

デバッグ実行は、 Toolbar 左側の実行ボタンを押します。
または、command ⌘ + R でも行えます。
また、メニューの Product > Run でも行えます。

デバッグ実行ボタン
実行ボタンの左は実行停止ボタンです（Simulator が起動していないと表示されません）。

実行停止ボタン（Simulator が起動していると表示される）
その右にあるのはスキーム選択のポップアップです。
どのターゲットをどのデバイスで実行するかを選択することができます。
今のターゲットは "FoodTracker" です。デバイスは好きなものを選択できます。
iPhone や iPad を Mac に接続するとそれが表示されますが、現段階では実機ビルドできないため、iPhone 14 Pro シミュレータを選択しましょう。

実行デバイス選択
実行ボタンを押すとスキームで選択されているデバイスで実行されるようになっています。
iPhone 14 Pro シミュレータを選択して、実行ボタンを押してみましょう。

すると、ビルドされてそのあとにシミュレータが起動します。
なお、シミュレータは Xcode とは別に起動します。シミュレータのアイコンは次のようなものです。Xcode のアイコンと比べると、ハンマーの代わりにスマートフォンが表示されていることがわかります。

シミュレータのアイコン
まだ何も実装していないので、真っ白な画面が表示されたら成功です。

何も実装していない真っ白なシミュレーター
これで初めての iOS アプリを実行することができました。

プロジェクトの構成ファイルを知ろう
無事にアプリが実行できたところで、アプリを構成するファイルに目を向けてみましょう。

Single View Application のテンプレートで生成したプロジェクトでは、すでにいくつかのファイルが生成されています。
Navigator area を見てみましょう。

まず、以下のような構成になっていることを確認します。

Navigator area
このような構成になっていない場合は、iOS の App をテンプレートとしたプロジェクトを正しく作成できていない可能性があります。
例えば、プロジェクトのテンプレートの選択時に Multiplatform から iOS に変更し忘れたままプロジェクトを作成すると、プロジェクトの構成が異なります。
このようなときは、プロジェクトの作成をもう 1 回お試しください。

ルートにある FoodTracker がプロジェクトです。
その中に FoodTracker, FoodTrackerTests というフォルダがあります。
このフォルダのことを、 グループと呼びます。

FoodTracker グループにはアプリを構成するファイルが入っています。
FoodTrackerTests グループにはテストのためのファイルが入っています。
FoodTrackerUITests グループには特にアプリを実際にユーザが使うことを想定してテストを行うためのファイルが入っています。
Products グループには生成物が入っています。このグループの中を編集することはあまりありません。

開発を進める上でファイルが増えていくことになりますが、機能ごとにグループを作っていくと どのようなファイルがあるかわかりやすくなるでしょう。

さて、今回はアプリ開発の根幹になるファイルの説明をします。

AppDelegate.swift
SceneDelegate.swift
ViewController.swift
Main.storyboard
です。

Xcode 13 以降は Navigator area に Products グループが表示されない
Xcode 13 以降は Navigator area に Products グループが表示されなくなりました。
アプリケーションメニューの [Product] から [Show Build Folder in Finder] を選択して確認できます。



AppDelegate.swift
FoodTracker グループの中にある AppDelegate.swift をクリックすると、 画面中央のエディタエリアに Swift のソースコードが表示されます。
この AppDelegate.swift は二つの重要な機能を担っています。

アプリのエントリポイントを提供します。
AppDelegate クラスを定義し、アプリの状態変化を取得します。
エントリポイント とは、アプリが起動した際に最初に実行される場所のことです。
main の属性 (@main とファイルの上部に書く) をつけることでエントリポイントになります。
main にはアプリのライフサイクルを管理する Application オブジェクトと AppDelegate オブジェクトがあります。

Application オブジェクトは UIApplication のインスタンスです。
application(_:didFinishLaunchingWithOptions:) などのメソッドで引数として渡されます。

AppDelegate オブジェクトは @main 属性で指定された AppDelegate クラスのインスタンスです。
このクラスは UIApplicationDelegate プロトコルを採用しており、アプリケーションのライフサイクルに関連するさまざまなメソッドを実装できます。

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
Please Type!
これが main の最小構成になります。

今回は以上のように、自動で生成されたメソッドがあります。
これらは UIApplicationDelegate プロトコルのメソッドになっており、 UIApplication のライフサイクルによってこれらが呼ばれることになります。

他に利用できるメソッドと呼ばれるタイミングの対応表を以下に示します。

メソッド名	呼ばれるタイミング
application	アプリケーションが起動した直後
applicationWillResignActive	アプリケーションが非アクティブな状態になる直前
applicationDidEnterBackground	アプリケーションがアクティブな状態でバックグラウンドになった直後
applicationWillEnterForeground	アプリケーションがアクティブな状態でフォアグラウンドになる直前
applicationDidBecomeActive	アプリケーションがアクティブな状態になった直後
applicationWillTerminate	アプリケーションが終了する直前
アクティブな状態は、起動状態と考えればよいです。

これらの状態で何か処理をする場合は AppDelegate のメソッド内に処理を実装していきます。

SceneDelegate.swift
この SceneDelegate.swift は iOS 13 以降のデバイスにおいて、アプリの状態変化に応じた処理を担っています。

これらは UIWindowSceneDelegate プロトコルのメソッドになっており、 UIScene のライフサイクルによってこれらが呼ばれることになります。

利用できるメソッドと、呼ばれるタイミングの対応表を以下に示します。

メソッド名	呼ばれるタイミング
scene	シーンが追加された直後
sceneDidDisconnect	シーンが終了する直後
sceneDidBecomeActive	シーンが非アクティブな状態でアクティブな状態になった直後
sceneWillResignActive	シーンがアクティブな状態で非アクティブな状態になる直前
sceneWillEnterForeground	シーンがアクティブな状態でフォアグラウンドになる直前
sceneDidEnterBackground	シーンがアクティブな状態でバックグラウンドになった直後
ViewController.swift
初期状態の ViewController.swift は以下のようになっています。

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


}
Please Type!
まず、 ViewController クラスは UIViewController のサブクラスです。
UIViewController は UIKit のクラスで、アプリの画面を管理するクラスです。

viewDidLoad() のメソッドがオーバーライドされており、 UIViewController のライフサイクルに則り、処理を追加することができます。

viewDidLoad() は ViewController が読み込まれた直後に呼ばれるメソッドです。

後ほど、このファイルにソースコードを追加していきます。

Main.storyboard
UI を作成するには Storyboard を使います。
Storyboard は画面のコンテンツを視覚的に配置することができ、 画面やコンテンツの遷移も定義できます。
iOS 端末には複数の画面サイズがありますが、 それぞれの見た目がすぐ確認できるようになってあり、アプリの UI 作成に必要な機能が揃っています。

Main.storyboard
ホワイトスペースを可視化する
Xcode ではデフォルトの設定でホワイトスペースを表示しないようになっています。
この設定は、メニューバーから [Editor] > [Invisibles] を選択して切り替えることができます。

ホワイトスペースを可視化した
【実習】基本的な UI を作成しよう
さて、基本的なインタフェースを作成していきましょう。
まずは食事の名前を入力するテキストフィールドとそれを送信するボタンがある画面を作成します。

Main.storyboard を開き、ここに UI のコンポーネント (部品) を配置していきます。

コンポーネントは 「Library」にあります。
「Library」はショートカットキー command ⌘ + shift ⇧ + L や、 下の写真にあるようなボタンをクリックして表示させてください。

Library を表示させるボタン
ここからコンポーネントを選択します。

Text Field を配置する
食事名を入力する Text Field (UITextField) を配置しましょう。

コンポーネントは種類が多いので上部の入力フィールドでフィルタができます。
"text field" と入力すると Text Field がフィルタされます。

これをドラッグして View Controller まで持って行き、ドロップします。
すると View Controller の View に Text Field が設置されます。

ドラッグで持って行く
これをドラッグすると中央や端のあたりで青いガイドが出るのでガイドに沿って配置すると コンポーネントの整列が楽になります。
今回は左端のガイドに合わせて置いてみましょう。

さらに、サイズ変更のガイドをドラッグして右端の青いガイドまで広げてみましょう。
画像のような状態になっていれば問題ありません。



プレースホルダーを設定する
Text Field には初期状態で何を入力するべきかのプレースホルダーがあったほうがわかりやすいです。

Utility area の Attributes inspector を開きましょう。

プレースホルダー
そこの Placeholder プロパティに文字列を入力し return を押すとそれがプレースホルダーになります。
今回は "Enter meal name" と入力しましょう。

テキストフィールドのキーボードを設定する
テキストの入力が終わったら「完了」ボタンを押して入力を終了させるようにします。

同じく Attributes inspector にある Return Key のプルダウンを Default から Done に変更してみましょう。
これでリターンキーが Done という表示になります。
そして Auto-enable Return Key のチェックボックスをオンにしてみましょう。
これで Text Field が空の場合にリターンキーが押せなくなりました。

Return Key の設定
実際にシミュレーターで実行してキーボードの見た目を確認してみましょう。
Text Field をタップするとキーボードが出てきます(出てこない場合は command ⌘ + K を押して表示方法を変更してみましょう)。
そしてキーボード右下のリターンキーが Done という表示になっていることを確認します。

リターンキーが Done になっている
ラベルを配置する
次に、 Label (UILabel) を配置しましょう。
Label は静的なテキストを表示するコンポーネントで、 UI 上で要素の説明をするのに向いています。
今回は Text Field の上部に設置して、 Text Field が何をするものなのかの説明を追加しましょう。

Library を開き、フィルタに "label" と入力しましょう。

label を検索
Label をドラッグし、 Text Field の上にドロップします。
この際も青いガイドが出るので配置しやすいですね。
そのあとに Label をダブルクリックするとテキストを編集できるようになるので、"Meal Name" と入力して return を押しましょう。

label のテキスト編集
これで Label を配置できました。

ボタンを配置する
次に、Button (UIButton) を配置します。
Button はインタラクティブなコンポーネントなので、ユーザのタップをトリガーにしてなんらかの 処理を行わせることができます。
後ほど、ボタンを押したら Text Field をリセットする処理を実装します。

Library を開き、フィルタに "button" と入力しましょう。
Button をドラッグし、 Text Field の下にドロップします。
Label の時と同様に青いガイドが出るのでそれに合わせましょう。
Button をダブルクリックするとテキストが編集できるので、 "Set Default Label Text" と入力して return を押しましょう。

ボタンを配置
プレビューする
iOS には様々な端末があり、画面のサイズも様々です。
アプリを開発する際は対応している端末でそれぞれ表示が意図したようにならなければなりません。

画面下部に iPhone 14 Pro という表示があります。
これをクリックしてみましょう。

iPhone 14 Pro の表示箇所
するといくつかのデバイスとデバイスの向きの選択肢が現れました。
現在は iPhone 11 で縦持ちで見た場合の見た目になっています。
Device を選択するとそのデバイスでの表示に変わります。

様々なデバイスでのプレビュー。青く表示されているデバイスが、現在プレビューで使用しているデバイス。
小さいデバイスにすると、 Text Field の右端がはみ出てしまったり 大きいデバイスにすると、 Text Field の長さが足りなくなってしまったりすることがあります。

このデバイス間の差異を吸収しなければいけません。

Auto Layout
それを解決するのが Auto Layout です。
Auto Layout は様々な画面サイズに対応したレイアウトを作成するのをサポートする機能です。
レイアウトに制約 (Constraints) を設けることでそれを実現します。
具体的には、オブジェクトの画面端からのポイント数、縦横比、中央揃えなどを指定していきます。

Auto Layout で UI を作成するのに便利なのが Stack View (UIStackView) です。
Stack View は iOS 9 以降で利用できる、複数のオプジェクトをひとまとめにするものです。
これによりグループ化、整列が楽にできるようになります。

先ほどの Main.storyboard で Stack View を使って Auto Layout を指定してみましょう。

まずは複数のオブジェクトを選択します。
Shift を押しながら、 Label, Text Field, Button を選択します。
その後にエディタ右下 (画像を参照してください) にある Embed in を押し、Stack view を選択します（または Editor > Embed in > Stack view を選択します）。

「Embed in」ボタン
すると三つのオブジェクトがひとまとめになりました。これが Stack View です。
Stack View はオブジェクトを縦か横に並べることができます。
Utility area の Axis プロパティを Vertical にすると縦に、 Horizontal にすると横に並びます。
現在は縦に並べたいので Vertical にします（デフォルトだと Vertical になっています）。

Stack View の設定
縦に並べたオブジェクトの間隔を設定します。
Utility area の Attributes inspector の Spacing プロパティを 12 と入力し return を押します。

Spacing プロパティ設定
これでそれぞれのオブジェクトの間隔が 12pt になりました。

オブジェクトの間隔調整
次にこの Stack View の位置を決めます。
エディタ右下 (画像を参照してください) の Add New Constraints ボタン を押します。
すると制約を設定するポップアップが開きます。

「Add New Constraints」のポップアップ
"Spacing to nearest neighbor" と書かれた上に数値を入力する欄が 4 つあります。
これは、いま選択中のオブジェクト (Stack View) が最も近いオブジェクトとどれくらい離れているかという距離（マージン）を決定する欄です。
近隣のオブジェクトから相対的にスペースを取ることで、どの画面サイズでも表示ができるようになるということです。

上の欄に 60、左の欄に 16、右の欄に 16 と入力すると、それぞれのマージンが設定されます。
下のマージンは何も設定しません。
誤って設定したくない箇所に入力した場合は四角と入力欄の間のマークをクリックすると非設定状態になります。

Constraints の設定
上、左、右の 3 箇所のマージンが設定できたら Add 3 Constraints ボタンを押すと制約が決定されます。

今の位置と制約がずれていると Misplaced Views の警告が出ますが、その場合は画面下側の Update Frames ボタンを押すか、警告のマークをクリックして Update Frames を選択し、 Fix Misplacement ボタンを押します。

Update Frames ボタン
これで Stack View の位置が決まりましたが、 Text Field の長さが足りなくなっていることにも気づきます。
Text Field の横幅は Stack View の横幅と同じにしたいので、 Text Field をクリックして Add New Constraints ボタンを押し、制約のポップアップを開きましょう。

Text Field の横幅を Stack View の横幅と同じにするには、左右のマージンをそれぞれ 0 にすれば良いです。
左右の欄に 0 と入力し、 Add 2 Constraints ボタンを押して制約を作りましょう。

Text Field の 横幅設定
横幅いっぱいにまで伸びた Text Field
Text Field が選択されている状態で、 Utility area の Size inspector を開きましょう。

Size inspector
ここではオブジェクトの制約などを確認、編集することができます。

さて、ここまでできたらシミュレーター実行をしてみましょう。
Text Field をクリックするとフォーカスが当たります。
command ⌘ + K を押すとソフトウェアキーボードが出ます（もう一度押すと引っ込みます）。

Text Field を選択するとキーボードが出る
command ⌘ + ← または command ⌘ + → を押すとデバイスが回転します。

デバイスを回転させても Text Field が横幅いっぱい
回転しても Text Field の大きさや Stack View の制約が守られていることがわかるでしょう。

このように Auto Layout を使って画面回転や様々な画面サイズに対応することができます。

制約の解除
実際に自分で画面のレイアウト設定していく中でどんな制約を設定したか、混乱してくることがあります。
command ⌘ + Z のショートカットなどで UNDO して制約を元に戻してもいいのですが、オブジェクトを選択して制約を解除する方法も用意されています。

リセットしたいオブジェクトを選択して右下の ├ △ ┤ ボタンから Clear Constraints を選択。
これでそれぞれのオブジェクトごとに制約をリセットできます。覚えておくといいかもしれません。

Clear Constraints
【実習】UI とコードを繋げよう
このままでは UI はただ静的なオブジェクトがあるだけで、なにか処理をすることはできません。
フードトラッカーアプリとしての機能を作っていきましょう。
そのためには、 UI とコードを繋げます。

Storyboard とコードのつながり
Storyboard のオブジェクトはソースコードにリンクさせることができます。
これから実装していくソースコードと Storyboard の関係を理解するのはとても大切なことです。

Storyboard の一つのビュー（ Scene といいます）は一つの ViewController を表しています。
ViewController には View が乗っており、その View に View を乗せることができます。
View に乗っている View をサブビューと呼びますが、つまり ViewController には 一つの View があり、その View にいくつかのサブビューがあるということです。

また、 ViewController は View の表示だけでなく、アプリのデータを View と繋げる役割もあります。
View の状態変化をアプリのデータに反映させたり、取得したデータを View に反映させたりできます。

実はテンプレートから生成された段階で、 既に ViewController.swift は Main.storyboard で作成した ViewController と繋がっています。
Main.storyboard で先ほど編集した ViewController を選択し、 Utility area にある Identity inspector を開いてみましょう。

Identity inspector
Custom Class の Class が ViewController となっています。
これは ViewController.swift で定義された ViewController クラスがこの ViewController に 紐づけられていることを示します。
実行時にこの Storyboard は ViewController クラスのインスタンスを作ります。

Custom Class
UI のオブジェクトから Outlet を作ろう
Outlet はソースコードから InterfaceBuilder の UI オブジェクトを参照する機能です。
Outlet を作成するには、オブジェクトから control ⌃ + ドラッグをして ViewController に ドロップすることでできます。
これからやってみましょう。

まずは Xcode のエディタ画面に Storyboard と ソースコードを表示させます。
Main.storyboard を開き、メニューバーの Editor から Assistant を選択して切り替えます

Assistant
表示領域が狭ければ、 command ⌘　+　0 で Navigator area を、 command ⌘　+　option ⌥　+　0　で Utility area を 非表示にしましょう。

Assistant editor は、元から表示していたファイルから自動的に対応するファイルを開いてくれます。
今回であれば ViewController.swift が開くはずです。
もしも開いていなければ、 Automatic をクリックして Manual に変更し、 ViewController.swift を 探して表示しましょう。

Automatic
ViewController.swift の ViewController クラスは以下のように宣言されています。

class ViewController: UIViewController {

このクラス宣言の下に Outlet を作成します。
まずはその下に次のコメント書きましょう。

// MARK: Properties

これはただのコメントではありません。// MARK: はコードの可読性を上げるコメントです。
この MARK の下にプロパティを並べることで ViewController にどのようなプロパティがあるのか わかりやすくなります。

Main.storyboard に作成した Text Field を control ⌃ を押しながらクリックし、ドラッグしてみましょう。
すると Text Field から線が伸びます。

Automatic
これを MARK の一行下までドラッグし、ドロップしましょう。
するとダイアログが現れ、名前を入力する欄にフォーカスが当たります。
ここでは nameTextField と入力します。

名付け
Connect ボタンをクリックすると、　Outlet の完成です。

@IBOutlet weak var nameTextField: UITextField!

という行が挿入されています。

IBOutlet 属性は、 Xcode が nameTextField という名前で InterfaceBuilder から繋いだという ことを表します ( InterfaceBuilder のプレフィックスが IB です)。

var nameTextField: UITextField! は UITextField の暗黙的オプショナルアンラップ型の、 nameTextField という名前の変数です。

同様に、Label も繋げてみましょう。
Main.storyboard の Label の上で control ⌃ を押しながらドラッグし、 nameTextField の一行下でドロップします。
変数名は mealNameLabel とします。
Connect ボタンを押すと Outlet が作成されます。

Label もドラッグ＆ドロップ
Label の名付け
@IBOutlet weak var mealNameLabel: UILabel!

これで UI のオブジェクトをソースコードとつなぐことができました。
UI のオブジェクトとの紐付けはこのようにドラッグ&ドロップのみで行います。
紐付け後の変数名・メソッド名を変えても自動で反映されないので注意してください。
その場合は一度紐付けを解除する必要があります。

紐付けの解除方法を説明します。
Main.storyboard で紐付けを解除したいオブジェクトを選択します。
Utility area の Connections inspector を開きます。
そこで Sent Events や Referencing Outlets で紐付いている項目の x を押すと連携が 解除されます。
間違えて紐付けを行ったり、後で変更をしたりする場合は以上の手順で一度紐付けを解除してから 再度連携を行ってください。

Connections inspector
Refactor 機能を使ったリネーム
プロジェクト中で参照されている箇所を一度にリネームするには Refactor 機能を使うと便利です。
リネームしたいプロパティやメソッドを選択した状態でメニューから Editor > Refactor > Rename... を選択します。
すると参照箇所が一覧されるので、そこで修正すれば InterfaceBuilder と紐づいている変数名も一度にリネームできます。

次からはユーザが引き起こすイベントを起点にしたインタラクションを設定していきましょう。

Action を定義しよう
iOS アプリは イベント駆動プログラミング が基礎になっています。
アプリはユーザのアクションやシステムのイベントによって何らかの動作を引き起こします。
ユーザがアプリのインタフェースに作用したことをトリガーにして、アプリのロジックが 動作するということです。
例えばキーボード入力をすると文字が表示されますが、これはユーザがキーボード入力をしたことをトリガーにして その文字を表示するロジックが動作しているということです。
ユーザやシステムのイベントを元にアプリが何らかの動作を行うのでイベント駆動、というわけですね。

アプリはユーザのアクションに UI の変化を起こして反応しなければなりません。
例えばユーザはアプリのボタンをタップしたら何かが起きることを期待します。
ボタンのタップにより、実際にアプリ内部でデータが変化していたとしてもそれが UI に反映されなければ ユーザにはわかりません。
タップというアクションに対して UI を変化させて、そのアクションに対する応答を示唆しなければいけません。

Action はアプリに起きたイベントとコードを繋げるものです。
イベントが発火すればコードが実行されます。

発火 とはイベントが発生して通知されることをいいます。
英語ではこのことを fire event と記述するため、そのまま日本語でも発火と言われます。
今後、イベントが発生して通知されることを発火と記述します。

次に、 UI に反映されるようなメソッドを実装しましょう。

Action は Outlet と同じように作成することができます。

まずは先ほどと同じように MARK をつけましょう。
ViewController クラスの最終行（}）の一行上に

// MARK: Actions

と書きましょう。
プロパティと Action を区別するためです。

次に Main.storyboard で Set Default Label Text ボタンを選択し、 そこから control ⌃ を押しながらドラッグして先ほどの MARK の一行下でドロップしましょう。

MARK の一行下でドロップ
先ほどと同じようにダイアログが現れます。
Connection が Outlet となっているので、これを選択して Action にします。
名前は setDefaultLabelText と入力しましょう。
Type は Any となっているので、これを UIButton に変更します。
Any とは、すべてのオブジェクトを表します。今回はボタンのタップなので UIButton に しておきます。

UIButton の設定
Connect ボタンを押すと、 Action が追加されました。

@IBAction func setDefaultLabelText(_ sender: UIButton) {
}

メソッドの引数の sender にはタップされたボタンが渡されます。
それにより、どのボタンがトリガーになったかわかります。

また、引数名の前の _ は、外部引数名の省略を表します。
Swift では関数呼び出しの際は基本的に引数名を書かないといけませんが、アンダースコアをつけることで省略ができます。

IBAction 属性は InterfaceBuilder によって Storyboard と繋がった Action であることを 示しています。

このままではこのメソッドは空で、何も起きないので実装をしていきましょう。

ViewController.swift の setDefaultLabelText メソッドの波括弧の中に次の一文を書きましょう。

mealNameLabel.text = "Default Text"

これは、 mealNameLabel のテキストを "Default Text" に書き換える処理です。
setDefaultLabelText メソッド全体は以下のようになっています。

@IBAction func setDefaultLabelText(_ sender: UIButton) {
  mealNameLabel.text = "Default Text"
}

さて、ここまでできたらシミュレータ実行をしてみましょう。
見た目は先ほどと変わりませんが、ボタンの Action を追加したので動作するかみてみましょう。
ボタンをタップすると、 Meal Name と書かれていたラベルが Default Text になります。

ボタンをタップする前 Meal Name
ボタンをタップした後 Default Text
このように、ユーザが引き起こしたアクションに対して UI を変更するという場面は多いです。
今回はボタンでしたが、他にもスライダーやスイッチなどのオブジェクトがありますし、 タップ、ドラッグなどのユーザのインタラクションもトリガーになります。
今後の学習の中でもこのようなパターンを多く見かけることでしょう。

ユーザの入力を処理しよう
これまでで、ラベルを初期値にすることができました。
次は Text Field の値をセットしてみましょう。
ユーザが入力をして、キーボードの Done ボタンを押したら テキストが反映されるようにしてみましょう。

もし Assistant editor が開いていたら、 Assistant editor 右上の × ボタンを押してエディタを閉じておきましょう。
また、 Navigator area と Utility area が隠れていたら command ⌘　+　0 で Navigator area を、command ⌘　+　option ⌥　+　0　で Utility area を表示にしましょう。

Text Field の入力を受け取るには、 UITextFieldDelegate というプロトコルを使用します。

ViewController に UITextFieldDelegate を適用させ、 UITextFieldDelegate プロトコルのメソッドを実装していきます。

まず、 Navigator area で ViewController.swift を選択します。

ViewController.swift の一番下の行に、次の行を追加します。

extension ViewController: UITextFieldDelegate {

}

extension は拡張のことで、 ViewController クラスに例外的な実装をもたせたり、 今回のようにプロトコルを実装するのに使います。

コード全体は以下のようになっています。

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLabel.text = "Default Text"
    }

}

extension ViewController: UITextFieldDelegate {
    
}
Please Type!
これで ViewController クラスに UITextFieldDelegate プロトコルを適用することができました。

次に、 nameTextField が ViewController クラスのデリゲートメソッドを呼べるように設定します。
UITextFieldDelegate のように Delegate という名前がついている UIKit のプロトコルは デリゲート (委譲) という手法を採用しています。

デリゲートとは、何らかの処理をデリゲート先のオブジェクトに任せ、 自分自身はその処理を行わずにデリゲート先のオブジェクトからの通知を受け取ることで 局所性を向上させる手法のことです。

今回の例では ViewController クラスを nameTextField のデリゲート先に指定し、 ViewController クラスが UITextFieldDelegate プロトコルのメソッドを実装することで nameTextField に対して行われた 処理を受け取ることができるようになります。

これからデリゲートを設定し、デリゲートメソッド (UITextFieldDelegate プロトコルのメソッド) を 実装していきましょう。

viewDidLoad メソッドは現在以下のようになっています。

override func viewDidLoad() {
  super.viewDidLoad()
  // Do any additional setup after loading the view, typically from a nib.
}

これから設定をしていくのでこのコメントは削除し、super.viewDidLoad() の一行下に以下の実装を加えましょう。

// Handle the text field’s user input through delegate callbacks.
nameTextField.delegate = self

viewDidLoad メソッド全体は以下のようになります。

override func viewDidLoad() {
  super.viewDidLoad()

  // Handle the text field’s user input through delegate callbacks.
  nameTextField.delegate = self
}

これで ViewController クラスは nameTextField のデリゲートメソッドを extension ViewController: UITextFieldDelegate の ブロック内で処理できるようになりました。

UITextFieldDelegate プロトコルはオプショナルメソッドがあります。
プロトコルで宣言されたメソッドは基本的には適用する側で全て実装しなければいけませんが、オプショナルメソッドの場合は実装をしなくてもよいことになっています。
今回は以下の二つのメソッドを実装します。

func textFieldShouldReturn(_ textField: UITextField) -> Bool
func textFieldDidEndEditing(_ textField: UITextField)

これらのメソッドがいつ呼ばれるかを知るためには Text Field がどのようにユーザのイベントに 反応するかを知ることが大切です。
まず、ユーザが Text Field をタップしたらその Text Field は First Responder になります。
First Responder とは、タップ以外のイベントをまず最初に受け取るオブジェクトのことです。
First Responder になるとユーザのキー入力を受け取ることができるようになります。
ユーザがキー入力を終えると、 Text Field は First Responder を解除する必要があります。
キー入力が終わるということは、再びキー入力の必要が出るまではイベントを受け取る必要がないからです。

Text Field が First Responder を解除されるべきかどうかを textFieldShouldReturn メソッドに実装します。
今回は、ユーザがリターンキー (今回のケースだと Done) を押した場合に解除するようにします。

UITextFieldDelegate を実装しよう
ViewController.swift の extension ViewController: UITextFieldDelegate { の一行上に MARK のコメントを追加します。

// MARK: UITextFieldDelegate

先ほどから MARK のコメントを書いていますが、これがどのように役立つかを見てみましょう。
Editor area の上部に Functions メニューがあるので、これをクリックしてみましょう。

Editor area 上部の Functions メニュー

するとクラスやプロパティ、メソッドが一覧になっています。 // MARK: で記述したコメントはそれを 分けるように表示されます。
このように MARK コメントは Functions メニューでの見やすさを向上させます。
また、この一覧からプロパティやメソッドをクリックするとその場所にジャンプすることができるので 目的のものを探すのに便利な機能となっています。

先ほど追加した extension の中に以下のデリゲートメソッドを追加します。

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
}

その中に以下の実装を加えます。

// Hide the keyboard.
textField.resignFirstResponder()

これでリターンキーを押したときにキーボードが隠れるようになりました。
resignFirstResponder() についてもっと知りたい場合はリファレンスを参照してください。
しかし textFieldShouldReturn は Bool を返すメソッドとして宣言をしていますが今は何も返していないのでエラーになります。
そのため、一行下に以下の実装を加えます。

return true

Xcode は補完が効くため、長いメソッド名を全て記憶してタイプミスすることなく打つ必要はありません。
今回であれば、 textField.res まで入力すると resignFirstResponder() がサジェストされるでしょう。
また、そのサジェストにはメソッドの返り値とそのメソッドの説明が（英語ですが）表示されるので 何をするメソッドなのか簡単に知ることができます。
もちろん、詳しく知りたい場合は公式ドキュメントを読むのがよいでしょう。

サジェスト

ここまでで、 UITextFieldDelegate の ViewController エクステンションは以下のようになっています。

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Hide the keyboard.
    textField.resignFirstResponder()
    return true
  }
}

次に textFieldDidEndEditing を実装します。
これは First Responder が解除された後に呼ばれるデリゲートメソッドです。
First Responder が解除された後、つまりテキストの入力が完了した後に Label にそのテキストを反映させます。

ViewController extension の textFieldShouldReturn メソッドの下に次のように デリゲートメソッドを追加します。

func textFieldDidEndEditing(_ textField: UITextField) {
}

このメソッドに次の実装を加えます。

mealNameLabel.text = textField.text

デリゲートメソッド全体は以下のようになっています。

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Hide the keyboard.
    textField.resignFirstResponder()
    return true
  }
    
  func textFieldDidEndEditing(_ textField: UITextField) {
    mealNameLabel.text = textField.text
  }
}

さて、ここまでできたら動作確認をしましょう。
アプリをシミュレータで実行し、以下の手順ができることを確認します。

キーボードでテキストを入力すると Text Field に入力される
"Custom" と入力し、キーボードの Done ボタンを押すとキーボードが隠れる
Meal Name のラベルが Custom に変化している
ラベルの文字が入力したテキストに変わる

ここまでで、 ViewController.swift は以下のようになっています。

import UIKit

class ViewController: UIViewController {

  // MARK: Properties
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var mealNameLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Handle the text field’s user input through delegate callbacks.
    nameTextField.delegate = self
  }


  // MARK: Actions
  @IBAction func setDefaultLabelText(_ sender: UIButton) {
    mealNameLabel.text = "Default Text"
  }

}

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Hide the keyboard.
    textField.resignFirstResponder()
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    mealNameLabel.text = textField.text
  }
}
Please Type!
今回はここまでです。
Storyboard で UI を作成し、 ViewController とつなげてアプリを動作させることができました。

次回からは ViewController の働きを詳しく見ていくことと、 UI をもっとカスタマイズして FoodTracker アプリを作りこんでいきます。

今回のプロジェクトは こちら です。

Simulator の iOS バージョンについて
配布プロジェクトは Xcode 12.5 / iOS 14.5 想定で作成されています。
ただ、Xcode のバージョンのよっては Simulator を起動できないといった状況に陥る可能性があります。
その場合は、Navigator area の一番上の FoodTracker を選択し、 FoodTracker の設定画面で、 General の Deployment Info が iOS14.5 と表示されている箇所を選択し、お使いの Xcode のバージョンが対応しているバージョンまで下げていただくことで Simulator が起動できる様になります。
または、Xcode 12.5 以上にあげてもらうことで Simulator が起動できる様になります。

また、こちらからXcode の各バージョンがどの iOS に対応しているかを確認することができます。

まとめ
Xcode にはエディタを分割したり、エリアの表示を切り替えたりする機能がある
Storyboard で UI のパーツを AutoLayout を使って複数の画面サイズに対応して配置できる
Storyboard と ViewController を繋げて動的な処理を ViewController で実装できる
UITextFieldDelegate のメソッドを実装すると Text Field からのイベントを受け取ることができる

---
## リンク

[UILabel](https://developer.apple.com/documentation/uikit/uilabel)

[UIButton](https://developer.apple.com/documentation/uikit/uibutton)

[UIStackView](https://developer.apple.com/documentation/uikit/uistackview)

[UITextFieldDelegate](https://developer.apple.com/documentation/uikit/uitextfielddelegate)

[resignfirstresponder()](https://developer.apple.com/documentation/uikit/uiresponder/resignfirstresponder())

[サポート - Xcode](https://developer.apple.com/jp/support/xcode/)
