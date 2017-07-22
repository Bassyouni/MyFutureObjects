//
//  MainVC.swift
//  MyFutureObjects
//
//  Created by Bassyouni on 7/8/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController ,UITableViewDelegate , UITableViewDataSource , NSFetchedResultsControllerDelegate{
    
    //MARK: - iboutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedView: UISegmentedControl!
    
    var controller : NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        

        attemptFetch()

        
    }
  
    
    //MARK: - table
    func numberOfSections(in tableView: UITableView) -> Int {
        /*if let sections = controller.sections
        {
            return sections.count
        }*/
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections
        {
            let sectionsInfo = sections[section]
            return sectionsInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! objectItemCell
            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            return cell
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let obj = controller.fetchedObjects, obj.count > 0
        {
            let item = obj[indexPath.row]
            performSegue(withIdentifier: "ViewDetailsVC", sender: item)
        
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewDetailsVC
        {
            if let item = sender as? Item
            {
                destination.itemToEdit = item
            }
        }
    }
    
    func configureCell(cell : objectItemCell , indexPath :NSIndexPath)
    {
        let item  = controller.object(at:indexPath as IndexPath)
        cell.configureCell(item: item)
    }

    //MARK: - coreData
    func attemptFetch()
    {
        
        let fetchRequest :NSFetchRequest<Item> = Item.fetchRequest()
        let datasort = NSSortDescriptor(key: "created", ascending: true)
        let datasort1 = NSSortDescriptor(key: "price", ascending: true)
        let datasort2 = NSSortDescriptor(key: "title", ascending: true)
        
        
        if segmentedView.selectedSegmentIndex == 0
        {
            fetchRequest.sortDescriptors = [datasort]
        }
        else if segmentedView.selectedSegmentIndex == 1
        {
            fetchRequest.sortDescriptors = [datasort1]
        }
        else if segmentedView.selectedSegmentIndex == 2
        {
            fetchRequest.sortDescriptors = [datasort2]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        
        do{
           try controller.performFetch()
        }
        catch{
            let error = error as NSError
            print(error.debugDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath
            {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case .delete:
            if let indexPath = indexPath
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            if let indexPath = indexPath
            {
                let cell = tableView.cellForRow(at: indexPath) as! objectItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
            
        case .move:
            if let indexPath = indexPath
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath
            {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    
    func generateTestData()
    {
        let item = Item(context: context)
        item.title = "New Iphone 7s"
        item.price = 2000
        item.details = "I wish it's something that is worth to apple , unline Iphone 7"
        
        
        let item2 = Item(context: context)
        item2.title = "Beach House in France"
        item2.price = 3000000
        item2.details = "I will live there for the rest of my Life , untill then i don't have a life"
        
        let item3 = Item(context: context)
        item3.title = "Air Plane"
        item3.price = 250000
        item3.details = "I want to see the whole world from upthere whenever i just feel like a bird"
        
        
        ad.saveContext()
}
    

    
    @IBAction func segmentedChanged(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
        
    }
    
    
    
    
    


}

