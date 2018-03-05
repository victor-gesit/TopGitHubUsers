import Foundation
import Alamofire

class NetworkController {
    public static func findUsers(language: String, location: String, completion: @escaping ([GitHubUser]?) -> Void) {
        let url = "https://api.github.com/search/users?q=location:\(location)+language:\(language)"
        print("URL", url)

        guard let requestString = URL(string: url)
            else { return }
        Alamofire.request(
            requestString,
            method: .get,
            parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let users = value["items"] as? [[String: Any]] else {
                        print("Malformed data received from fetchAllRooms service")
                        completion(nil)
                        return
                }
                var rating = 0
                let gitHubUsers = users.map({ user -> GitHubUser in
                    let userName = user["login"] as? String
                    let fullName = user["login"] as? String
                    let blogUrl = user[""] as? String
                    let publicRepos = user[""] as? Int
                    let bio = user[""] as? String
                    let imageURL = user["avatar_url"] as? String
                    rating += 1;
                    let gitHubUser = GitHubUser(nil, userName: userName, fullName: fullName, location: location, blogUrl: blogUrl, publicRepos: publicRepos, bio: bio, rating: rating, profileImageUrl: imageURL)
                    return gitHubUser
                })
                completion(gitHubUsers)
        }
    }
    public static func fetchImages(users: [GitHubUser]?, completion: @escaping ([GitHubUser]) -> Void) {
        if let users = users {
            for gitHubUser in users {
                if let imageUrl = gitHubUser.profileImageURL {
                    
                    Alamofire.request(imageUrl).responseData(completionHandler: { (response) in
                        if let data = response.data, response.error == nil {
                            print("Image gotten")
                            gitHubUser.profilePicture = UIImage(data: data)
                        }
                    })
                }
            }
            completion(users)
        }
    }
    
    public static func fetchGitHubUser(user: GitHubUser?, completion: @escaping (GitHubUser?) -> Void) {
        
        let githubUserName = user?.userName ?? "andela-gesit"
        let url = "https://api.github.com/users/\(githubUserName)"
        print(url)
        guard let requestString = URL(string: url)
            else { return }
        
        Alamofire.request(
            requestString,
            method: .get,
            parameters: ["include_docs": "true"])
            // .validate()
            .responseJSON { (response) in
                
                print("User Info:", response)
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any]
                    else {
                        print("Malformed data received from fetchAllRooms service")
                        completion(nil)
                        return
                }
                let userBio = value["bio"]
                let publicRepos = value["public_repos"]
                let company = value["company"]
                let name = value["name"]
                let location = value["location"]
                
                user?.fullName = name as? String
                user?.bio = userBio as? String
                user?.publicRepos = publicRepos as? Int
                user?.location = location as? String
                
                completion(user)
        }
        
    }

}
