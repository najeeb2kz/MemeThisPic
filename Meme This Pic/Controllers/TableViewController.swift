//
//  TableViewController.swift
//  Meme This Pic
//
//  Created by Najeeb Chaudhry on 1/21/19.
//  Copyright © 2019 Najeeb Chaudhry. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //Retrieve array of memes that user had sent
    var memes: [MemeObject.Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Create "+" button in navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "🤡", style: .done, target: self, action: #selector(goToMemeEditor(sender:)))

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @objc func goToMemeEditor(sender: AnyObject) {
        var controller: MemeViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        present(controller, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellReuseIdentifier", for: indexPath)
        let x = self.memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = x.topText
        cell.detailTextLabel?.text = x.bottomText
        cell.imageView?.image = x.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.myMeme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
