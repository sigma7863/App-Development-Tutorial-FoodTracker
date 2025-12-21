基本的な UI を作ろう 3

前回に引き続き「フードトラッカー」アプリを開発していきます。
前回はレーティングの UI を途中まで作成しましたが、今回でそれを完成させます。
また、レーティングを行った際のデータの処理も行っていきます。
ついに ViewController クラスを完成させます。

今回の環境は、

macOS Big Sur 11.4
Xcode 12.5.1 (12E507)
です。

前回までに作成したプロジェクトは こちら です。

目次
【実習】UI をカスタマイズしよう
InterfaceBuilder でできることを増やそう
ボタンに画像を設定しよう
ボタンのアクションを実装しよう
アクセシビリティを設定しよう
RatingControl を ViewController と繋げよう
プロジェクトをきれいにしよう
【実習】データモデルを定義しよう
データモデルを作ろう
【講義】ユニットテストについて知ろう
【実習】ユニットテストをしよう
まとめ
【実習】UI をカスタマイズしよう
前回、食事のレーティングを行う RatingControl クラスを作成しました。
ここまでで赤い四角のボタンを表示できていますが、さらにこのコントロールをカスタマイズしていきましょう。

InterfaceBuilder でできることを増やそう
Main.storyboard を開くと、 ViewController scene が表示されます。
UI を編集するツールを総称して InterfaceBuilder といいますが、 InterfaceBuilder を 拡張してできることを増やしていきます。

現在の見た目は以下の図のようになっており、 RatingControl は透明な四角が表示されているだけです。

RatingControl の制約エラー
枠が赤くなっているのは制約のエラーが出ているためです。
この RatingControl の中身がどうなっているかは ViewController scene を見ただけではわからず、 RatingControl.swift の実装をみるか実際にシミュレーターで実行しなければいけません。
これでは UI の調整をするのに不便なので、 RatingControl がどのような UI になっているのかを この ViewController scene に表示させてみましょう。

InterfaceBuilder を拡張するにはソースコードに @IBDesignable 属性をつけます。
この属性をつけると InterfaceBuilder がそのクラスを描画して反映するため カスタマイズした UI をプレビューするのに向いています。
RatingControl に @IBDesignable をつけてみましょう。

まず、 RatingControl.swift を開きます。
クラス宣言は以下のようになっています。

