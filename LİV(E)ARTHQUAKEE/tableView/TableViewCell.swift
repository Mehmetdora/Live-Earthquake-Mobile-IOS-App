//
//  TableViewCell.swift
//  LİV(E)ARTHQUAKEE
//
//  Created by Mehmet Dora on 23.05.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var işaretliCellİmage: UIImageView!
    @IBOutlet weak var depremBüyüklüğüLabel: UILabel!
    @IBOutlet weak var kaçDKönceLabel: UILabel!
    @IBOutlet weak var saatLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
