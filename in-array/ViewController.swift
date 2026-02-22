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
        
        let name: String = txtName.text!
        
        names.append(name)
        tblNamesList.reloadData()
        
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
        catch {
            print("Error reading file :(")
        }
        
        tblNamesList.reloadData()
        
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

