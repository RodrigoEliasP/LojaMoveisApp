//
//  ViewController.swift
//  LojaMoveis3B1
//
//  Created by COTEMIG on 16/09/20.
//  Copyright © 2020 Cotemig. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    
    private struct User: Codable {
        let user: String
        let password: String
    }
    private var user: String = ""
    private var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloadApi()
    }
//http:\//apilojasmoveis.herokuapp.com/user
    @IBAction func tryLogin(_ sender: Any) {
        let u: String? = txtUser.text
        let p: String? = txtPass.text
        if(u == self.user && p == self.password){
            performSegue(withIdentifier: "segueLogin", sender: self)
        }else{
            let alertController = UIAlertController(
                title: "Alert",
                message: "Usuario ou senha errados",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func downloadApi(){
        print("2")
        let link = URL(string: "https://apilojasmoveis.herokuapp.com/user")!
        URLSession.shared.dataTask(with: link){(data, response, error) in
            if let data = data{
                do{
                    
                    let lojaApi = try JSONDecoder().decode(User.self, from: data)
                    self.password = lojaApi.password
                    self.user = lojaApi.user
                    
                }catch{
                    print("erro")
                    
                }
            }
            
        }.resume()
    }
    
}