class RatingControl: UIStackView {

これに @IBDesignable を加えて以下のようにします。

@IBDesignable class RatingControl: UIStackView {

ここで、 command ⌘ + B を押してプロジェクトをビルドします。
すると Main.storyboard に RatingControl が反映され赤いボタンが現れます。
と同時に赤色の枠も消え、制約も RatingControl.swift で指定したものになっていることがわかります。

IBDesignable の反映
このようにカスタムの UI を InterfaceBuilder に反映させるにはクラスに @IBDesignable 属性を つけ、再度ビルドする必要があります。

InterfaceBuilder でカスタム View を表示させることができました。
それだけではなく Attribute inspector でプロパティを変更することもできます。
カスタムクラスのプロパティを Attribute inspector に反映させるには、　@IBInspectable 属性を使用します。
@IBInspectable 属性は 真偽値、数値、文字列といった基本型に加え CGRect、 CGSize、 CGPoint、 UIColor に設定できます。

RatingControl.swift の // MARK: Properties セクションに以下の二行を加えましょう。

@IBInspectable var starSize: CGSize = CGSize(width: 50.0, height: 50.0)
@IBInspectable var starCount: Int = 5

これらはボタンのサイズとボタンの数を定義するプロパティです。
今まではこれらを setupButtons() で定数で定めていましたが、これらの変数を使用するように修正しましょう。
修正するポイントは以下です。

for-in ループの宣言箇所を 5 から starCount にします。
button.heightAnchor.constraint() の引数を 50.0 から starSize.height にします。
button.widthAnchor.constraint() の引数を 50.0 から starSize.width にします。
これらの修正を終えると setupButtons() 全体は以下のようになっています。

private func setupButtons() {
    for _ in 0..<starCount {
        // Create the button
        let button = UIButton()
        button.backgroundColor = UIColor.red

        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

        // Setup the button action
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)

        // Add the button to the stack
        addArrangedSubview(button)

        // Add the new button to rating button array
        ratingButtons.append(button)
    }
}

次に、 Main.storyboard を開き RatingControl を選択します。
Attributes inspector を選択すると下図のように Star Size と Star Count を設定するセクションができていることを確認しましょう。

Star Count を設定するセクション
ここで入力された値を RatingControl に反映させるにはそれぞれのプロパティに property observer を設定します。
property observer とはプロパティの値の変化を監視してなんらかの処理が行えるようにする機能のことです。

RatingControl.swift を開き、先ほど @IBInspectable 属性を指定したプロパティを以下のように書き換えましょう。

@IBInspectable var starSize: CGSize = CGSize(width: 50.0, height: 50.0) {
    didSet {
        setupButtons()
    }
}

@IBInspectable var starCount: Int = 5 {
    didSet {
        setupButtons()
    }
}

property observer を設定するには、プロパティの宣言の後に波括弧 {} で囲います。
その中に observer を記述します。
observer 名の後に波括弧 {} で囲い、そのタイミングで行いたい処理を記述します。

observer には以下の二種類があります。

イベント	発火タイミング
willSet	値が変更される直前に発火
didSet	値が変更された直後に発火
今回は didSet なので、それぞれのプロパティの値が変更された後に　setupButtons() を呼び出す処理に なっています。

これで starSize、 starCount プロパティの変更に対応することができました。
しかしこのままでは問題があります。

それぞれのプロパティが変更されるごとに setupButtons() が呼ばれます。
このメソッドは新しいボタンを追加するメソッドだったため、複数回呼ばれると次々に新しいボタンを View に追加してしまいます。
プロパティが変更され、複数回 setupButtons() が呼ばれても問題のない処理にするために 古いボタンを消去する処理を追加しましょう。

setupButtons() メソッドの先頭に以下のコードを追加し、既にあるボタンを消去してから新しくボタンを追加しましょう。

// Clear any existing buttons
for button in ratingButtons {
    removeArrangedSubview(button)
    button.removeFromSuperview()
}
ratingButtons.removeAll()

現在 RatingControl に載っているボタンは ratingButtons に格納されています。
for-in ループで ratingButtons のボタンを View から取り除くことを行っています。
その後の ratingButtons.removeAll() で ratingButtons を空配列にして ratingButtons を初期化しています。

ここまでで setupButtons() メソッド全体は以下のようになっています。

private func setupButtons() {

    // Clear any existing buttons
    for button in ratingButtons {
        removeArrangedSubview(button)
        button.removeFromSuperview()
    }
    ratingButtons.removeAll()

    for _ in 0..<starCount {
        // Create the button
        let button = UIButton()
        button.backgroundColor = UIColor.red

        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

        // Setup the button action
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)

        // Add the button to the stack
        addArrangedSubview(button)

        // Add the new button to rating button array
        ratingButtons.append(button)
    }
}

Main.storyboard を開き、 RatingControl を選択しましょう。
Attributes inspector の RatingControl セクションで Star Size や Star Count を変更してみましょう。
その際に Storyboard 上で即座に表示が変更されることを確認しましょう。
また、シミュレーターで実行をしてその表示がシミュレーターでも反映されていることを確認しましょう。

大きさや数を設定できる
@IBDesignable と @IBInspectable 属性によりカスタム View でも InterfaceBuilder と連携させることができました。

ボタンに画像を設定しよう
赤い四角のボタンでは見栄えがよくなく、どのような状態かもわからないので画像を設定しましょう。

以下の3種類の画像を設定します。
左から

empty
filled
highlighted
という状態を表します。

empty filled highlighted
empty は未選択状態、filled は選択状態、 highlighted は選択中の（ハイライト）状態です。

Assets.xcassets を開きます。
次に左下の + ボタン（下図を参照してください）をクリックして [Folder] を選択します。

New Folder
するとディレクトリができるのでダブルクリックして名前を Rating Images に変更して return を押します。

このディレクトリを選択した状態で左下の + ボタンをクリックして New Image Set を選択します。
Image という Image Set ができるのでダブルクリックして名前を emptyStar に変更して return を押します。

ここで、これから使用する画像をダウンロードしましょう（前回ダウンロード済みならば必要ありません）。

Images.zipをダウンロード

Images ディレクトリの画像を Assets に追加します。

emptyStar.png を 2x のスロットにドラッグ&ドロップします。
今回は iPhone 11 Pro のシミュレーターでの実行を想定するためそれに対応した 2x の解像度がよいでしょう。

これで emptyStar の画像を追加できました。
filled、 highlighted の場合も同様に Image Set を作成します。

Assets.xcassets の Rating Images ディレクトリを選択し、左下の + ボタンをクリックして Image Set を選択します。
新しくできた Image Set の名前を filledStar に変更します。

filledStar.png を 2x のスロットにドラッグ&ドロップします。

もう一度左下の + ボタンから Image Set を選択し、できた Image Set の名前を highlightedStar にします。

highlightedStar.png を 2x のスロットにドラッグ&ドロップします。

