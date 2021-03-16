import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var firstTableView = UITableView(frame: .zero, style: .plain)
    var identifier = "MyCell"
    var notes = [Notes(noteTitle: "Помыть машину", id : UUID().uuidString),
                 Notes(noteTitle: "Сходить в магазин", id: UUID().uuidString)] {
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.leftBarButtonItem = addButton
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
                                      message: .none,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .default
            textField.placeholder = "Введите текст новой заметки!"
        }
        alert.addAction(UIAlertAction(title: "Добавить",
                                      style: .default,
                                      handler: { [weak self] _ in
                                        guard let self = self,
                                              let textField = alert.textFields?.first,
                                              let text = textField.text else {
                                            return
                                        }
                                        let note = Notes(noteTitle: text, id: UUID().uuidString)
                                        self.notes.append(note)

                                      }))
        present(alert, animated: true, completion: nil)
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            notes.remove(at: indexPath.row)
            print(notes)
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
