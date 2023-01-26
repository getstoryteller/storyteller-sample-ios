import Foundation
import StorytellerSDK
import UIKit

final class StoriesRowCell: UITableViewCell {
    // MARK: Lifecycle

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        setupConstraints()
    }

    // MARK: Internal

    override func prepareForReuse() {
        super.prepareForReuse()
        storytellerRow.delegate = nil
        storytellerRow.prepareForReuse()
    }

    func bind(
        index: Int,
        categories: [String],
        cellType: StorytellerListViewCellType,
        height: CGFloat,
        delegate: StorytellerListDelegate)
    {
        storytellerRow.categories = categories
        storytellerRow.delegate = delegate
        storytellerRow.cellType = cellType.rawValue
        rowHeightConstraint?.constant = height
        storytellerRow.reloadData()
    }

    // MARK: Private

    private var storytellerRow = StorytellerRowView()
    private var rowHeightConstraint: NSLayoutConstraint?

    private func setupConstraints() {
        contentView.addSubview(storytellerRow)

        storytellerRow.layoutToEdges(of: contentView)
        rowHeightConstraint = storytellerRow.heightAnchor.constraint(equalToConstant: 0)
        rowHeightConstraint?.isActive = true
    }
}
