//
//  FavoriteListViewController.swift
//  LojaMoveis3B1
//
//  Created by COTEMIG on 24/09/20.
//  Copyright © 2020 Cotemig. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController {

    @IBOutlet weak var tableViewFav: UITableView!
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
    
    var listFurniture: [Furniture] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewFav.delegate = self
        tableViewFav.dataSource = self
        downloadApi()
        // Do any additional setup after loading the view.
    }
    private func downloadApi() {
        let link = URL(string: "https://apilojasmoveis.herokuapp.com/products")!
        URLSession.shared.dataTask(with: link) { (data, response, error) in
            if let data = data {
                do {
                    let carApi = try JSONDecoder().decode([Furniture].self, from: data)
                    
                    self.listFurniture.append(contentsOf: carApi)
                    DispatchQueue.main.async {
                        self.tableViewFav.reloadData()
                    }
                    
                } catch {
                    print("Erro de parse")
                }
            }
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ViewController = segue.destination as! FavDetailViewController
        
        let furniture = sender as! Furniture
        
        ViewController.id = furniture.id
        ViewController.imagesLinks = furniture.images
        ViewController.tittle = furniture.name
        ViewController.price = String(furniture.price)
        ViewController.desc = furniture.welcomeDescription
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

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFurniture.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewFav.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! Cell
        
        cell.priceLabel.text = String(listFurniture[indexPath.row].price)
        cell.tittleLabel.text = String(listFurniture[indexPath.row].name)
        print(listFurniture[indexPath.row].images[0])
        downloadImage(link: listFurniture[indexPath.row].images[0], object: cell.imageFurniture)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let furniture = listFurniture[indexPath.row]
        performSegue(withIdentifier: "segueDetail", sender: furniture)
    }
}
