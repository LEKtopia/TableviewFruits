//
//  ViewController.swift
//  TableViewFruits
//
//  Created by Kastel, Lynette on 9/19/17.
//  Copyright © 2017 LynetteKastel. All rights reserved.
//
//  Phase 1 - conform an array to data source protocol
//  Phase 2 - group the fruits by first letter (set up a dictionary, sort array values, populate the tableview with dictionary elements)

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var fruits: [String] = []   // This gets populated in viewDidLoad()
    var fruitsByLetter = [String: [String]]()   // declares an empty dictionary
    
    let cellIdentifier = "CellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fruits = ["Apple", "Orange", "Pineapple", "Kiwi", "Tomato", "Banana", "Mango", "Kumquat", "Strawberry", "Blackberry", "Blueberry", "Raspberry", "Pear", "Peach", "Cherry", "Watermelon", "Apricot", "Fig", "Currant", "Lemon", "Lime", "Coconut"]
        
        /* Alphabetize fruits by calling a helper method that returns a dictionary of fruits.
           Each key = a letter of the alphabet & each value = an array of fruits beginning with that letter.
           Letters without fruits won't be included as an element.  */
 
        // Define the dictionary called fruitsByLetter
        fruitsByLetter = alphabetizeArray(fruits)
    }

    
    /* Create an optional method that helps conform to the datasource protocol
        - tell the tableview # of sections (groups of rows) to display
        - its single argument is the table view that sent this message (method call)
          to the datasource object (in this case, the VC)  */
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Phase 1 (test)
        //return 1
        
        // Phase 2 (using the Dictionary)
        return fruitsByLetter.keys.count   // keys must be unique, no duplicates
    }
    
    
    /* Now that it knows how many sections to display, it asks the data source (VC)
       how many rows each sections contains.  For each section, the tableview auto
       sends the data source this "message" (method).
    
       Arg  1) the tableview calling this method.
       Arg  2) the index of the section that the table view wants to know the # of rows of.  */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Phase 1 (test)
        //return fruits.count
        
        // Phase 2 (using the Dictionary)
        let keys = fruitsByLetter.keys  // Store the keys to make use of them
        
        // Sort the keys (dictionary key-value pairs are unordered by default)
        let sortedKeys = keys.sorted(by: {  (a, b) -> Bool in
            a.lowercased() < b.lowercased()
        })
        
        // Fetch fruits array (based on the section key) using passed in section arg
        //  If the array is found (using optional binding/if let...) return # of items inside.
        let key = sortedKeys[section]
        
        // if non-nil fruits count found, return the count
        if let fruits = fruitsByLetter[key] {
            return fruits.count
        }
        
        return 0
    }
    
    
    /* This method is automatically called by the tableview (passed in as arg 1).
       The tableview asks its data source for the tableview cell of the row specified by the indexPath argument.
    
       indexPath - an instance of the IndexPath class, which for tableviews holds an index
                   for the section an item is in, and the row of that item in the section.
    
       A tableview is NEVER more than 2 levels deep.
         1st level - the section
         2nd level - the row in the section  */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Since views are expensive (memory & processing power), reuse cells when possible
           (vs creating from scratch everytime).
 
           Cells that move off-screen aren't discarded. They can be marked for reuse by specifying a
           reuse identifier during initialization.  When it's marked for reuse and moves off-screen,
           the tableview puts it into a reuse queue for later use.
 
           When the datasource asks its tableview for a new cell and specifies a reuse identifier,
           The tableview inspects the queue to check if a cell with the specified identifier is available.
           If it's not, the tableview instantiates a new one and passes it to its datasource.
 
           Below, the datasource is asking the tableview for a cell, sending it the identifier set at the
           top of this code in the index path of the cell.  */
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        // At this point, how does a tableview know what class to use to instantiate a new table view cell?
        //   Answer: Go to the storyboard, create a prototype cell and give it a reuse identifier
        
        /*
        // Phase 01
        //
        // Populate the cell.  (Fetch fruit using the passed-in indexPath's row property, which gives us
        //     the row for the cell as an index, which we will use as an index into the fruits array.)
        let fruit = fruits[indexPath.row]
        
        // Access the cell's textLabel
        cell.textLabel?.text = fruit
        */
        
        // Phase 2
        // Fetch & sort the dictionary keys - 1st letters
        let keys = fruitsByLetter.keys.sorted(by: {  (a, b) -> Bool in
            a.lowercased() < b.lowercased()
        })
        
        // Fetch the fruits for this section
        let key = keys[indexPath.section]
        
        // Use of optional binding to prevent fatal error "unexpected nil..."
        if let fruits = fruitsByLetter[key] {
            let fruit = fruits[indexPath.row]  // Grab the row of the passed in...
            cell.textLabel?.text = fruit      // Configure table cell
        }
        return cell
    }
    
    
    /* Section headers are not showing yet.  Tell the tableview what to display in each header.
       To display section header letter, implement the "tableView(_:titleForHeaderInSection:)"
       which is another method defined in the UITableViewDataSource protocol  */

    // Fetch & sort the keys
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = fruitsByLetter.keys.sorted(by: {  (a, b) -> Bool in
            a.lowercased() < b.lowercased()
        })
        return keys[section]
    }
    
    // Helper method to alphabetize fruits
    private func alphabetizeArray(_ array: [String]) -> [String: [String]] {
        var result = [String: [String]]()
        
        // Populate the dictionary by stepping thru the array, find first letter and add it, create a key if new
        for fruitName in array {
            
            let index = fruitName.index(fruitName.startIndex, offsetBy: 1)
            let firstLetter = fruitName.substring(to: index).uppercased()
            // print("firstLetter is: \(firstLetter)")
            
            if result[firstLetter] != nil {
                // Has a value. Add the fruit to the element's array value.
                result[firstLetter]!.append(fruitName)
            } else {
                // Value is empty. Create an element, then add the fruit to the element's array value
                result[firstLetter] = [fruitName]
            }
        }
        
        // Alphabetize!
        //    - Loop thru result dictionary, sort element's value (an array of fruits)
        for (key, value) in result {
            result[key] = value.sorted(by: {  (a, b) -> Bool in
                a.lowercased() < b.lowercased()
            })
        }
        
        return result
    }
    
    
    // Implement a UITableViewDelegate protocol method to respond to a touch on a row.
    //
    // This method tells the delegate (our VC) that a row in the tableView has been "touched".
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
            
        // Fetch & sort the dictionary keys - by first letter
        let keys = fruitsByLetter.keys.sorted(by: {  (a, b) -> Bool in
            a.lowercased() < b.lowercased()
        })
            
        // Fetch the fruits for this section
        let key = keys[indexPath.section]
            
        if let fruits = fruitsByLetter[key] {
            // Output to the console
            print("The touched row contains the fruit: \(fruits[indexPath.row])")
        }
    }
}
















