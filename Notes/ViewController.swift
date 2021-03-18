import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var firstTableView = UITableView(frame: .zero,
                                     style: .plain)
    var identifier = "MyCell"
    var notes = [Notes(noteTitle: "Зайти в приложение с заметками",
                       id : UUID().uuidString,
                       isCompleted : true)] {
        didSet {
            firstTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTableView.backgroundColor = .systemFill
        self.view.backgroundColor = .systemBackground
        self.title = "Ваши заметки"
        createTable()
        view.addSubview(firstTableView)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addNote))
        navigationItem.leftBarButtonItem = addButton
        loadData()
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
        let alert = UIAlertController(title: "Новая заметка",
                                      message: "Введите текст новой заметки",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .default
            textField.placeholder = "Новая заметка"
        }
        alert.addAction(UIAlertAction(title: "Отменить",
                                      style: .cancel,
                                      handler: { _ in
                                        return
                                      }))
        alert.addAction(UIAlertAction(title: "Добавить",
                                      style: .default,
                                      handler: { [weak self] _ in
                                        guard let self = self,
                                              let textField = alert.textFields?.first,
                                              let text = textField.text else {
                                            return
                                        }
                                        let note = Notes(noteTitle: text,
                                                         id: UUID().uuidString,
                                                         isCompleted : false)
                                        self.notes.append(note)
                                        self.saveData()
                                      }))
        present(alert, animated: true, completion: nil)
    }
    
    func changeState(at item : Int) -> Bool {
        notes[item].isCompleted = !(notes[item].isCompleted)
        return notes[item].isCompleted
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.setValue(encoded, forKey: "NotesKeys")
        }
    }
    
    func loadData() {
        guard let notesData = UserDefaults.standard.value(forKey: "NotesKeys") as? Data else {
            return
        }
        
        guard let notes = try? JSONDecoder().decode([Notes].self, from: notesData) else {
            return
        }
        self.notes = notes
        
    }
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let thenotes = notes[indexPath.row]
        cell.textLabel?.text = thenotes.noteTitle
        
        if thenotes.isCompleted == true {
            cell.accessoryType = .checkmark
            
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let editAction = UIContextualAction(style: .normal,
                                            title: "Изменить") { (action, view, handler) in
            let alert = UIAlertController(title: "Редактирование заметки",
                                          message: "Введите текст заметки",
                                          preferredStyle: .alert)
            alert.addTextField { textField in
                textField.keyboardType = .default
                textField.placeholder = self.notes[indexPath.row].noteTitle
            }
            alert.addAction(UIAlertAction(title: "Отменить",
                                          style: .cancel,
                                          handler: { _ in
                                            return
                                          }))
            alert.addAction(UIAlertAction(title: "Изменить",
                                          style: .default,
                                          handler: { [weak self] _ in
                                            guard let self = self,
                                                  let textField = alert.textFields?.first,
                                                  let text = textField.text else {
                                                return
                                            }
                                            let newnote = Notes(noteTitle: text,
                                                             id: UUID().uuidString,
                                                             isCompleted : false)
                                            self.notes[indexPath.row] = newnote
                                            self.saveData()
                                          }))
            self.present(alert, animated: true, completion: nil)
        }
        editAction.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, handler) in
            self?.notes.remove(at: indexPath.row)
            self?.saveData()
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        firstTableView.deselectRow(at: indexPath, animated: true)
        
        if (changeState(at: indexPath.row) == true) {
            firstTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        } else {
            firstTableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        saveData()
    }
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