合計 3 つの Image Set が作成できました。
現在の Assets.xcassets は以下のようになっています。

3 つの Image Set
もし画像を間違った場所に追加してしまった場合はその画像を選択して Delete キーを押せば削除できます。

次にこれらの画像を適切に出し分けるコードを書いていきます。

RatingControl.swift を開き、 setupButtons() メソッドを探します。
setupButtons() の for-in ループの前に以下のコードを挿入します。

// Load Button Images
let bundle = Bundle(for: type(of: self))
let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)

このとき、追加した画像と同名の文字列、例えば filledStar など入力しようとすると下図のように画像とともに補完されますが、 ここでは補完に頼らないでください。

画像とともに出る補完は使わない
このように画像とともに表示される補完は UIImage そのものを表しています。
Xcode 8 からは画像と色のリテラルが追加され、 Xcode 上で直接画像や色をプレビューできるようになりました。
今回は画像や色ではなく文字列を記述したいので補完をしないようにしてください。

今追加したコードは、 assets catalog から画像を取得するためのものです。

Bundle（バンドル）はリソースの置いてある場所と捉えればよいです。
基本的にアプリはメインとなるバンドル（メインバンドル）を持っています。
assets catalog はメインバンドルに含まれています。
しかし RatingControl クラスは @IBDesignable 属性がついており、 InterfaceBuilder から初期化されます。
つまり画像は InterfaceBuilder から取得することになるためメインバンドルではなく自身のバンドルを明示するようにしています。

次に、 button.backgroundColor = UIColor.red の行を探し、それを削除して以下のコードを挿入します。

// Set the button images
button.setImage(emptyStar, for: .normal)
button.setImage(filledStar, for: .selected)
button.setImage(highlightedStar, for: .highlighted)
button.setImage(highlightedStar, for: [.highlighted, .selected])

ボタンには状態があり、それは UIControlState によって表されます。
これらの状態のうち UIButton で使用するのは normal selected highlighted の三種類です。
通常時（未選択時）は emptyStar を表示し、タップ中などのハイライト時には highlightedStar を表示し、 選択時は filledStar を表示します。
また、最後にハイライト時と選択時の両方で highlightedStar を指定しているのは、ハイライト状態なのか選択状態なのかに関わらず ユーザが一度ボタンをタップした時に highlightedStar を表示させるためです。

setupButtons() 全体は以下のようになっています。

private func setupButtons() {

    // Clear any existing buttons
    for button in ratingButtons {
        removeArrangedSubview(button)
        button.removeFromSuperview()
    }
    ratingButtons.removeAll()

    // Load Button Images
    let bundle = Bundle(for: type(of: self))
    let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
    let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
    let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)

    for _ in 0..<starCount {
        // Create the button
        let button = UIButton()

        // Set the button images
        button.setImage(emptyStar, for: .normal)
        button.setImage(filledStar, for: .selected)
        button.setImage(highlightedStar, for: .highlighted)
        button.setImage(highlightedStar, for: [.highlighted, .selected])

        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

        // Setup the button action
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)

        // Add the button to the stack
        addArrangedSubview(button)

        // Add the new button to rating button array
        ratingButtons.append(button)
    }
}

ここまででシミュレーターで実行をしてみましょう。
ボタンに emptyStar の画像が設定されていて、ボタンをタップ（PC からの操作の場合はクリック）すると highlightedStar になることを確認しましょう。
filledStar は現れません。
これは ratingButtonTapped(_:) でログ出力しかしておらずボタンの状態を変化させていないからです。

タップすると highlightedStar になる
ボタンのアクションを実装しよう
ユーザはボタンをタップしたらレーティングができるようにする必要があります。
今はログ出力をするだけなのでここを実装していきましょう。

RatingControl.swift の ratingButtonTapped(_:) メソッドは以下のようになっています。

@objc func ratingButtonTapped(button: UIButton) {
    print("Button pressed 👍")
}

この print 文を削除し、以下のように書き換えます。

@objc func ratingButtonTapped(button: UIButton) {
    guard let index = ratingButtons.firstIndex(of: button) else {
        fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
    }

    // Calculate the rating of the selected button
    let selectedRating = index + 1

    if selectedRating == rating {
        // If the selected star represents the current rating, reset the rating to 0.
        rating = 0
    } else {
        // Otherwise set the rating to the selected star
        rating = selectedRating
    }
}

firstIndex(of:) メソッドは引数の要素が配列にあるかどうかを判定し、あればその最初の添字を返し、なければ nil を返します。
つまり、返り値の型は Int? であり、存在する場合のみに次の処理を行わせたいので guard 文で早期リターンをしています。
また、引数の要素が見つからない場合を今回は想定していないので guard 文の中身を fatalError で強制終了させるようにしています。
fatalError は無引数でもよいですが、デバッグ時にその状況に陥った場合に原因の特定を進めやすくするために 今回のようにログ出力をさせるのを推奨します。

