//
//  RestaurantSearch.swift
//  RestaurantMaster
//
//  Created by cuichunyang on 2020/02/09.
//  Copyright © 2020 cuichunyang. All rights reserved.
//

import UIKit
import SafariServices

class RestaurantSearch:  UIViewController, UISearchBarDelegate, UITableViewDataSource ,UITableViewDelegate, SFSafariViewControllerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText.delegate = self
        
        searchText.placeholder = "レストランの名前を入力してください"
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        
    }

    @IBOutlet weak var searchText: UISearchBar!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //レストランのリスト
    var restaurantList : [(name:String , category:String , link:URL
        , shop_image1:String
        )] = []
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //キーボードを閉じる
        view.endEditing(true)
        
        if let searchWord = searchBar.text {
            
            
            
            print(searchWord)
            
        //入力されていたら、レストランを検索
            searchRestaurant(keyword: searchWord)
            
        }
    }
    
    struct ItemJson: Codable {
        
        //レストランの名称
        let name: String?
        
        //レストランの種類
        let category: String?
        
        //掲載URL
        let url: URL?
        
        //店舗画像、QRコード画像のURL
        let image_url: ImageJson

    }
    struct ImageJson: Codable {
        let shop_image1: String?
        
    }
    //JSONのデータ構造
    struct ResultJson: Codable {
        
        //複数要素
        let rest:[ItemJson]?
    }
    
    // searchRestaurantえメソッド
    // 第一引数: keyword 選択したいワード
    func searchRestaurant(keyword : String){
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=55a3f2ffbd397ad2ea3b6226d2b898a6&name=\(keyword_encode)")else {
            return
        }
        
        print(req_url)
        
        //リクエストに必要な情報を生成
        let req = URLRequest(url: req_url)
        
        // データ転送を管理するためのセッションを生成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        // リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data , response , error) in
            
            //セッションを終了
            session.finishTasksAndInvalidate()
            
            // do try catch エラーハンドリング
            do{
                
                //JSONDecoderのインスタンスを取得
                let decoder = JSONDecoder()
                
                //受け取ったJSONデータをパース(解析)して格納
                let json = try decoder.decode(ResultJson.self,  from: data!)
                
                print(json)
                
                if let rests = json.rest {
                    
                    // レストランのリストを初期化
                    self.restaurantList.removeAll()
                    
                    // 取得しているレストランの数だけ処理
                    for rest in rests {
                        
                        //レストランの名称、レストランの種類、掲載URL、画像URLをアンラップ
                        if let name = rest.name, let category = rest.category, let url = rest.url
                            , let shop_image1 = rest.image_url.shop_image1
                            
                            {
                            
                            let restaurant = (name, category, url
                                ,shop_image1
                                )
        
                            self.restaurantList.append(restaurant)
                        }
                    }
                    
                    // Table Viewを更新する
                    self.tableView.reloadData()
                    
                    if let restaurantdb = self.restaurantList.first{
                        print("--------")
                        print("restaurantList[0] = \(restaurantdb)")
                    }
                }
                
                
            } catch {
                
                //エラーを処理
                print("エラーが出ました")
            }
        })
        
        //ダウンロード開始
        task.resume()
        
        
    }
    
    //Cellの高さを設置する
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
  
    //Cellに値を設定するdatasourceメソッド。必ず記述する必要があります
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    //レストランリストの総数
        return restaurantList.count
    }
    
    //Cellに値を設定するdatasourceメソッド。必ず記述する必要があります
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
        
        cell.textLabel?.text =
    restaurantList[indexPath.row].name
//        + "   " + restaurantList[indexPath.row].category
        
        let url: URL? = Foundation.URL(string: restaurantList[indexPath.row].shop_image1)

        print(url ?? 1)
        
        if let shop_image1 = try? Data(contentsOf: url!){
            cell.imageView?.image = UIImage(data: shop_image1)
        }else{
            print("画像を取得できません")
        }
        
        
        
        return cell
        
    }
    
    
    //Cellが選択された際に呼び出されるdelegateメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // ハイライト解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        //SFSafariViewを開く
        let safariViewController = SFSafariViewController(url: restaurantList[indexPath.row].link)
        
        // delegateの通知先を自分自身
        safariViewController.delegate = self
        
        // SafariViewが開かれる
        present(safariViewController, animated: true, completion: nil)
        
        
        
    }
    
    //SafariViewが閉じられた時に呼ばれるdelegateメソッド
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        //safariViewを閉じる
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "レストランの一覧"
    }
    
    
}
