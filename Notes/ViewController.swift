import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var firstTableView = UITableView(frame: .zero, style: .plain)
    var identifier = "MyCell"
    var notes = [Notes(noteTitle: "Помыть машину", id : UUID().uuidString)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTableView.backgroundColor = .systemFill
        self.view.backgroundColor = .systemBackground
        self.title = "Ваши заметки"
        createTable()
        view.addSubview(firstTableView)
        firstTableView.reloadData()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(deleteNote))
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = deleteButton
    }
    //MARK: - Functions
    func createTable() {
        self.firstTableView.frame = view.bounds
        firstTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        self.firstTableView.delegate = self
        self.firstTableView.dataSource = self
        firstTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(firstTableView)
    }
    @objc func addNote() {
        let alert = UIAlertController(title: "Новая заметка", message: .none, preferredStyle: .alert)
        alert.addTextField { (textField ) in
            textField.keyboardType = .default
            textField.placeholder = "Введите текст новой заметки"
        }
       alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { [weak alert] (_) in
       
            //let textField = alert?.title
            //let textField = addTextField.text
            //print(textField)
            //notes.append(textField.text, id : UUID().uuidString)
            //print("Text field: \(alert?.title)")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func deleteNote() {
        
    }
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let thenotes = notes[indexPath.row]
        
        cell.textLabel?.text = thenotes.noteTitle
        
        return cell
    }
//     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//            let movedNote = notes[sourceIndexPath.row]
//            notes.remove(at: sourceIndexPath.row)
//            notes.insert(movedNote, at: destinationIndexPath.row)
//        }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//            if editingStyle == .delete {
//                self.notes.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}




