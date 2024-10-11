//
//  TableView.swift
//  Sepothipi
//
//  Created by Andri on 11/10/24.
//

import Foundation
import UIKit

extension UITableView {
    func deselectAllRows(animated: Bool) {
        guard let selectedRows = indexPathsForSelectedRows else { return }
        for indexPath in selectedRows { deselectRow(at: indexPath, animated: animated) }
    }
}
