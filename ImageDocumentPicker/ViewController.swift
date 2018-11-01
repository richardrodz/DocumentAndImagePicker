//
//  ViewController.swift
//  ImageDocumentPicker
//
//  Created by Richard Rodriguez on 10/31/18.
//  Copyright © 2018 Richard Rodriguez. All rights reserved.
//

import UIKit
//import MobileCoreServices

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var imageUpload = [UIImage]()
    var documentUpload = [UIDocument]()
    var imageUploadSection: Int?
    var documentUploadSection: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get rid of blank tableView lines
        tableView.tableFooterView = UIView()
    }

    
    @IBAction func addImageButtonSelected(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Select From Library", style: .default , handler:{ (UIAlertAction)in
            self.selectPicture()
        }))
        
        alert.addAction(UIAlertAction(title: "Select From Documents", style: .default, handler: { (UIAlertAction) in
            self.selectDocument()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func selectPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func selectDocument() {
        // "public.item"
        let allowedFileType = ["UTTypePDF", "kUTTypePNG", "kUTTypeJPEG", "kUTTypePackage", "com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key", "public.item"]
        let importMenu = UIDocumentPickerViewController(documentTypes: allowedFileType, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        present(importMenu, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if imageUpload.count > 0 && documentUpload.count > 0 {
            imageUploadSection = 0
            documentUploadSection = 1
            return 2
        } else if imageUpload.count > 0 && documentUpload.count == 0 {
            imageUploadSection = 0
            return 1
        } else if documentUpload.count > 0 && imageUpload.count == 0 {
            documentUploadSection = 0
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let imageSection = imageUploadSection {
            if imageSection == section {
                return "Images"
            }
        }
        
        if let documentSection = documentUploadSection {
            if documentSection == section {
                return "Documents"
            }
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let imageSection = imageUploadSection {
            if imageSection == section {
                return imageUpload.count
            }
        }
        
        if let documentSection = documentUploadSection {
            if documentSection == section {
                return documentUpload.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let imageSection = imageUploadSection {
            if imageSection == indexPath.section {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "UDTableViewCell", for: indexPath) as? UDTableViewCell {
                    cell.configureCellForImages(image: imageUpload[indexPath.row], name: "Image Name")
                    return cell
                }
            }
        }
        
        if let documentSection = documentUploadSection {
            if documentSection == indexPath.section {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "UDTableViewCell", for: indexPath) as? UDTableViewCell {
                    cell.configureCellForDocuments(document: documentUpload[indexPath.row])
                    return cell
                }
            }
        }
        
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage = UIImage()
        var name = String()
        
        if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
            imageUpload.append(newImage)
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let myURL = urls.first {
            print("import result : \(myURL)")
            documentUpload.append(UIDocument(fileURL: myURL))
            tableView.reloadData()
        }
    }
}

extension ViewController: UINavigationControllerDelegate {}
