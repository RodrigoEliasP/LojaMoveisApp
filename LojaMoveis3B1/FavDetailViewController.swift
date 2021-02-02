//
//  FavDetailViewController.swift
//  LojaMoveis3B1
//
//  Created by COTEMIG on 24/09/20.
//  Copyright © 2020 Cotemig. All rights reserved.
//

import UIKit

class FavDetailViewController: UIViewController {

    
    @IBOutlet weak var imgvDetail: UIImageView!
    @IBOutlet weak var labelTittle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    var cartList: [Int] = []
    var imagesLinks: [String] = []
    
    var imageIndex = 0
    var id = 0
    var tittle: String?
    var price: String?
    var desc: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage(link: imagesLinks[imageIndex], object: imgvDetail)
        imageIndex += 1
        labelDesc.text = desc
        labelPrice.text = price
        labelTittle.text = tittle
        
        if let list = UserDefaults.standard.value(forKey: "cartKey") as? [Int] {
            cartList.append(contentsOf: list)
        }
        let timer = Timer.scheduledTimer(timeInterval: 4.00, target: self, selector: #selector(carroussel), userInfo: nil, repeats: true)
    }
    
    @objc func carroussel(){
        if imageIndex == 3{
            imageIndex = 0
        }
        downloadImage(link: imagesLinks[imageIndex], object: imgvDetail)
        imageIndex += 1
    }

    @IBAction func cartOnClick(_ sender: Any) {
        if !cartList.contains(id) {
            cartList.append(id)
            UserDefaults.standard.set(self.cartList, forKey: "cartKey")
            let alert = UIAlertController(title: "Carrinho",
                                          message: "Produto adicionado no carrinho",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
            
        }else{
            let alert = UIAlertController(title: "Carrinho",
                                          message: "Produto ja adicionado no carrinho anteriormente",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
            
        }
        
    }
    
    
    @IBAction func returnOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    }}
