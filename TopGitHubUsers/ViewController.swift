import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var developersCollectionView: UICollectionView!
    @IBOutlet weak var pageTitleView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var stackTextView: UITextField!
    
    @IBOutlet weak var locationTextView: UITextField!
    
    @IBOutlet weak var searchResultLabel: UILabel!
    
    private var gitHubUsers: [GitHubUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        developersCollectionView.delegate = self
        developersCollectionView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        setUpView()
        stackEntered("")
    }
    
    @IBAction func stackEntered(_ sender: Any) {
        stackTextView.resignFirstResponder()
        locationTextView.resignFirstResponder()
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
    
    @IBAction func locationEntered(_ sender: Any) {
        stackTextView.resignFirstResponder()
        locationTextView.resignFirstResponder()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let githubUser = gitHubUsers[indexPath.row]
        performSegue(withIdentifier: "listToProfileSegue", sender: githubUser)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
