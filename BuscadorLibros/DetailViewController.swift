//
//  DetailViewController.swift
//  BuscadorLibros
//
//  Created by Ivan Duran Martinez on 26/4/16.
//  Copyright © 2016 Indenext. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var portada: UIImageView!
    @IBOutlet weak var messaje: UITextView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.valueForKey("titulo")!.description
            }
            if let portada = self.portada{
                portada.image = UIImage(data: detail.valueForKey("portada")! as! NSData)
            }
            if let messaje = self.messaje{
                messaje.text = detail.valueForKey("mensaje") as! String
            }
            self.title = detail.valueForKey("isbn") as? String
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

