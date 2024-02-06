//
//  ViewController.swift
//  Peliculas
//
//  Created by Nicolás Fiore on 15/01/2024.
//

import UIKit
//para usar apis
import Alamofire
//para manejar imagenes remotas
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var nombrePelicula: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var año: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        nombrePelicula.placeholder = "Buscar Película"
        titulo.isHidden = true
        año.isHidden = true
        imagen.isHidden = true
        self.nombrePelicula.delegate = self
     }
    //oculta el teclado al tocar la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nombrePelicula.resignFirstResponder()
    }
    
    func buscarPelicula(){
        if !nombrePelicula.text!.isEmpty{
            titulo.isHidden = false
            año.isHidden = false
            imagen.isHidden = false
            //mio http://www.omdbapi.com/?i=tt3896198&apikey=11715513
            //youtube https://www.omdbapi.com/?i=tt3896198&apikey=99cc4d2d&t
            //AF.request("apiUrl").responseDecodable(of: estructura para traducir el Json.self)
            AF.request("https:www.omdbapi.com/?i=tt3896198&apikey=99cc4d2d&t=\(nombrePelicula.text ?? "")").responseDecodable(of: PeliculasModelo.self){ (respuesta) in
                self.titulo.text = respuesta.value?.title ?? "Es inexistente"
                self.año.text = "Fecha de lanzamiento: \(respuesta.value?.released ?? "Error")"
                let urlNoImage = "https://programacion.net/files/article/20161110041116_image-not-found.png"
                guard let url = URL(string: respuesta.value?.poster ?? urlNoImage ) else{return}
                self.imagen.kf.setImage(with: url)
                self.nombrePelicula.text = ""
              
            }
            } else {
                let titulo = "Error"
                let mensaje = "Escriba una película"
                let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
                let acion = UIAlertAction(title: "Aceptar", style: .default)
                alerta.addAction(acion)
                present(alerta, animated: true)
            }
        }
    
    @IBAction func buscador(_ sender: Any) {
            buscarPelicula()
        }
    }
    
extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nombrePelicula.resignFirstResponder()
        buscarPelicula()
        return true
    }
}

