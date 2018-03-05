import Foundation
import UIKit

class GitHubUser {
    var profilePicture: UIImage?
    let userName: String?
    var fullName: String?
    var location: String?
    var blogUrl: String?
    var publicRepos: Int?
    var bio: String?
    var rating: String?
    var profileImageURL: String?
    
    init(_ profilePicture: UIImage?, userName: String?, fullName: String?, location: String?, blogUrl: String?, publicRepos: Int?, bio: String?, rating: Int, profileImageUrl: String?) {
        self.profilePicture = profilePicture
        self.userName = userName
        self.fullName = fullName
        self.location = location
        self.blogUrl = blogUrl
        self.publicRepos = publicRepos
        self.bio = bio
        self.rating = "Rank: \(rating)"
        self.profileImageURL = profileImageUrl
    }
}
