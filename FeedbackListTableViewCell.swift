//
//  FeedbackListTableViewCell.swift
//
//  Created by Владислав Костромин on 31.05.2021.
//

import UIKit
import SnapKit

class FeedbackListTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FeedbackListTableViewCell.self)
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = PaletteApp.black
        label.font = OurFonts.fontPTSansRegular16
        return label
    }()
    
    private var labelTiket = UILabel()
    
    func configuration(withItemModel item: FeedbackListModel) {
        accessoryType = .disclosureIndicator

        label.text = item.name
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(13)
            make.left.equalToSuperview().inset(16)
            
        }
        
        labelTiket = FeedbackTicketStatusLabel(for: item.status)
        labelTiket.text = item.status.localizedDescription
        addSubview(labelTiket)
        labelTiket.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(13)
            make.left.equalToSuperview().inset(16)
            
        }
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        selectionStyle = .none
        tintColor = PaletteApp.black
    }
}
