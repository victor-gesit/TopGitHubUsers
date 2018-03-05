import UIKit

class DeveloperCell: UICollectionViewCell {
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    private func setUpView() {
        let topRightPath = UIBezierPath(roundedRect: profileImageView.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))

        let maskLayer = CAShapeLayer()
        maskLayer.path = topRightPath.cgPath
    
        self.layer.shadowOpacity = 0.5;
        profileImageView.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shouldRasterize = true
        self.layer.masksToBounds = false

        self.profileImageView.layer.mask = maskLayer
    }
}
