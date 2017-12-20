//
//  TBRPCustomRepeatController.swift
//  TBRepeatPicker
//
//  Created by hongxin on 15/9/23.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit

private let TBRPCustomRepeatCellID = "TBRPCustomRepeatCell"
private let TBRPPickerViewCellID = "TBRPPickerViewCell"
private let TBRPSwitchCellID = "TBRPSwitchCell"
private let TBRPCollectionViewCellID = "TBRPCollectionViewCell"

protocol TBRPCustomRepeatControllerDelegate {
    func didFinishPickingCustomRecurrence(recurrence: TBRecurrence)
}

class TBRPCustomRepeatController: UITableViewController, TBRPPickerCellDelegate, TBRPSwitchCellDelegate, TBRPCollectionViewCellDelegate {
    // MARK: - Public properties
    var occurrenceDate = NSDate()
	var tintColor = UIColor.blue
    var language: TBRPLanguage = .English
    var delegate: TBRPCustomRepeatControllerDelegate?
    
    var recurrence = TBRecurrence() {
        didSet {
            frequency = recurrence.frequency
            interval = recurrence.interval
            selectedWeekdays = recurrence.selectedWeekdays
            byWeekNumber = recurrence.byWeekNumber
            selectedMonthdays = recurrence.selectedMonthdays
            selectedMonths = recurrence.selectedMonths
            pickedWeekNumber = recurrence.pickedWeekNumber
            pickedWeekday = recurrence.pickedWeekday
        }
    }
    var frequency: TBRPFrequency? {
        didSet {
            setupData()
            updateFrequencyTitleCell()
            updateIntervalTitleCell()
            updateMoreOptions()
            
            recurrence.frequency = frequency!
        }
    }
    var interval: Int? {
        didSet {
            updateIntervalTitleCell()
            
            recurrence.interval = interval!
        }
    }
    var selectedWeekdays = [Int]() {
        didSet {
            recurrence.selectedWeekdays = selectedWeekdays
        }
    }
    var selectedMonthdays = [Int]() {
        didSet {
            recurrence.selectedMonthdays = selectedMonthdays
        }
    }
    var selectedMonths = [Int]() {
        didSet {
            recurrence.selectedMonths = selectedMonths
        }
    }
    var pickedWeekNumber: TBRPWeekPickerNumber = .First {
        didSet {
            recurrence.pickedWeekNumber = pickedWeekNumber
        }
    }
    var pickedWeekday: TBRPWeekPickerDay = .Sunday {
        didSet {
            recurrence.pickedWeekday = pickedWeekday
        }
    }
    var byWeekNumber: Bool? {
        didSet {
            if let _ = byWeekNumber {
                updateWeekPickerOptions()
                
                recurrence.byWeekNumber = byWeekNumber!
            }
        }
    }
    
    // MARK: - Private properties
    private var internationalControl: TBRPInternationalControl?
    private var frequencies = [String]()
    private var units = [String]()
    private var pluralUnits = [String]()
    
