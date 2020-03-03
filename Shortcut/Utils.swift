//
//  Utils.swift
//  Shortcut
//
//  Created by Kevin Titor on 1/3/2020.
//  Copyright © 2020 Kevin Titor. All rights reserved.
//
import Foundation

func readJSONFromFile(fileName: String) -> [ShortcutGroup]?
{
    var json: [ShortcutGroup]? = nil
    print("try to find preset data")
    if let path = Bundle.main.url(forResource: fileName, withExtension: "json") {
        print("using preset shortcuts data", path)
        do {
            // Getting data from JSON file using the file URL
            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            let decoder = JSONDecoder()
            json = try decoder.decode([ShortcutGroup].self, from: data)
        } catch let err {
            // Handle error here
            print("error loading file \(fileName)", err)
        }
    }
    return json
}
