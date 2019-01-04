
import UIKit
import NotificationCenter

// MARK: - Controller

final class ViewController: UITableViewController {
    
    private var dataSource = TableViewDataSource()
    private var currentRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        post(with: dataSource.elements[indexPath.row])
        currentRow = indexPath.row
    }
}

extension ViewController: UIPencilInteractionDelegate {
    
    func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
        guard let row = currentRow else { return }
        
        let index: Int = {
            if dataSource.elements.count <= row+1  {
                return 0
            } else {
                return row+1
            }
        }()
        
        post(with: dataSource.elements[index])
        currentRow = index
        
        
//        switch UIPencilInteraction.preferredTapAction {
//        case .ignore:
//            print("----ignore")
//
//        case .switchPrevious:
//            print("----switchPrevious")
//
//        case .showColorPalette:
//            print("----showColorPalette")
//
//        case .switchEraser:
//            print("----switchEraser")
//
//        }
    }
}

private extension ViewController {
    
    func setup() {
        tableView.dataSource = dataSource

        let pencilInteraction = UIPencilInteraction()
        pencilInteraction.delegate = self
        view.addInteraction(pencilInteraction)
    }
    
    func post(with text: String) {
        NotificationCenter.default.post(
            name: .didTapCell,
            object: nil,
            userInfo: ["label": text]
        )
    }
    
}


// MARK: - DataSource

final class TableViewDataSource: NSObject {
    var elements: [String] = [
        "cell0",
        "cell1",
        "cell2",
        "cell3",
        "cell4",
        "cell5"
    ]
}

extension TableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = elements[indexPath.row]
        return cell
    }
}


// MARK: - Controller

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var centerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(update),
            name: .didTapCell,
            object: nil
        )
    }
}

@objc private extension DetailViewController {
    
    func update(_ notification: NSNotification) {
        centerLabel.text = notification.userInfo?["label"] as? String
    }
}


// MARK: - NSNotification

extension NSNotification.Name {
    static let didTapCell = NSNotification.Name("did_tap_cell")
}
