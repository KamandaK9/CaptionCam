//
//  ViewController.swift
//  CaptionCam
//
//  Created by Daniel Senga on 2022/04/29.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var momentsArray = [Moments]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "CaptionCam"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeMoments))
        loadSaved()
        
    }
    
    //TableView rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return momentsArray.count
    }
    
    // Returning the cell row, and assigning the arrays text to that of the label
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moments = momentsArray[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "captionCell", for: indexPath)
        cell.textLabel?.text = moments.caption.capitalizingFirstLetter()
        cell.textLabel?.textColor = .white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moments = momentsArray[indexPath.item]
        let path = getDocuments().appendingPathComponent(moments.fileName)
         if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            
             vc.selectedImage = UIImage(contentsOfFile: path.path)
             vc.title = moments.caption.capitalizingFirstLetter()
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    @objc func takePicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    @objc func removeMoments() {
        defaults.removeObject(forKey: "moments")
        momentsArray.removeAll()
        tableView.reloadData()
    }
    
  
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocuments().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
//        let moment = Moments(fileName: imageName, caption: "None")

        dismiss(animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let ac = UIAlertController(title: "Add Caption", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default) {[weak self, weak ac] _ in
                guard let caption = ac?.textFields?[0].text else { return }
                let moment = Moments(fileName: imageName, caption: caption)
                self?.momentsArray.append(moment)
                self?.tableView.reloadData()
                self?.save()
     
            })
            

            self.present(ac, animated: true)
        }
  
        
    }
    
    func getDocuments() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedMoments = try? jsonEncoder.encode(momentsArray) {
            defaults.set(savedMoments, forKey: "moments")
            print("successfully saved moment")
        } else {
            print("failed to save moment")
        }
    }
    
    func loadSaved() {
        if let savedMoments = defaults.object(forKey: "moments") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                momentsArray = try jsonDecoder.decode([Moments].self, from: savedMoments)
            } catch {
                print("Failed to load")
            }
        }
    }


}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