その後の処理を説明します。
配列の添字は 0 から始まるため実際のレーティングは添字に +1 したものになります。
それが selectedRating になります。
現在のレーティングと selectedRating が同じならレーティングをリセットし、異なれば selectedRating を 新しいレーティングに設定します。

次に、レーティングが設定されたらボタンの表示を変化させる実装をします。
RatingControl クラスの　// MARK: Private Methods セクションに以下のメソッドを実装しましょう。
同じセクションには setupButtons() メソッドがありますが、これから実装するのはこの setupButtons() から 呼ばれるものになるので処理の順番的に setupButtons() の下に実装するのがよいでしょう。

private func updateButtonSelectionStates() {

}

レーティングされたら ratingButtons に含まれるボタンの選択状態を変化させます。
以下のように for-in ループを使って実装をします。

private func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerated() {
        // If the index of a button is less than the rating, that button should be selected.
        button.isSelected = index < rating
    }
}

配列の enumerated() メソッドを呼ぶと配列の添字と要素がタプルで取得できます。
そのボタンの選択状態を表す isSelected プロパティを添字がレーティングより小さいかどうかで設定しています。

次にこの updateButtonSelectionStates() を呼びます。
レーティングが変更されたらボタンの見た目を変化させるので、 rating プロパティに property observer を設定します。

var rating = 0 {
    didSet {
        updateButtonSelectionStates()
    }
}

また、ボタンの作成時にも見た目を設定する必要があるので setupButtons() の一番最後に updateButtonSelectionStates() を追加します。

private func setupButtons() {

    // Clear any existing buttons
    for button in ratingButtons {
        removeArrangedSubview(button)
        button.removeFromSuperview()
    }
    ratingButtons.removeAll()

    // Load Button Images
    let bundle = Bundle(for: type(of: self))
    let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
    let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
    let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)

    for _ in 0..<starCount {
        // Create the button
        let button = UIButton()

        // Set the button images
        button.setImage(emptyStar, for: .normal)
        button.setImage(filledStar, for: .selected)
        button.setImage(highlightedStar, for: .highlighted)
        button.setImage(highlightedStar, for: [.highlighted, .selected])

        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

        // Setup the button action
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)

        // Add the button to the stack
        addArrangedSubview(button)

        // Add the new button to rating button array
        ratingButtons.append(button)
    }

    updateButtonSelectionStates()
}

ここまでできたらシミュレーターで実行してみましょう。
星をクリックすると左からクリックした星までが filledStar になり、もう一度その星をクリックすると 0 に戻ります。

星をクリックして filledStar になる。

アクセシビリティを設定しよう
iOS には アクセシビリティ という機能があります。
これは特別なニーズがある人を含めたすべてのユーザがアプリを使えるようにする機能で、 VoiceOver や Switch Control、 Guided Access、テキストスピーチなどの機能がそれにあたります。

多くの場合、特別な実装なしでユーザはこれらの機能を使えます。しかし、 VoiceOver には注意しないといけません。
VoiceOver は盲目や視力の弱いユーザのための革命的なスクリーンの読み上げ機能です。
VoiceOver は UI がどのようなものになっているのかを読み上げてユーザに伝えます。
基本的な UI は元から読み上げ機能が備わっていますが、カスタム View にそれは適用されないので設定する必要があります。

RatingControl では以下のような情報を追加する必要があります。

種類	説明	例
Accessibility label	その View を端的に表す単語やフレーズ	"Add", "Play"
Accessibility value	その要素の現在の値	"50%"
Accessibility hint	その要素のアクションの説明を表すフレーズ	"Adds a title" "Opens the shopping list."
RatingControl の例を以下に示します。

種類	例
Accessibility label	"Set 1 star rating."
Accessibility value	"4 stars set."
Accessibility hint	"Tap to reset the rating to zero."
このように VoiceOver できるように実装をしていきましょう。
まず、 RatingControl.swift の setupButtons() メソッドの for-in ループが以下のような宣言になっていることを確認します。

