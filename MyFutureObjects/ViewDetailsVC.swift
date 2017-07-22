//
//  ViewDetailsVC.swift
//  MyFutureObjects
//
//  Created by Bassyouni on 7/21/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import CoreData

class ViewDetailsVC: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var itemTitle: CustomTextField!
    @IBOutlet weak var price: CustomTextField!
    @IBOutlet weak var itemDescription: CustomTextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var thumbImage: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let topItem = self.navigationController?.navigationBar.topItem
        {
            topItem.backBarButtonItem = UIBarButtonItem(title: "" , style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        picker.delegate = self
        picker.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        fetchStores()
        
        if itemToEdit != nil
        {
            updateUIForItem()
        }
        
        
        
        
    }
    
    func updateUIForItem()
    {
        if let item = itemToEdit
        {
            itemTitle.text = item.title
            itemDescription.text = item.details
            price.text = "\(item.price)"
            thumbImage.image = item.toImage?.image as? UIImage
            
            for i in 0 ..< stores.count
            {
                if stores[i].name == item.toStore?.name
                {
                    picker.selectRow(i, inComponent: 0, animated: true)
                    return
                }
            }
            
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // to do stuff
        
    }
    
    func fetchStores()
    {
        let request: NSFetchRequest<Store> = Store.fetchRequest()
        do{
            self.stores = try context.fetch(request)
            self.picker.reloadAllComponents()
        }
        catch
        {
            print("problem with store fetching")
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        var item: Item!
        let image = Image(context: context)
        image.image = thumbImage.image
        
        if itemToEdit == nil
        {
            item = Item(context: context)
        }
        else
        {
            item = itemToEdit
        }
        
        item.toImage = image
        
        item.details = self.itemDescription.text
        item.price = (self.price.text! as NSString).doubleValue
        item.title = self.itemTitle.text
        
        item.toStore = stores[picker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        
        if itemToEdit != nil
        {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    @IBAction func imagePressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            thumbImage.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
