import Foundation

// Define the structs
struct MemeResult: Codable {
    let success: Bool
    let data: Data
}

extension MemeResult {
    struct Data: Codable {
        let memes: [Meme]
    }
}
struct Meme: Codable, Identifiable {
    let id: String
    let name: String
    let url: String
    let width: Int
    let height: Int
    let box_count: Int
    let captions: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, url, width, height, box_count, captions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        box_count = try container.decode(Int.self, forKey: .box_count)
        
        // Handle variation in captions property
        if let captionsArray = try? container.decode([String].self, forKey: .captions) {
            captions = captionsArray
        } else if let singleCaption = try? container.decode(String.self, forKey: .captions) {
            captions = [singleCaption]
        } else {
            captions = []
        }
    }
}

// Define the ViewModel class
class ViewModel: ObservableObject {
    @Published var memes: [Meme] = []
    
    
    func fetch() {
        guard let url = URL(string: "https://api.imgflip.com/get_memes") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(MemeResult.self, from: data)
                DispatchQueue.main.async {
                    self?.memes = result.data.memes
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    func removeMeme(_ meme: Meme) {
           if let index = memes.firstIndex(where: { $0.id == meme.id }) {
               memes.remove(at: index)
           }
       }
}
