//
//  ViewController.swift
//  EKRminderUrlNotSave
//
//  Created by Kyosuke Takayama on 2019/11/04.
//  Copyright © 2019 Kyosuke Takayama. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isAuthorized() {
            reminderSaveTest()
        } else {
            let store = EKEventStore()
            store.requestAccess(to: .reminder) { (success, error) in
                if success {
                    self.reminderSaveTest()
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }

    func isAuthorized() -> Bool {
        return EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }

    func reminderSaveTest() {
        let store = EKEventStore()
        let reminder = EKReminder(eventStore: store)
        reminder.calendar = store.calendars(for: .reminder).first
        reminder.title = "Test Reminder"
        reminder.url = URL(string: "https://www.apple.com/")
        print("create \(reminder.title ?? "") \(reminder.url?.absoluteString ?? "nil")")

//        reminder.priority = 0
//        reminder.notes = "note text"
//        var calendar = Calendar(identifier: .gregorian)
//        calendar.locale = Locale(identifier: "en_US_POSIX")
//        reminder.dueDateComponents = calendar.dateComponents(
//            [.year, .month, .day, .hour, .minute ], from: Date())
//        reminder.dueDateComponents?.timeZone = TimeZone.current

        do {
            try store.save(reminder, commit: true)
        } catch let error {
            print(error.localizedDescription)
        }

        let predicate = store.predicateForReminders(in: nil)
        store.fetchReminders(matching: predicate) { (reminders) in
            guard let reminders = reminders else { return }
            for reminder in reminders {
                print("** \(reminder.title ?? "") \(reminder.url?.absoluteString ?? "nil")")
            }
        }
    }
}