for _ in 0..<starCount {

このループ内でボタンを生成し、その際に Accessibility label を設定するので添字が必要になります。

ここを以下のように書き換え、ループ内で添字が使用できるようにします。

for index in 0..<starCount {

また、ループ内で制約を設定した後に以下のコードを加えます。

// Set the accessibility label
button.accessibilityLabel = "Set \(index + 1) star rating"

setupButtons() 全体は以下のようになっています。

private func setupButtons() {

    // Clear any existing buttons
    for button in ratingButtons {
        removeArrangedSubview(button)
        button.removeFromSuperview()
    }
    ratingButtons.removeAll()

    // Load Button Images
    let bundle = Bundle(for: type(of: self))
    let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
    let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
    let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)

    for index in 0..<starCount {
        // Create the button
        let button = UIButton()

        // Set the button images
        button.setImage(emptyStar, for: .normal)
        button.setImage(filledStar, for: .selected)
        button.setImage(highlightedStar, for: .highlighted)
        button.setImage(highlightedStar, for: [.highlighted, .selected])

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

次に updateButtonSelectionStates() メソッドにアクセシビリティを設定します。
for-in ループの、isSelected プロパティの設定の後に以下のコードを加えます。

// Set the hint string for the currently selected star
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

// Assign the hint string and value string
button.accessibilityHint = hintString
button.accessibilityValue = valueString

updateButtonSelectionStates() メソッド全体は以下のようになっています。

private func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerated() {
        // If the index of a button is less than the rating, that button should be selected.
        button.isSelected = index < rating

        // Set the hint string for the currently selected star
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

        // Assign the hint string and value string
        button.accessibilityHint = hintString
        button.accessibilityValue = valueString
    }
}

これで RatingControl は VoiceOver に対応できました。
VoiceOver を有効にした端末でアプリを起動し、ボタンにタップすると VoiceOver がボタンのラベルを読み上げます。
ただしシミュレーターでは VoiceOver が使えないため、 Accessibility Inspector を使用します。
Xcode > Open Developer Tool > Accessibility Inspector から開きます。
図で赤い枠で囲まれたボタンを押してRating Control の星を指し示すと、先ほど設定したように Label や Value が確認できます。 また、▷ボタンを押すと、設定した内容を読み上げてくれます。

Accessibility Inspector
確認が終わったら　Accessibility Inspector を終了しておきましょう。
アクセシビリティについてもっと知るには、公式ドキュメント (英語) を読んでみてください。

＊注意：

星のボタンなどの個々の部品を選択できず、シミュレーターのウィンドウが選択されてしまう場合についての情報です。
Xcode 13.3.1 以降のバージョンでは Accessibility Inspector に問題がある可能性があります。
残念ながら、今のところおすすめできる対処法は、今後の修正を待つことのみです。
この問題についての詳細は Apple Developer Forums などを参照してください。

RatingControl を ViewController と繋げよう
最後に RatingControl を ViewController と繋げて、コードから参照できるようにします。

まずは Main.storyboard を開きます。
次に Assistant editor を開きます。
Assistant editor は Xcode の以下のようなプルダウンから開きます。

Assistant editor
なお、Xcode の画面サイズが小さい場合、Assistant Editor と ViewController が横並びではなく縦に並んで表示されることがあります。その場合は、次のようにして「Assistant on Right」を選択することで、横並びに変更できます。

Assistant editor と ViewController を横並びで表示する
右側に ViewController.swift が表示されていることを確認します。
表示されていなければ、 Automatic を Manual に切り替えて FoodTracker > FoodTracker > ViewController.swift を選択します。

Main.storyboard の RatingControl を選択し、 control ⌃ + ドラッグ をして ViewController の photoImageView プロパティの下でドロップします。

RatingControl を ViewController と接続
ダイアログが現れるので Name を ratingControl にして Connect ボタンをクリックします。

これで RatingControl が ViewController と接続できました。

プロジェクトをきれいにしよう
いよいよ ViewController scene を完成させます。

まずは Assistant Editor 左上の「閉じる」ボタンをクリックしてエディタを元に戻します。
必要があれば Navigator toggle や Utilities toggle をクリックして表示を戻しましょう。
「閉じる」ボタンは以下の画像のような位置にあります。

Assistant Editor を閉じる
Main.storyboard を開きます。
ラベルが左端に寄っているのを中央揃えにすることと、ラベルを初期状態に戻す　Set Default Label Text を削除します。

まずは Set Default Label Text を選択し、 Delete キーを押します。
すると下図のようにボタンが消え、 Image View より下が上に寄ります。

Set Default Label Text の削除
次に中央揃えにします。
Stack View を選択し、 Attribute inspector を開きます。

Alignment が Leading になっているので、プルダウンから Center を選択します。
すると下図のように中央揃えになりました。

Alignment を center に設定
中央揃え
忘れてはいけないのが、 Set Default Label Text の IBAction が ViewController に紐付けられていたということです。
これを削除しないと実行時に IBAction が紐付け元を探すが見つからずクラッシュすることになります。

ViewController.swift を開き、 setDefaultLabelText(_:) メソッドを探します。

@IBAction func setDefaultLabelText(_ sender: UIButton) {
    mealNameLabel.text = "Default Text"
}

このメソッドを削除します。

そして最後にシミュレーターで実行を行い動作確認をしましょう。
SetDefaultTextButton がなくなっていること、要素が中央揃えになっていること、 すべてのボタンが動作することを確かめてください。

もしも何か問題が起きてビルドできない場合は command ⌘ + shift ⇧ + K を押してクリーンをしてから再度実行してみてください。

ViewController scene はこれで完成です。お疲れ様でした。

次からはアプリのデータモデルを設計していきます。

【実習】データモデルを定義しよう
今節はここまでで UI について学びましたが、後半は データモデル について学んでいきます。
データモデルはアプリ内に保持されたデータの構造を表すものです。
今回は ViewController scene を表示するのに必要な情報をデータモデルとして定義してみましょう。

データモデルを作ろう
以下の要素をもつ、シンプルなクラスを定義します。

名前
写真
レーティング
この要素があれば ViewController scene 上で表示できる情報をカバーできます。

まずは以下の手順に従ってクラスを作成していきましょう。

メニューの File > New > File を選択します（または command ⌘ + N を押します）。
iOS のカテゴリの、 Swift File を選択して Next を押します。
Swift File の選択
Save as: の項目を　Meal.swift にします。
保存場所がプロジェクトディレクトリになっていることを確認します（グループは FoodTracker です）。
Target が FoodTracker にチェックが入り、 FoodTrackerTests にチェックが入っていないことを確認します。
Create を押します。
Meal.swift ファイルの保存
Meal.swift が作成されエディタに表示され、 Project navigator 上にも表示されていることを確認します。

今回は RatingControl クラスの作成時とは異なった方法で作成しました。
RatingControl の時は Cocoa Touch Class を選択しましたが、 これは UIStackView のサブクラスにしたかったためです。
Meal クラスは何も継承しないクラスにするため単純な Swift File として作成しました。

Meal クラスの実装に入ります。
上で示した要素に対応する型は以下のようになります。

要素	型
名前	String
写真	UIImage?
レーティング	Int
名前とレーティングは必須要素で、写真はない場合も考慮して Optional にします。

Meal.swift を開きます。
現在は以下のようになっています。

import Foundation

これを Foundation から UIKit に書き換えます。

import UIKit

Xcode が新しく Swift File を作る時、デフォルトでは Foundation フレームワークが import されています。
今回は写真で UIImage 、つまり UIKit フレームワークのクラスを使うので UIKit を import する必要があります。
また UIKit フレームワークは Foundation フレームワークを内包しているので UIKit を import するだけで Foundation フレームワークを明示して import する必要はなくなります。

続いて以下のように Meal クラスを定義します。

class Meal {

    // MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int

}

それぞれのプロパティは var で宣言してあります。これはインスタンス作成後に要素が変更されるためです。
変更する必要がない場合は let で宣言をしてください。

次に初期化関数を追加します。
初期化は英語で Initialization ですので、略して init となっています。
プロパティ宣言の下に追加してください。

// MARK: Initialization
init(name: String, photo: UIImage?, rating: Int) {

}

初期化関数ではプロパティをそれぞれ初期化する必要があります。
初期化関数の中で以下のように初期化をしましょう。

// Initialize stored properties
self.name = name
self.photo = photo
self.rating = rating

ここで左辺が self. となっていますが、これはクラスのプロパティを表します。
引数の name と名前が衝突する場合は self. をつけることによってクラスのプロパティを指すようになります。

次に初期化ができない場合を考えます。
名前は文字列ですが、文字列には空文字も含まれます。その場合は何も表示ができないことになってしまうので初期化失敗にします。
レーティングは整数ですが、整数には負の数も含まれます。その場合は想定していないので初期化失敗にします。

以上をコードで表すと以下になります。
先ほどの // Initialize stored properties の上部に追加してみましょう。

// Initialization should fail if there is no name or if the rating is negative.
if name.isEmpty || rating < 0 {
    return nil
}

String 型の isEmpty プロパティは、文字列が空文字かどうかを判定します。

すると return nil の行にエラーが発生します。
赤い丸をクリックすると Only a failable initializer can return 'nil' Use init? to make the initializer init(name:photo:rating:) failable と表示されるので Fix を押して修正しましょう。

すると初期化関数の宣言が以下のように変わっています。

init?(name: String, photo: UIImage?, rating: Int) {

初期化が失敗した場合は nil を返すようにしたため、初期化関数の返り値が Meal から Meal? になりました。

ここまでで Meal クラスは以下のようになっています。

import UIKit

class Meal {

    // MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int

    // MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {

        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }

        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
Please Type!
ここまでできたらプロジェクトをビルドしてみましょう。
メニューの Product > Build を選択します（または command ⌘ + B を押します）。
ビルドが通れば成功です。

Meal クラスを追加しただけで、このクラスは今のところ UI に関係していないので シミュレーターで実行する必要はなく、コンパイルが通るかどうかを調べれば十分なのでビルドをしました。

【講義】ユニットテストについて知ろう
ロジック部分を実装したら ユニットテスト が必要です。
今実装したデータモデルを他の部分から参照した場合にそれが正しく動作しているかどうかを知るには シミュレーターでの実行だけでは難しい部分があります。
それをカバーするために「ユニットテスト」があります。

Xcode でユニットテストを行うためのフレームワークに XCTest があります。

今回の FoodTracker を例にとると、デフォルトで以下のようなテストケースが作成されています。

import XCTest
@testable import FoodTracker

final class FoodTrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
Please Type!
XCTest フレームワークを import し、ユニットテストをするためのクラスを XCTestCase のサブクラスとして作成します。
テスト対象のフレームワークを @testable 属性をつけて import します。
@testable 属性はテストのための属性です。
テストはアプリ本体とフレームワークが分かれています。
別のフレームワークを参照する時は open または public なアクセス修飾子がついたメソッド・プロパティにしかアクセスできません。
しかし @testable 属性をつけると internal ものにもアクセスできるようになります。
これにより、本来なら必要ないがテストのために public にするという事態を防ぎアプリ本体のコードを汚さずに テストを行うことができるようになっています。

XCTestCase のサブクラスでは 2 つのメソッドをオーバーライドします。

setUp()
tearDown()
setUp() はテストを行う前に呼ばれ、ここで前提条件を設定します。
tearDown() はテストを行った後に呼ばれ、ここでテストによって変更された要素をリセットします。

テスト自体はメソッドを作成しそこに記述します。
今回の例では testExample() と testPerformanceExample() がそれにあたります。

各メソッドでアサーションを記述し、それが正しいかどうかをテストするということになります。
アサーションには XCTAssert(_:_:file:line:) 関数が 基本になり、第一引数が true ならテスト成功、 false ならテスト失敗となります。
この第一引数を使いやすくするために XCTAssertNil(_:_:file:line:) や XCTAssertEqual(_:_:_:file:line:) などの関数があります。
他にはドキュメントを参照してください。

また、パフォーマンスを計測することもできます。
testPerformanceExample() には

self.measure {
    // Put the code you want to measure the time of here.
}

というブロックが用意されています。
この中にアサーションを記述すると実行にかかった時間を計測します。
処理速度を気にする場合はこれを使用します。

また、テストを実行すると下図のようにエディタの左端にマークがつきます。
これによりどのテストケースが成功/失敗をしたのかが一目でわかるようになっています。

テストを実行した後
さて、これから実際にテストを書いていきましょう。

【実習】ユニットテストをしよう
Project navigator にて FoodTrackerTests グループにある FoodTrackerTests.swift を開きましょう。
既にいくつかのメソッドがありますが、削除して以下の状態にします。

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {

}

この FoodTrackerTests クラスの中に以下のコメントを記述します。

// MARK: Meal Class Tests

これで、どのクラスをテストするのかわかりやすくなります。

このコメントの下にテスト用のメソッドを実装します。

// Confirm that the Meal initializer return a Meal object when passed valid parameters.
func testMealInitializationSucceeds() {

}

ここに初期化が正しく行われる場合のアサーションを記述していきます。

// Zero rating
let zeroRatingMeal = Meal(name: "Zero", photo: nil, rating: 0)
XCTAssertNotNil(zeroRatingMeal)

// Highest positive rating
let positiveRatingMeal = Meal(name: "Positive", photo: nil, rating: 5)
XCTAssertNotNil(positiveRatingMeal)

レーティングの境界条件を設定して正しく初期化できるかをチェックしています。
レーティングは 0 から 5 の間であるという前提があるので、これが境界になります。
このようにテストケースには境界条件を適切に定める必要があります。

次に初期化が失敗する場合のアサーションを記述していきます。
以下のメソッドを実装します。

// Confirm that the Meal initializer returns nil when passed a negative rating or an empty name.
func testMealInitializationFails() {

}

ここには初期化を失敗させる条件を記述します。

// Negative rating
let negativeRatingMeal = Meal(name: "Negative", photo: nil, rating: -1)
XCTAssertNil(negativeRatingMeal)

// Empty String
let emptyStringMeal = Meal(name: "", photo: nil, rating: 0)
XCTAssertNil(emptyStringMeal)

これらはレーティングが負の数や名前が空文字の場合は nil を返すことを確認するアサーションです。

また、先ほど「レーティングが 0 から 5 の間である」という境界を設定しました。
つまり以下のケースも初期化が失敗するということなので、追加します。

// Rating exceeds maximum
let largeRatingMeal = Meal(name: "Large", photo: nil, rating: 6)
XCTAssertNil(largeRatingMeal)

5 を超えた値、たとえば 6 は失敗するということです。

ここまでできたらテストを実行してみましょう。
メニューの Product > Test を選択します（または command ⌘ + U を押します）。
するとテストが失敗し、以下のような表示なります。

テスト失敗
Xcode は自動的に Test navigator を開きます。
エディタでは失敗したテストがハイライトされます。

今回は XCTAssertNil(largeRatingMeal) が失敗しています。
つまり、 largeRatingMeal が nil にならなかったということです。
レーティングが 6 以上の場合に初期化が失敗する処理を入れていなかったということになるので、早速修正していきましょう。

Meal.swift を開き、 init?(name:photo:rating:) の初期化関数を探します。

現在は if 文で境界条件を判定しています。

// Initialization should fail if there is no name or if the rating is negative.
if name.isEmpty || rating < 0 {
    return nil
}

「名前が空文字列またはレーティングが 0 未満の場合」これが if 文の中が実行される条件です。

確かにレーティングが 6 以上の場合は判定していないので条件を修正をする必要があります。
「名前が空文字列、またはレーティングが 0 未満、または 5 より大きい場合」となります。
このようにコードを書けばよいですが、これは少々複雑な条件です。
このように条件が複雑になる場合は判定文を複数に分けると読みやすくなります。
その場合は判定文だとわかるように、早期リターンの guard 文を使いましょう。

上記のコードを以下のように書き換えます。

// The name must not be empty
guard !name.isEmpty else {
    return nil
}

// The rating must be between 0 and 5 inclusively
guard rating >= 0 && rating <= 5 else {
    return nil
}

注意しなければいけないのは、条件式が false の場合に else 内が実行されることです。
if 文と混同しないようにしましょう。

初期化関数全体は以下のようになっています。

init?(name: String, photo: UIImage?, rating: Int) {

    // The name must not be empty
    guard !name.isEmpty else {
        return nil
    }

    // The rating must be between 0 and 5 inclusively
    guard rating >= 0 && rating <= 5 else {
        return nil
    }

    // Initialize stored properties
    self.name = name
    self.photo = photo
    self.rating = rating
}

ここまでできたら、もう一度テストを実行してみましょう。

先ほど失敗したテストも成功し、すべてのテストが成功していることを確認します。

これで作成したデータモデルが正しい振る舞いをすることが確認できました。
このようにデータモデルのようなロジックを実装する際はテストを書いて、アプリが予期しない状況で クラッシュしたり変な挙動をしたりしないようにしましょう。

今回のプロジェクトは こちら です。

まとめ
カスタム View のクラスは @IBDesignable や @IBDesignable 属性をつけることで InterfaceBuilder と連携できる
アプリで保持したい情報はデータモデルを作成することで管理できる
ユニットテストを行うことで実装したデータモデルが意図した挙動をするか確認できる

---
リンク

[リポジトリ](https://github.com/nnn-training/FoodTracker5007)

[CGRect](https://developer.apple.com/documentation/coregraphics/cgrect)

[CGSize](https://developer.apple.com/documentation/coregraphics/cgsize)

[CGPoint](https://developer.apple.com/documentation/coregraphics/cgpoint)

[UIColor](https://developer.apple.com/documentation/uikit/uicolor)

[UIControlState](https://developer.apple.com/documentation/uikit/uicontrolstate)

[firstIndex(of:)](https://developer.apple.com/documentation/swift/array/2994720-firstindex)

[enumerated()](https://developer.apple.com/documentation/swift/array/1687832-enumerated)

[isSelected](https://developer.apple.com/documentation/uikit/uicontrol/1618203-isselected)

[Accessibility](https://developer.apple.com/documentation/accessibility)

[XCTest](https://developer.apple.com/documentation/xctest)

[XCTAssert(_:_:file:line:)](https://developer.apple.com/documentation/xctest/xctassert(_:_:file:line:))

[XCTAssertnil(_:_:file:line:)](https://developer.apple.com/documentation/xctest/xctassertnil(_:_:file:line:))

[](https://developer.apple.com/documentation/xctest/1500577-xctassertequal)

[Developper Forms - Apple](https://developer.apple.com/forums/)
