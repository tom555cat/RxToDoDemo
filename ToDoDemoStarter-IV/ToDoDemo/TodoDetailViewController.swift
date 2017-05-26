//
//  TodoDetailViewController.swift
//  ToDoDemo
//
//  Created by Mars on 26/04/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import UIKit
import RxSwift

class TodoDetailViewController: UITableViewController {
    fileprivate var todoCollage: UIImage?
    
    fileprivate let todoSubject = PublishSubject<TodoItem>()
    var todo: Observable<TodoItem> {
        return todoSubject.asObservable()
    }
    var bag = DisposeBag()

    var todoItem: TodoItem!

    @IBOutlet weak var todoName: UITextField!
    @IBOutlet weak var isFinished: UISwitch!
    @IBOutlet weak var doneBarBtn: UIBarButtonItem!
    @IBOutlet weak var memoCollageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()()
        
        todoName.becomeFirstResponder()

        if let todoItem = todoItem {
            self.todoName.text = todoItem.name
            self.isFinished.isOn = todoItem.isFinished
            
            if todoItem.pictureMemoFilename != "" {
                let url = getDocumentsDir().appendingPathComponent(todoItem.pictureMemoFilename)
                if let data = try? Data(contentsOf: url) {
                    self.memoCollageBtn.setBackgroundImage(UIImage(data: data), for: .normal)
                    self.memoCollageBtn.setTitle("", for: .normal)
                }
            }
            
            doneBarBtn.isEnabled = true
        }
        else {
            todoItem = TodoItem()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        todoSubject.onCompleted()
    }

    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        todoItem.name = todoName.text!
        todoItem.isFinished = isFinished.isOn

        todoSubject.onNext(todoItem)
        dismiss(animated: true, completion: nil)
    }
}

extension TodoDetailViewController {
    fileprivate func getDocumentsDir() -> URL {
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)[0]
    }
    
    fileprivate func resetMemoBtn() {
        // Todo: Reset the add picture memo btn style
    }
    
    fileprivate func setMemoBtn(bkImage: UIImage) {
        // Todo: Set the background and title of add picture memo btn
    }
    
    fileprivate func savePictureMemos() -> String {
        // Todo: Save the picture memos preview as a png
        // file and return its file name.
        return ""
    }
}

extension TodoDetailViewController {
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    

    func setMemoSectionHederText() {
        // Todo: Set section header to the number of
        // pictures selected.
    }
}

extension TodoDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarBtn.isEnabled = newText.length > 0
        
        return true
    }
}
