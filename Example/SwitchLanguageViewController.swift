//
//  SwitchLanguageViewController.swift
//  TBRepeatPicker
//
//  Created by 洪鑫 on 15/10/9.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

private let SwitchLanguageViewControllerCellID = "SwitchLanguageViewControllerCell"

protocol SwitchLanguageViewControllerDelegate {
    func donePickingLanguage(language: TBRPLanguage)
}

class SwitchLanguageViewController: UITableViewController {
    var language: TBRPLanguage = .English
    var delegate: SwitchLanguageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SwitchLanguageViewController.cancelPressed))
    }
    
    @objc func cancelPressed() {
		dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: SwitchLanguageViewControllerCellID)
        if cell == nil {
			cell = UITableViewCell.init(style: .default, reuseIdentifier: SwitchLanguageViewControllerCellID)
        }

        cell?.textLabel?.text = languageStrings[indexPath.row]
        
        if language == languages[indexPath.row] {
			cell?.accessoryType = .checkmark
        } else {
			cell?.accessoryType = .none
        }
        
        return cell!
    }
    
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        language = languages[indexPath.row]
        tableView.reloadData()
        
        if let _ = delegate {
			dismiss(animated: true, completion: { () -> Void in
				self.delegate?.donePickingLanguage(language: self.language)
            })
        }
    }

}
