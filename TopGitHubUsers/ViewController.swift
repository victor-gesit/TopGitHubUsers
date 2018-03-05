import UIKit

class ViewController: UIViewController {
    
    // MARK: Public Instance Properties
    
    @IBOutlet public weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet public weak var developersCollectionView: UICollectionView!
    @IBOutlet public weak var locationTextView: UITextField!
    @IBOutlet public weak var pageTitleView: UIView!
    @IBOutlet public weak var searchResultLabel: UILabel!
    @IBOutlet public weak var stackTextView: UITextField!
    
    // MARK: Public Instance Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        developersCollectionView.delegate = self
        developersCollectionView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        setUpView()
        stackEntered("")
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let githubUser = gitHubUsers[indexPath.row]
        performSegue(withIdentifier: "listToProfileSegue", sender: githubUser)
    }
    
    @IBAction public func locationEntered(_ sender: Any) {

        activityIndicator.startAnimating()
        var language = stackTextView.text ?? ""
        var location = locationTextView.text ?? ""
        language = language.isEmpty ? "JavaScript" : language
        location = location.isEmpty ? "Lagos": location
        searchResultLabel.text = "\(language), \(location)"
        
        NetworkController.findUsers(language: language, location: location) { (users: [GitHubUser]?) -> Void in
            
            if let users = users {
                self.gitHubUsers = users
                self.developersCollectionView.reloadData()
                
                NetworkController.fetchImages(users: users) { (users: [GitHubUser]?) -> Void in
                    if let _ = users {
                        self.activityIndicator.stopAnimating()
                        self.developersCollectionView.collectionViewLayout.invalidateLayout()
                    }
                }
            }
        }
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToProfileSegue",
            sender is GitHubUser?,
            let destination = segue.destination as? ProfileViewController
        {
            let githubUser = sender as? GitHubUser
            NetworkController.fetchGitHubUser(user: githubUser) { user in
                let profileController: ProfileViewController = destination
                profileController.userProfile = user
            }
        }
    }
    
    @IBAction public func stackEntered(_ sender: Any) {
        activityIndicator.startAnimating()
        
        var language = stackTextView.text ?? ""
        var location = locationTextView.text ?? ""
        language = language.isEmpty ? "JavaScript" : language
        location = location.isEmpty ? "Lagos": location
        searchResultLabel.text = "\(language), \(location)"
        
        NetworkController.findUsers(language: language, location: location) { (users: [GitHubUser]?) -> Void in
            
            if let users = users {
                self.gitHubUsers = users
                self.developersCollectionView.reloadData()
                NetworkController.fetchImages(users: users) { (users: [GitHubUser]?) -> Void in
                    if let users = users {
                        self.activityIndicator.stopAnimating()
                        self.gitHubUsers = users
                        self.developersCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Private Instance Properties
    
    private var gitHubUsers: [GitHubUser] = []
    
    // MARK: Private Instance Methods
    
    
    private func setUpView() {
        pageTitleView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        pageTitleView.layer.shadowOpacity = 0.5
        pageTitleView.layer.shadowRadius = 5
        pageTitleView.layer.shadowOffset = CGSize(width: 3, height: 3)
        pageTitleView.layer.shouldRasterize = true
        
        if let layout = self.developersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let inset = (view.bounds.width - 310) / 3
            layout.sectionInset = UIEdgeInsets(top: 5, left: inset, bottom: 5, right: inset)
        }
    }
    
}

extension ViewController:  UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gitHubUsers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = developersCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! DeveloperCell
        let gitHubUser = gitHubUsers[indexPath.row]
        cell.userNameLabel.text = gitHubUser.userName
        cell.profileImageView.image = gitHubUser.profilePicture ?? UIImage(named: "profileImage")
        cell.rankLabel.text = gitHubUser.rating;
        return cell
    }

}
