//
//  FolderCollectionViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit
import Kingfisher

class FolderCollectionViewCell: UICollectionViewCell {
    static let identifier = "FolderCollectionViewCell"
    
    let folderImage = UIImageView().then{
        $0.backgroundColor = .black_5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
    }
    let folderType = DefaultLabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitB2)
        $0.numberOfLines = 1
    }
    let countLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
        $0.textColor = .gray_300
    }
    let itemLabel = UILabel().then{
        $0.text = Message.item
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
        $0.textColor = .gray_300
    }
    let moreButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = Image.more
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: 테이블뷰의 셀이 재사용되기 전 호출되는 함수
    // 여기서 property들을 초기화해준다.
    override func prepareForReuse() {
        super.prepareForReuse()

        folderImage.image = nil
        folderType.text = nil
        countLabel.text = nil
    }
    // MARK: - Functions
    func setUpView() {
        contentView.addSubview(folderImage)
        contentView.addSubview(moreButton)
        contentView.addSubview(folderType)
        contentView.addSubview(countLabel)
        contentView.addSubview(itemLabel)
    }
    func setUpConstraint() {
        folderImage.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(folderImage.snp.width)
        }
        moreButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.trailing.equalToSuperview().offset(10)
            make.top.equalTo(folderImage.snp.bottom).offset(-10)
        }
        folderType.snp.makeConstraints { make in
            make.leading.equalTo(folderImage)
            make.top.equalTo(folderImage.snp.bottom).offset(10)
            make.trailing.equalTo(moreButton.snp.leading).offset(-10)
        }
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(folderType)
            make.top.equalTo(folderType.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-10)
        }
        itemLabel.snp.makeConstraints { make in
            make.centerY.equalTo(countLabel)
            make.leading.equalTo(countLabel.snp.trailing).offset(3)
        }
    }
    // API
    func setUpData(_ data: FolderModel) {
        if let image = data.folder_thumbnail {
            let processor = TintImageProcessor(tint: .black_5)
            self.folderImage.kf.setImage(with: URL(string: image), placeholder: UIImage(), options: [.processor(processor), .transition(.fade(0.5))])
        }
        if let folderName = data.folder_name {folderType.text = folderName}
        if let itemCount = data.item_count {countLabel.text = String(itemCount)}
    }
}