    private let frequencyTitleIndexpath = IndexPath(row: 0, section: 0)
    private var intervalTitleIndexpath: IndexPath? {
        get {
            if hasRepeatPicker() && repeatPickerIndexPath == IndexPath(row: 1, section: 0) {
                return IndexPath(row: 2, section: 0)
            } else {
                return IndexPath(row: 1, section: 0)
            }
        }
    }
    private var frequencyTitleCell: TBRPCustomRepeatCell? {
        get {
			return tableView.cellForRow(at: frequencyTitleIndexpath as IndexPath) as? TBRPCustomRepeatCell
        }
    }
    private var intervalTitleCell: TBRPCustomRepeatCell? {
        get {
			return tableView.cellForRow(at: intervalTitleIndexpath! as IndexPath) as? TBRPCustomRepeatCell
        }
    }
    private var repeatPickerIndexPath: IndexPath?
    private var weekPickerIndexPath: IndexPath?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
    }
    
    private func commonInit() {
        internationalControl = TBRPInternationalControl(language: language)
		navigationItem.title = internationalControl?.localized(key: "TBRPPresetRepeatController.textLabel.custom", comment: "Custom")
        
        navigationController?.navigationBar.tintColor = tintColor
        tableView.tintColor = tintColor
		tableView.separatorStyle = .none
        
		frequencies = TBRPHelper.frequencies(language: language)
		units = TBRPHelper.units(language: language)
		pluralUnits = TBRPHelper.pluralUnits(language: language)
    }
    
	override func viewWillDisappear(_ animated: Bool) {
        if let _ = delegate {
			delegate?.didFinishPickingCustomRecurrence(recurrence: recurrence)
        }
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helper
    private func hasRepeatPicker() -> Bool {
        return repeatPickerIndexPath != nil
    }
    
    private func hasWeekPicker() -> Bool {
        return weekPickerIndexPath != nil
    }
    
    private func closeRepeatPicker() {
        if !hasRepeatPicker() {
            return;
        }
        
		tableView.deleteRows(at: [repeatPickerIndexPath! as IndexPath], with: .fade)
        repeatPickerIndexPath = nil
        updateDetailTextColor()
    }
    
    private func closeWeekPicker() {
        if !hasWeekPicker() {
            return;
        }
        
		tableView.deleteRows(at: [weekPickerIndexPath! as IndexPath], with: .fade)
        weekPickerIndexPath = nil
    }
    
    private func isRepeatPickerCell(indexPath: IndexPath) -> Bool {
        return hasRepeatPicker() && repeatPickerIndexPath == indexPath
    }
    
    private func isWeekPickerCell(indexPath: IndexPath) -> Bool {
        return hasWeekPicker() && weekPickerIndexPath == indexPath && (frequency == .Monthly || frequency == .Yearly)
    }
    
    private func isMonthsCollectionCell(indexPath: IndexPath) -> Bool {
        return indexPath == IndexPath(row: 0, section: 1) && frequency == .Yearly
    }
    
    private func isDaysCollectionCell(indexPath: IndexPath) -> Bool {
        return indexPath == IndexPath(row: 2, section: 1) && frequency == .Monthly
    }
    
    private func setupData() {
        // refresh weekPickerIndexPath
        if byWeekNumber == true {
            if frequency == .Yearly {
                weekPickerIndexPath = IndexPath(row: 1, section: 2)
            } else if frequency == .Monthly {
                weekPickerIndexPath = IndexPath(row: 2, section: 1)
            }
        }
    }
    
    private func updateFrequencyTitleCell() {
        frequencyTitleCell?.detailTextLabel?.text = frequencies[(frequency?.rawValue)!]
    }
    
    private func updateIntervalTitleCell() {
        intervalTitleCell?.detailTextLabel?.text = unitString()
        
        if hasRepeatPicker() && repeatPickerIndexPath == IndexPath(row: 2, section: 0) {
			let cell = tableView.cellForRow(at: repeatPickerIndexPath! as IndexPath) as! TBRPPickerViewCell
            cell.unit = unit()
        }
    }
    
    private func updateDetailTextColor() {
        if repeatPickerIndexPath == IndexPath(row: 1, section: 0) {
            frequencyTitleCell?.detailTextLabel?.textColor = tintColor
        } else if repeatPickerIndexPath == IndexPath(row: 2, section: 0) {
            intervalTitleCell?.detailTextLabel?.textColor = tintColor
        } else {
            let detailTextColor = TBRPHelper.detailTextColor()
            frequencyTitleCell?.detailTextLabel?.textColor = detailTextColor
            intervalTitleCell?.detailTextLabel?.textColor = detailTextColor
        }
    }
    
    private func updateMoreOptions() {
        if frequency == .Daily {
            let deleteRange = NSMakeRange(1, tableView.numberOfSections - 1)
            
            tableView.beginUpdates()
			tableView.deleteSections(NSIndexSet(indexesIn: deleteRange) as IndexSet, with: .fade)
            tableView.endUpdates()
        } else if frequency == .Weekly || frequency == .Monthly {
            if tableView.numberOfSections == 1 {
                tableView.beginUpdates()
				tableView.insertSections(NSIndexSet(index: 1) as IndexSet, with: .fade)
                tableView.endUpdates()
            } else if tableView.numberOfSections == 2 {
                tableView.beginUpdates()
				tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .fade)
                tableView.endUpdates()
            } else if tableView.numberOfSections == 3 {
                tableView.beginUpdates()
				tableView.deleteSections(NSIndexSet(index: 2) as IndexSet, with: .fade)
				tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .fade)
                tableView.endUpdates()
            }
        } else if frequency == .Yearly {
            if tableView.numberOfSections == 1 {
                let insertYearOptionsRange = NSMakeRange(1, 2)
				tableView.insertSections(NSIndexSet(indexesIn: insertYearOptionsRange) as IndexSet, with: .fade)
            } else if tableView.numberOfSections == 2 {
                tableView.beginUpdates()
				tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .fade)
				tableView.insertSections(NSIndexSet(index: 2) as IndexSet, with: .fade)
                tableView.endUpdates()
            }
        }
    }
    
    private func updateWeekPickerOptions () {
        if frequency == .Monthly {
            tableView.beginUpdates()
            if hasRepeatPicker() {
                closeRepeatPicker()
            }
            
            
            weekPickerIndexPath = IndexPath(row: 2, section: 1)
			tableView.reloadRows(at: [weekPickerIndexPath! as IndexPath], with: .fade)
            
            if byWeekNumber == false {
                weekPickerIndexPath = nil
            }
            
            tableView.endUpdates()
        } else if frequency == .Yearly {
            tableView.beginUpdates()
            if hasRepeatPicker() {
                closeRepeatPicker()
            }
            
            if byWeekNumber == true {
                weekPickerIndexPath = IndexPath(row: 1, section: 2)
				tableView.insertRows(at: [weekPickerIndexPath! as IndexPath], with: .fade)
            } else if byWeekNumber == false {
                closeWeekPicker()
            }
            
            tableView.endUpdates()
        }
        
        updateIntervalCellBottomSeparator()
    }
    
    private func updateFooterTitle() {
		let footerView = tableView.footerView(forSection: 0)
        
        tableView.beginUpdates()
        footerView?.textLabel?.text = footerTitle()
        tableView.endUpdates()
        footerView?.setNeedsLayout()
    }
    
    private func footerTitle() -> String? {
		return TBRPHelper.recurrenceString(recurrence: recurrence, occurrenceDate: occurrenceDate, language: language)
    }
    
    private func unit() -> String? {
		guard let interval = interval else {
			return nil
		}

        if interval == 1 {
            return units[(frequency?.rawValue)!]
        } else if interval > 1 {
            return pluralUnits[(frequency?.rawValue)!]
        } else {
            return nil
        }
    }
    
    private func unitString() -> String? {
		guard let interval = interval else {
			return nil
		}
        if interval == 1 {
            return unit()
        } else if interval > 1 {
			return "\(interval)" + " " + unit()!
        } else {
            return nil
        }
    }
    
    private func updateIntervalCellBottomSeparator() {
        if hasRepeatPicker() && intervalTitleIndexpath!.row == 1 {
			intervalTitleCell?.updateBottomSeparatorWithLeftX(leftX: TBRPHelper.leadingMargin())
        } else {
			intervalTitleCell?.updateBottomSeparatorWithLeftX(leftX: 0)
        }
    }
    
    private func updateYearlyWeekCellBottomSeparator() {
		let yearlyWeekCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2) as IndexPath) as! TBRPSwitchCell
        if byWeekNumber == true {
			yearlyWeekCell.updateBottomSeparatorWithLeftX(leftX: TBRPHelper.leadingMargin())
        } else {
			yearlyWeekCell.updateBottomSeparatorWithLeftX(leftX: 0)
        }
    }

    // MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
        if frequency == .Daily {
            return 1
        } else if frequency == .Yearly {
            return 3
        } else {
            return 2
        }
    }

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if hasRepeatPicker() {
                return 3
            } else {
                return 2
            }
        } else if section == 1 {
            if frequency == .Weekly {
                return 7
            } else if frequency == .Monthly {
                return 3
            } else if frequency == .Yearly {
                return 1
            } else {
                return 0
            }
        } else {
            if byWeekNumber == true {
                return 2
            }
            return 1
        }
    }
    
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return footerTitle()
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		if view.isKind(of: UITableViewHeaderFooterView.self) {
            let tableViewHeaderFooterView = view as! UITableViewHeaderFooterView
			tableViewHeaderFooterView.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(13.0))
        }
    }

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if isRepeatPickerCell(indexPath: indexPath as IndexPath) || isWeekPickerCell(indexPath: indexPath as IndexPath) {
            return TBRPPickerHeight
		} else if isMonthsCollectionCell(indexPath: indexPath as IndexPath) {
            return TBRPMonthsCollectionHeight
		} else if isDaysCollectionCell(indexPath: indexPath as IndexPath) {
            return TBRPDaysCollectionHeight
        }
        
        return 44.0
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
			if isRepeatPickerCell(indexPath: indexPath as IndexPath) {
				if indexPath == IndexPath(row: 1, section: 0) as IndexPath {
					let cell = TBRPPickerViewCell(style: .default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Frequency, language: language)
                    cell.frequency = frequency
                    cell.delegate = self
					cell.selectionStyle = .none
					cell.accessoryType = .none
                    return cell
                } else {
					let cell = TBRPPickerViewCell(style: .default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Interval, language: language)
                    cell.unit = unit()
                    cell.interval = interval
                    cell.delegate = self
					cell.selectionStyle = .none
					cell.accessoryType = .none
                    return cell
                }
            } else {
				var cell = tableView.dequeueReusableCell(withIdentifier: TBRPCustomRepeatCellID) as? TBRPCustomRepeatCell
                if cell == nil {
					cell = TBRPCustomRepeatCell(style: .value1, reuseIdentifier: TBRPCustomRepeatCellID)
                }
				cell?.selectionStyle = .default
				cell!.accessoryType = .none
                
				if indexPath == frequencyTitleIndexpath as IndexPath {
					cell?.textLabel?.text = internationalControl?.localized(key: "TBRPCustomRepeatController.textLabel.frequency", comment: "Frequency")
                    cell?.detailTextLabel?.text = frequencies[(frequency?.rawValue)!]
                    if hasRepeatPicker() && repeatPickerIndexPath == IndexPath(row: 1, section: 0) {
                        cell?.detailTextLabel?.textColor = tintColor
                    } else {
                        cell?.detailTextLabel?.textColor = TBRPHelper.detailTextColor()
                    }
                    
                    cell?.addSectionTopSeparator()
                } else if indexPath == (intervalTitleIndexpath! as IndexPath) {
					cell?.textLabel?.text = internationalControl?.localized(key: "TBRPCustomRepeatController.textLabel.interval", comment: "Every")
                    cell?.detailTextLabel?.text = unitString()
                    
                    if hasRepeatPicker() && repeatPickerIndexPath == IndexPath(row: 2, section: 0) {
						cell?.updateBottomSeparatorWithLeftX(leftX: TBRPHelper.leadingMargin())
                        cell?.detailTextLabel?.textColor = tintColor
                    } else {
						cell?.updateBottomSeparatorWithLeftX(leftX: 0)
                        cell?.detailTextLabel?.textColor = TBRPHelper.detailTextColor()
                    }
                }
                
                return cell!
            }
        } else if indexPath.section == 1 {
            if frequency == .Weekly {
				var cell = tableView.dequeueReusableCell(withIdentifier: TBRPCustomRepeatCellID) as? TBRPCustomRepeatCell
                if cell == nil {
					cell = TBRPCustomRepeatCell(style: .value1, reuseIdentifier: TBRPCustomRepeatCellID)
                }
				cell?.selectionStyle = .default
                
				cell?.textLabel?.text = TBRPHelper.weekdays(language: language)[indexPath.row]
                cell?.detailTextLabel?.text = nil
                if selectedWeekdays.contains(indexPath.row) == true {
					cell?.accessoryType = .checkmark
                } else {
					cell?.accessoryType = .none
                }
                
                if indexPath.row == 0 {
                    cell?.addSectionTopSeparator()
				} else if indexPath.row == TBRPHelper.weekdays(language: language).count - 1 {
					cell?.updateBottomSeparatorWithLeftX(leftX: 0)
                }
                
                return cell!
            } else if frequency == .Monthly {
                if indexPath.row == 2 {
                    if byWeekNumber == true {
						let cell = TBRPPickerViewCell(style: .default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Week, language: language)
                        cell.delegate = self
                        cell.pickedWeekNumber = pickedWeekNumber
                        cell.pickedWeekday = pickedWeekday
						cell.selectionStyle = .none
						cell.accessoryType = .none
                        return cell
                    } else {
						let cell = TBRPCollectionViewCell(style: .default, reuseIdentifier: TBRPCollectionViewCellID, mode: .Days, language: language)
						cell.selectionStyle = .none
                        cell.selectedMonthdays = selectedMonthdays
                        cell.delegate = self
                        
                        return cell
                    }
                } else {
					var cell = tableView.dequeueReusableCell(withIdentifier: TBRPCustomRepeatCellID) as? TBRPCustomRepeatCell
                    if cell == nil {
						cell = TBRPCustomRepeatCell(style: .value1, reuseIdentifier: TBRPCustomRepeatCellID)
                    }
					cell?.selectionStyle = .default
                    
                    switch indexPath.row {
                    case 0:
						cell?.textLabel?.text = internationalControl?.localized(key: "TBRPCustomRepeatController.textLabel.date", comment: "Each")
						cell?.selectionStyle = .default
                        if byWeekNumber == true {
							cell?.accessoryType = .none
                        } else {
							cell?.accessoryType = .checkmark
                        }
                        cell?.addSectionTopSeparator()
                        
                    case 1:
						cell?.textLabel?.text = internationalControl?.localized(key: "TBRPCustomRepeatController.weekCell.onThe", comment: "On the...")
						cell?.selectionStyle = .default
                        if byWeekNumber == true {
							cell?.accessoryType = .checkmark
                        } else {
							cell?.accessoryType = .none
                        }
                        
                        cell?.addSectionBottomSeparator()
                        
                    default:
                        cell?.textLabel?.text = nil
                    }
                    cell?.detailTextLabel?.text = nil
                    
                    return cell!
                }
            } else {
				let cell = TBRPCollectionViewCell(style: .default, reuseIdentifier: TBRPCollectionViewCellID, mode: .Months, language: language)
				cell.selectionStyle = .none
                cell.selectedMonths = selectedMonths
                cell.delegate = self
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
				let cell = TBRPSwitchCell(style: .default, reuseIdentifier: TBRPSwitchCellID)
                
                if let _ = byWeekNumber {
                    cell.weekSwitch?.setOn(byWeekNumber!, animated: true)
                } else {
                    cell.weekSwitch?.setOn(false, animated: false)
                }
				cell.textLabel?.text = internationalControl?.localized(key: "TBRPCustomRepeatController.weekCell.daysOfWeek", comment: "Days of Week")
				cell.selectionStyle = .none
				cell.accessoryType = .none
                cell.delegate = self
                
                cell.addSectionTopSeparator()
                if byWeekNumber == true {
					cell.updateBottomSeparatorWithLeftX(leftX: TBRPHelper.leadingMargin())
                } else {
					cell.updateBottomSeparatorWithLeftX(leftX: 0)
                }
                return cell
            } else {
				let cell = TBRPPickerViewCell(style: .default, reuseIdentifier: TBRPPickerViewCellID, pickerStyle: .Week, language: language)
                cell.delegate = self
                cell.pickedWeekNumber = pickedWeekNumber
                cell.pickedWeekday = pickedWeekday
				cell.selectionStyle = .none
				cell.accessoryType = .none
                return cell
            }
        }
    }
    
    // MARK: - Table view delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == repeatPickerIndexPath {
            return
        }
        
		let cell = tableView.cellForRow(at: indexPath)
        if cell?.reuseIdentifier == TBRPCustomRepeatCellID {
            if indexPath.section == 0 {
                tableView.beginUpdates()
                
                if hasRepeatPicker() {
                    let repeatPickerIndexPathTemp = repeatPickerIndexPath
                    closeRepeatPicker()
                    
                    if indexPath.row == (repeatPickerIndexPathTemp!.row) - 1 {
                        
                    } else {
                        if indexPath == frequencyTitleIndexpath {
                            repeatPickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                        } else {
                            repeatPickerIndexPath = indexPath
                        }
                        
						tableView.insertRows(at: [repeatPickerIndexPath! as IndexPath], with: .fade)
                    }
                } else {
                    repeatPickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
					tableView.insertRows(at: [repeatPickerIndexPath! as IndexPath], with: .fade)
                }
                
                tableView.endUpdates()
                
                updateIntervalCellBottomSeparator()
                updateDetailTextColor()
            } else if indexPath.section == 1 {
                if frequency == .Weekly {
                    if hasRepeatPicker() {
                        tableView.beginUpdates()
                        closeRepeatPicker()
                        tableView.endUpdates()
                        
                        updateIntervalCellBottomSeparator()
                    }
                    
					let cell = tableView.cellForRow(at: indexPath as IndexPath)
                    let day = indexPath.row
                    
                    if selectedWeekdays.count == 1 && selectedWeekdays.contains(day) == true {
                        return
                    }
                    
                    if selectedWeekdays.contains(day) == true {
						cell?.accessoryType = .none
						selectedWeekdays.removeObject(object: day)
                    } else {
						cell?.accessoryType = .checkmark
                        selectedWeekdays.append(day)
                    }
                    
                    updateFooterTitle()
                } else if frequency == .Monthly {
                    let dateCellIndexPath = IndexPath(row: 0, section: 1)
                    let weekCellIndexPath = IndexPath(row: 1, section: 1)
					let dateCell = tableView.cellForRow(at: dateCellIndexPath as IndexPath)
					let weekCell = tableView.cellForRow(at: weekCellIndexPath as IndexPath)
                    
                    if indexPath == weekCellIndexPath && byWeekNumber == false {
                        byWeekNumber = true
						weekCell?.accessoryType = .checkmark
						dateCell?.accessoryType = .none
                    } else if indexPath == dateCellIndexPath && byWeekNumber == true {
                        byWeekNumber = false
						dateCell?.accessoryType = .checkmark
						weekCell?.accessoryType = .none
                    }
                    
                    updateFooterTitle()
                }
            }
        }
    }
    
    // MARK: - TBRPPickerCell delegate
    func pickerDidPick(pickerView: UIPickerView, pickStyle: TBRPPickerStyle, didSelectRow row: Int, inComponent component: Int) {
        if pickStyle == .Frequency {
            frequency = TBRPFrequency(rawValue: row)
        } else if pickStyle == .Interval {
            if component == 0 {
                interval = row + 1
            }
        } else if pickStyle == .Week {
            if hasRepeatPicker() {
                tableView.beginUpdates()
                closeRepeatPicker()
                tableView.endUpdates()
                
                updateIntervalCellBottomSeparator()
            }
            
            if component == 0 {
                pickedWeekNumber = TBRPWeekPickerNumber(rawValue: row)!
            } else if component == 1 {
                pickedWeekday = TBRPWeekPickerDay(rawValue: row)!
            }
        }
        
        updateFooterTitle()
    }
    
    // MARK: - TBRPSwitchCell delegate
    func didSwitch(sender: AnyObject) {
        if let weekSwitch = sender as? UISwitch {
			byWeekNumber = weekSwitch.isOn
            
            updateYearlyWeekCellBottomSeparator()
            updateFooterTitle()
        }
    }
    
    
    // MARK: - TBRPCollectionViewCell delegate
    func selectedMonthdaysDidChanged(days: [Int]) {
        if hasRepeatPicker() {
            tableView.beginUpdates()
            closeRepeatPicker()
            tableView.endUpdates()
            
            updateIntervalCellBottomSeparator()
        }
        
        selectedMonthdays = days
        
        updateFooterTitle()
    }
    
    func selectedMonthsDidChanged(months: [Int]) {
        if hasRepeatPicker() {
            tableView.beginUpdates()
            closeRepeatPicker()
            tableView.endUpdates()
            
            updateIntervalCellBottomSeparator()
        }
        
        selectedMonths = months
        
        updateFooterTitle()
    }
}
