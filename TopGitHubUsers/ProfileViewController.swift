import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userDetailsView: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var pageTitleView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var publicReposLabel: UILabel!
    
    
    public var userProfile: GitHubUser? {
        didSet {
            
            usernameLabel.text = userProfile?.userName
            fullNameLabel.text = userProfile?.fullName
            profileImageView.image = userProfile?.profilePicture
            publicReposLabel.text = "\(userProfile?.publicRepos ?? 0)"
            locationLabel.text = userProfile?.location
            bioTextView.text = userProfile?.bio
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backItem
        setupView()
        
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        profileImageView.layer.shadowOpacity = 0.5
        profileImageView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        profileImageView.layer.shadowRadius = 5
        
        bioTextView.layer.shadowOpacity = 0.5
        bioTextView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bioTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bioTextView.layer.shadowRadius = 5
        
        userDetailsView.layer.shadowOpacity = 0.5
        userDetailsView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        userDetailsView.layer.shadowOffset = CGSize(width: 0, height: 2)
        userDetailsView.layer.shadowRadius = 2
        
        pageTitleView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        pageTitleView.layer.shadowOpacity = 0.5
        pageTitleView.layer.shadowRadius = 5
        pageTitleView.layer.shadowOffset = CGSize(width: 3, height: 3)
        pageTitleView.layer.shouldRasterize = true
        

    }
}
