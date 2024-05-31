class Github {
    var company: String
    
    init(apple: String) {
        self.company = apple
    }
    
    func boot() {
        print("\(company)")
    }
}

let efi = Github(apple: "/apple")
efi.boot()
