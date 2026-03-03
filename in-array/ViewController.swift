//
//  ViewController.swift
//  in-array
//
//  Created by Michael Robertson on 12/2/2026.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: Outlets
    
    //Inputs
    @IBOutlet weak var txtName: UITextField!
    
    //Outputs
    
    @IBOutlet weak var tblNamesList: UITableView!
    
    
    //MARK: Global Data
    var names: [String] = []
   
    //URL for the root folder to save CSVs to
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    
    //MARK: Button Functions
    
    /**
     Function: Add Name
       
     - Add a name to the names array and refresh table view
     - Todo: Give validation to ensure that no blank names can be appended to the array
     - Parameter _: A click or given form of interaction to start the button function
     */
    
    @IBAction func btnAddName(_ sender: Any) {
        
        //Save name input to variable
        let name: String = txtName.text!
        
        //If the variable given to the validate function is true then...
        if ( validate(nameInput: name) == true ) {

            //found var to record if the value is in the array or not
            var found: Bool = false

            //if small, run through linear search to see if value is in array
            if names.count < 10 {
                found = linearSearch(array: names, searchFor: name)
            }
            //else if large, run through binary search AFTER quick sort
            else {
                names = quickSort(array: names)
                found = binarySearch(array: names, searchFor: name)
            }

            //only add the name if it wasn't found
            if found == false {
                //... append the name to the names array, sort it and reload the tableview
                names.append(name)
                
                //Sort the names depending on the array length

                if names.count < 10 {
                    names = selectionSort(array: names)
                    print("Selection sort was used")
                }
                else {
                    names = quickSort(array: names)
                    print("Quick sort was used")
                }
                
                
                tblNamesList.reloadData()
            }
        }
        
        //else an error statement is made (should be a label, but also I didn't get time to make a label...)
        else {
            print("The name wasn't added")
        }
        
        
    }
    
    /**
     Function: Save Button
     Saves the current names array to a CSV file
     */
    
    @IBAction func btnSave(_ sender: Any) {
        
        //create a new string of all of our array items together
        let str = names.joined(separator: ",")

        //filename is made for the CSV that the array will save to
        let filename = URL(fileURLWithPath: "names.csv", relativeTo: directoryURL)
        
        //Print the directory for ease of file location
        print(directoryURL)
        
        //Try to write the string to the newly made CSV file;
        do {
            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            print("file was successfully exported")
               }
        //Else; it will state that the file could not be exported.
        catch {
        print("file could not be exported")
        }
    }
    
    /**
     Function: Load Button
     Loads the CSV file that was previously saved
     */
    
    @IBAction func btnLoad(_ sender: Any) {

        let filename = URL(fileURLWithPath: "names.csv", relativeTo: directoryURL)
        
        //attempt the load the contents of the file to a data variable
        do {
            let data = try Data(contentsOf: filename)
            
            //if the data can be encoded to a string properly; then convert it to an array
            if let string = String(data: data, encoding: .utf8) {
                print("File contents: \(string)")
                names = []
                names = string.components(separatedBy: ",")
                print("new array: \(names)")
            }
        }
        //catch here stops the program from crashing and gives a lil error message
        catch {
            print("Error reading file :(")
        }
        
        //reload the table view with the new array data.
        tblNamesList.reloadData()
        
    }
    
    
    //MARK: Helper Functions
    
    /**
     Function: validate
     - Validate a string to ensure that it is not blank, is a String and that it is less than 30 characters in length
    - Parameters: nameInput - String - be the text to validate from an input
    - Returns: Bool - True if it is valid, false if it is not
     */
    
    func validate(nameInput: String?) -> Bool {
        
        //Existence Check
        if (nameInput != "") {
         
            //Type Check
            if (nameInput != nil) {
                
                //Range Check
                if (nameInput!.count < 30) {
                    
                    return true
                    
                }
                
            }
            
        }
        
        // if it does not return true and is invalid; return false
        return false
        
    }
    
    //MARK: Sort Functions
    
    /**
     Function: Quick Sort
     - A sort that takes in an array and returns a sorted array using a divide and conquer algorithm
     
     - Parameters: Array - Strings: The list to sort
     - Returns: Array - String : The now sorted list
     */
    
    func quickSort(array: [String]) -> [String] {
        
        var less: [String] = []
        var equal: [String] = []
        var greater: [String] = []
        
        if array.count > 1 {
            let pivot = array[array.count - 1]
            for x in array {
                if x < pivot {
                    less.append(x)
                }
                if x == pivot {
                    equal.append(x)
                }
                if x > pivot {
                    greater.append(x)
                }
            }
            return (quickSort(array: less) + equal + quickSort(array: greater))
        } else {
            return array
        }
    }


    /**
     Function: Selection Sort

- A sort that takes in an array and returns a sorted array comparing each value one-by-one
     - Parameters: Array - Strings: The list to sort
     - Returns: Array - String : The now sorted list

     */
    
    func selectionSort(array: [String]) -> [String] {
        if array.count > 1 {
            var arr = array
            for x in 0 ..< arr.count - 1 {
                var lowest = x
                for y in x + 1 ..< arr.count {
                    if arr[y] < arr[lowest] {
                        lowest = y
                    }
                }
                if x != lowest {
                    arr.swapAt(x, lowest)
                }
            }
            return arr
        } else {
            return array
        }
    }


//MARK: Search Functions

/**
Function: Linear Search
- A search that takes in an array and a value to see whether the value exists in the array;
Checking one-by-one.
- Parameters: Array - Strings: The list to search
             Value - String: The value to search for
- Returns: Bool - True if the value is found, false if it is not
*/

func linearSearch(array: [String], searchFor: String) -> Bool {
   for currentValue in array {
      if searchFor == currentValue {
         return true
      }
   }
   return false
}

/**
Function: Binary Search
- A search that takes in an array and a value to see whether the value exists in the array;
Checks by dividing the array in half, comparing whether the value is larger or smaller and halving again.
- Parameters: Array - Strings: The list to search
             Value - String: The value to search for
- Returns: Bool - True if the value is found, false if it is not
*/

func binarySearch(array: [String], searchFor: String) -> Bool {
    var firstIndex = 0
    var lastIndex = array.count - 1
    
    while firstIndex <= lastIndex {
        let middleIndex = (firstIndex + lastIndex) / 2
        if array[middleIndex] == searchFor {
            return true
        }
        if searchFor < array[middleIndex] {
            lastIndex = middleIndex - 1
        }
        if searchFor > array[middleIndex] {
            firstIndex = middleIndex + 1
        }
    }
    return false
}

    
    //MARK: TableView functions
    
    //TableView Row creation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    //Tableview cell population function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ensure the cell identifier has been labelled "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(names[indexPath.row])
        return cell
    }
    
    //Tableview swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

       if editingStyle == .delete {

       names.remove(at: indexPath.row)

           tblNamesList.reloadData()

      }

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Update and delegate data to the table
        tblNamesList.delegate = self
        tblNamesList.dataSource = self
        
    }


}

