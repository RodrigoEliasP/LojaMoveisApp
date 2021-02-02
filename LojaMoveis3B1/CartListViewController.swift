//
//  CartListViewController.swift
//  LojaMoveis3B1
//
//  Created by COTEMIG on 24/09/20.
//  Copyright © 2020 Cotemig. All rights reserved.
//

import UIKit
struct Furniture: Codable {
    let id: Int
    let name: String
    let price: Double
    let welcomeDescription: String
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, price
        case welcomeDescription = "description"
        case images
    }
}

class CartListViewController: UIViewController {

    @IBOutlet weak var tableViewCart: UITableView!
    var cartList: [Int] = []
    var listFurniture: [Furniture] = []
    var filter: [Furniture] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewCart.delegate = self
        tableViewCart.dataSource = self
        downloadApi()
        
    
                // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let list = UserDefaults.standard.value(forKey: "cartKey") as? [Int]{
            self.filter = []
            self.cartList.append(contentsOf: list)
            self.listFurniture.forEach { (f) in
                if self.cartList.contains(f.id){
                    self.filter.append(f)
                }
            }
        }
        print(1)
        tableViewCart.reloadData()
    }

 
    
    private func downloadApi() {
        let link = URL(string: "https://apilojasmoveis.herokuapp.com/products/")!
        URLSession.shared.dataTask(with: link) { (data, response, error) in
            if let data = data {
                do {
                    let carApi = try JSONDecoder().decode([Furniture].self, from: data)
                    
                    self.listFurniture.append(contentsOf: carApi)
                    DispatchQueue.main.async {
                        self.listFurniture.forEach { (f) in
                            
                            if self.cartList.contains(f.id){
                                self.filter.append(f)
                            }
                        }
                        self.tableViewCart.reloadData()
                    }
                    
                } catch {
                    print("Erro de parse")
                }
            }
            }.resume()
    }
    
    func downloadImage(link: String, object: UIImageView) {
        if let url = URL(string: link) {
            let dataTask = URLSession.shared
                .dataTask(with: url) { (data, response, error) in
                    if let data = data, let imagem = UIImage(data: data) {
                        print(imagem)
                        DispatchQueue.main.async {
                            object.image = imagem
                        }
                    }
            }
            dataTask.resume()
        }
    }

}

extension CartListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCart.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! Cell2
        

        self.downloadImage(link: self.filter[indexPath.row].images[0], object: cell.imgvFurniture)
        cell.lblTittle.text = self.filter[indexPath.row].name
        cell.lblPrice.text = String(self.filter[indexPath.row].price)

        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            cartList.forEach { (a) in
                if filter[indexPath.row].id == a{
                    cartList.remove(at: cartList.firstIndex(of: a)!)
                }
            }
            filter.remove(at: indexPath.row)
            UserDefaults.standard.set(self.cartList, forKey: "cartKey")
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}

