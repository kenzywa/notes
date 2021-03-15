import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var firstTableView = UITableView(frame: .zero, style: .plain)
    var identifier = "MyCell"
    var notes = [Notes(titleOfNote: "Помыть машину", id : UUID().uuidString)]
                

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Ваши заметки"
        createTable()
        view.addSubview(firstTableView)
    }
    
    func createTable() {
        self.firstTableView.frame = view.bounds
        firstTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        self.firstTableView.delegate = self
        self.firstTableView.dataSource = self
        firstTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(firstTableView)
    }
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = notes.titleOfNote
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}




