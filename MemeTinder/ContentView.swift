import SwiftUI

struct URLImage: View {
    
    let urlString: String
    @State var data: Data?
    @StateObject var viewModel = ViewModel()
    
    var body: some View{
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 200)
                .background(Color.gray)
                .cornerRadius(5.0)
                
        } else {
            SpinnerView()
                .onAppear {
                    fetchData()
                }
        }
    }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
struct CardView: View {
    @State private var offset: CGSize = .zero
    let meme: Meme
    @ObservedObject var viewModel: ViewModel
    
    
    var body: some View {
        VStack {
            URLImage(urlString: meme.url)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { value in
                            if offset.width > 100 { // Swipe right
                                withAnimation {
                                    viewModel.removeMeme(meme)
                                }
                            }
                            if offset.width < -100 { // Swipe left
                                withAnimation {
                                    viewModel.removeMeme(meme)
                                }
                            }
                            offset = .zero
                        }
                )
            
            HStack {
                VStack(alignment: .leading) {
                    Text(meme.url)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(meme.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
                
                .layoutPriority(100)
                
                Spacer()
            }
            .padding()
            HStack{
                VStack{
                    Button(action: {
                                    viewModel.removeMeme(meme)
                                }) {
                                    Text("Dislike 👎")
                                        .foregroundColor(.red)
                                }
                }
                Spacer()
                Button(action: {
                                viewModel.removeMeme(meme)
                            }) {
                                Text("Like 👍")
                                    .foregroundColor(.green)
                                    .cornerRadius(10)
                            
                            }
            }.padding(10)
                
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}


struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView(content: {
            ScrollView {
                
                LazyVStack {
                    ForEach(viewModel.memes) { meme in
                        CardView(meme: meme, viewModel: viewModel)
                            .padding(.vertical)
                    }
                }
                .gesture(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Gesture@*/LongPressGesture()/*@END_MENU_TOKEN@*/)
                .navigationTitle("FlameTinder 🔥")
                .onAppear {
                    viewModel.fetch()
                }
            }
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
    }
}
