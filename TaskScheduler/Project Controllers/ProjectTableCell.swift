//
//  ProjectTableCell.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 03/01/2021.
//

import UIKit

class ProjectTableCell: UITableViewCell {
    
    //storing variables from storyboard
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var tasksDone: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
