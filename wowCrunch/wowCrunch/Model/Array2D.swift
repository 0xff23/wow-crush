//
//  Array2D.swift
//  wowCrunch
//
//  Created by Kirill G on 1/26/18.
//  Copyright © 2018 Kirill. All rights reserved.
//

struct Array2D<T> {
    let columns: Int
    let rows: Int
    
    fileprivate var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows*columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get{
            return array[row*columns + column]
        }
        set{
            array[row*columns + column] = newValue
        }
    }
}
