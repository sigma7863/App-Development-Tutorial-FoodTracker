//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Sigma7863 on 2025/12/23.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    // MARK: Properties
    var meals = [Meal]()

    override func viewDidLoad() {
        if #available(iOS 15, *) {
            // iOS 15 以降の場合にのみ実行される
            tableView.fillerRowHeight = UITableView.automaticDimension
        }
        
        super.viewDidLoad()

        // テーブル ビュー コントローラによって提供される編集ボタン項目を使用します。(Use the edit button item provided by the table view controller.)
        navigationItem.leftBarButtonItem = editButtonItem

        // 保存した食事を読み込み、そうでない場合はサンプル データを読み込みます。(Load any saved meals, otherwise load sample data.)
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            // Load the sample data.
            loadSampleMeals()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    // Table View のセクション数を決めるデリゲートメソッド
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    // 列ごとに表示するセルを決めるデリゲートメソッド
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する(ユーザが Table View をスクロールすると新しいセルが作られ、見えなくなったセルが削除される代わりに Table View はセルを再利用しようとする, 再利用できない場合は新しくセルを作成する, これによりスクロールしてもアプリが重くなることなく利用できるようになっている。)
        // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) // withIdentifier: どの型セルを再利用または作成するかを決めるもの
        
        // テーブルビューのセルは再利用されるため、セル識別子を使用してキューから取り出す必要があります(Table view cells are reused and should be dequeued using a cell identifier)
        let cellIdentifier = "MealTableViewCell"

        // UITableViewCell から MealTableViewCell へのダウンキャストが発生するので guard 文で早期リターンをさせる
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not instance of MealTableViewCell.") // キューから削除されたセルは MealTableViewCell のインスタンスではありません。
        }

        // データ ソース レイアウトに適したmealを取得します。(Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]

        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        // print("""
        // --- prepare(for:) ----
        // identifier: \(String(describing: segue.identifier))
        // destination: \(type(of: segue.destination))
        // sender: \(String(describing: sender))
        //  -----------------------
        //  """)

        // segue.identifier の型は Optional<String> で nil になりえるが
        // 今回 nil の場合は想定していないので nil 結合演算子により nil の場合は空文字に変換して String 型を switch 文に渡している
        switch segue.identifier ?? "" {
            case "AddItem":
                os_log("Adding a new meal.", log: .default, type: .debug)
            case "ShowDetail":
                guard let mealDetailViewController = segue.destination as? MealDetailViewController else {
                    fatalError("Unexpected destination: \(segue.destination)") // 予期せぬ宛先:
                }

                guard let selectedMealCell = sender as? MealTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))") // 予期せぬ送信者:
                }

                guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                    fatalError("The selected cell is not being displayed by the table") // 選択したセルはテーブルに表示されません
                }

                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            default:
                break
                // fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    // MARK: Actions
    // MealViewController で作成された新しい Meal オブジェクトを MealTableViewController に追加し反映する
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealDetailViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow { // 遷移が新規追加か編集かを判定する
                // 既存のmealを更新する。(Update an exsisting meal.)
                meals[selectedIndexPath.row] = meal // 選択された位置のデータを更新
                tableView.reloadRows(at: [selectedIndexPath], with: .none) // Table Viewの表示を更新
            } else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)

                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic) // TableViewに行を追加する
            }

            // Save the meals.
            saveMeals()
        }
    }

    // MARK: Private Methods
    private func loadSampleMeals() {
        let photo1 = #imageLiteral(resourceName: "meal1")
        let photo2 = #imageLiteral(resourceName: "meal2")
        let photo3 = #imageLiteral(resourceName: "meal3")

        guard let meal1 = Meal(name: "Hamburger", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1") // meal1 をインスタンス化できません
        }

        guard let meal2 = Meal(name: "Sushi Bento", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2") // meal2 をインスタンス化できません
        }

        guard let meal3 = Meal(name: "Grilled Beef", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3") // meal3 をインスタンス化できません
        }

        meals += [meal1, meal2, meal3]
    }

    private func saveMeals() {
        // 保存できる形式にした Meal オブジェクトを適切な場所に保存する
        guard let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false) else {
            fatalError("Unable to aechive meals") // mealsをアーカイブできません
        }

        // アーカイブしたデータをファイルに保存し、結果に対してログ出力をする
        do {
            try archivedData.write(to: Meal.ArchiveURL)
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }

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

}
