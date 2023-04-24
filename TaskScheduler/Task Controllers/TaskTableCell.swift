//
//  TaskTableCell.swift
//  TaskScheduler
//
//  Created by Mohamed Alalwan on 04/01/2021.
//

import UIKit

class TaskTableCell: UITableViewCell {

    //storyboard variables
    @IBOutlet var img: UIImageView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
