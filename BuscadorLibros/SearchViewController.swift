//
//  SearchViewController.swift
//  BuscadorLibros
//
//  Created by Ivan Duran Martinez on 26/4/16.
//  Copyright © 2016 Indenext. All rights reserved.
//

import UIKit

struct Libro {
    var isbn : String
    var titulo : String
    var mensaje : String
    var portada : NSData
    
    init (isbn : String, titulo : String, mensaje : String, portada : NSData){
        self.isbn = isbn
        self.titulo = titulo
        self.mensaje = mensaje
        self.portada = portada
    }
}

protocol SearchViewControllerDelegate: class {
    //func addFoundBook(sender: SearchViewController)
    func insertNewObject(book : Libro)
}

class SearchViewController : UIViewController{
    
    let baseURL = "https://openlibrary.org"
    let responseFormat = "json"
    
    var currentBook : Libro?
    weak var delegate:SearchViewControllerDelegate?
    
    @IBOutlet weak var isbnTextfield: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var cover: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if currentBook != nil{
            delegate?.insertNewObject(currentBook!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func search(){
        
        let urlStr = baseURL + "/api/books?jscmd=data&format=" + responseFormat + "&bibkeys=" + isbnTextfield.text!
        
        // En caso de error, informar al usuario.
        if let url = NSURL(string: urlStr), let datos:NSData = NSData(contentsOfURL: url){
            //            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            //            resultTextView.text = (texto! as String)
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(datos, options: .MutableLeaves)
                let dico = json as! NSDictionary
                
                if dico.count == 0 {
                    cover.image = nil
                    resultTextView.text = "No se puede encontrar el libro"
                    return
                }
                
                let isbn = isbnTextfield.text! as NSString
                let libro = dico[isbn] as! NSDictionary
                let result = libro["title"] as! String
                var message = "Titulo: \(result)\n"
                let autores = libro["authors"] as! NSArray
                if autores.count > 1{
                    message += "Autores:\n"
                    for autor in autores{
                        message += "\t\(autor["name"])"
                    }
                }else if autores.count == 1{
                    let nombre = autores.firstObject!["name"] as! NSString
                    message += "Autor: \(nombre)"
                }
                
                resultTextView.text = message
                let imageURL = NSURL(string: "http://covers.openlibrary.org/b/isbn/\(isbn)-L.jpg")!
                let image = NSData(contentsOfURL: imageURL)!
                cover.image = UIImage(data: image)
                
                currentBook = Libro(isbn : isbn as String, titulo: result, mensaje: message, portada: image)
                
            }catch _{
                
            }
        }else{
            let message = "Parece que hay algún problema con la conexión."
            resultTextView.text = message
            let alert = UIAlertController(title: "Alerta", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func textFieldReturn(sender: AnyObject) {
        self.resignFirstResponder()
        
        guard isbnTextfield.text!.characters.count > 0 else {
            return
        }
        search()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
