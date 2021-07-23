//
//  FeedbackListCollectionViewCell.swift
//
//  Created by Владислав Костромин on 03.06.2021.
//

import UIKit
import SnapKit

class FeedbackListCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FeedbackListCollectionViewCell.self)
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.contentMode = .center
        label.textAlignment = .center
        label.textColor = PaletteApp.black
        label.font = OurFonts.fontPTSansRegular16
        label.contentMode = .redraw
        return label
    }()
    
    private var backView: UIView = {
        let backView = UIView()
        backView.layer.cornerRadius = 8
        backView.layer.shadowColor = PaletteApp.black.cgColor
        backView.layer.shadowOpacity = 0.11
        backView.layer.shadowOffset = .init(width: 0, height: 4)
        backView.layer.shadowRadius = 14
        return backView
    }()
    
    func configure(withItemModel item: FeedbackListSection) {
        let isSelected = item.isSelected
        
        addSubview(backView)
        addSubview(label)
        
        
        label.sizeToFit()
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.left.right.equalToSuperview().inset(12)
        }
        
        label.text = item.title
        
        backView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(36)
            make.left.right.equalToSuperview()
        }
        
        if isSelected {
            label.font = OurFonts.fontPTSansBold16
            backView.backgroundColor = PaletteApp.white
        } else {
            label.font = OurFonts.fontPTSansRegular16
            backView.backgroundColor = PaletteApp.gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
