//
//  AddEditViewController.swift
//  MyGames_CoreData
//
//  Created by Israel3D on 17/01/2019.
//  Copyright © 2019 Israel3D. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
    
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtConsole: UITextField!
    @IBOutlet weak var dpReleasedate: UIDatePicker!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var btAddEdit: UIButton!
    
    var game: Game!
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if game != nil {
            title = "Editar Jogo"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            txtTitle.text = game.title
            if let console = game.console, let index = consolesManager.consoles.index(of:console) {
                txtConsole.text = game.console?.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            ivCover.image = game.cover as? UIImage
            if let release = game.releaseDate {
                dpReleasedate.date = release
            }
            if game.cover != nil {
                btCover.setTitle(nil, for: .normal)
            }
        }
        
     prepareConsoleTextfield()
    }
    
    func prepareConsoleTextfield(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        
        let btnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btnFlexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btnCancel, btnFlexible, btnDone]
        
        txtConsole.inputView = pickerView
        txtConsole.inputAccessoryView = toolbar
    }
    
    @objc func cancel(){
        txtConsole.resignFirstResponder()
    }
    
    @objc func done(){
        txtConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consolesManager.loadConsoles(with: context)
    }

    @IBAction func addEditCover(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Selecionar Poster", message: "De onde queres selecionar o poster?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action:UIAlertAction) in
                self.selectPicture(sourceType:.camera)
            }
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { (action:UIAlertAction) in
            self.selectPicture(sourceType:.photoLibrary)
        }
        alert.addAction(libraryAction)
        let photosAction = UIAlertAction(title: "Álbuns de Fotos", style: .default) { (action:UIAlertAction) in
            self.selectPicture(sourceType:.savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType:UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addEditGame(_ sender: UIButton) {
        if game == nil{
            game = Game(context: context)
        }
        game.title = txtTitle.text
        game.releaseDate = dpReleasedate.date
        game.cover = ivCover.image
        if !txtConsole.text!.isEmpty {
            let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
            game.console = console
        }
        
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }

}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
}

extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        ivCover.image = image
        btCover.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
