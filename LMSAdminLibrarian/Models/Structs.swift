import Foundation

struct BooksAPI: Codable {
    let items: [BookItem]
}

struct BookItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]
    let publishedDate: String
    let pageCount: Int
    let language: String
    let imageLinks: ImageLinks?
    let categories: [String]?
    let description: String
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

struct BookMetaData : Identifiable {
    let id: String
    let title: String
    let authors: String
    let genre: String
    let publishedDate: String
    let pageCount: Int
    let language: String
    let coverImageLink: String
    let description: String
    let isbn: String
    let totalNumberOfCopies: Int
    let numberOfIssuedCopies: Int
    let bookColumn: String
    let bookShelf: String
    
    init(googleBookMetaData: GoogleBookMetaData, firestoreMetadata: FirestoreMetadata) {
        self.id = googleBookMetaData.id
        self.title = googleBookMetaData.title
        self.authors = googleBookMetaData.authors
        self.genre = googleBookMetaData.genre
        self.publishedDate = googleBookMetaData.publishedDate
        self.pageCount = googleBookMetaData.pageCount
        self.language = googleBookMetaData.language
        self.coverImageLink = googleBookMetaData.coverImageLink
        self.description = googleBookMetaData.description
        self.isbn = googleBookMetaData.isbn
        self.totalNumberOfCopies = firestoreMetadata.totalNumberOfCopies
        self.numberOfIssuedCopies = firestoreMetadata.numberOfIssuedCopies
        self.bookColumn = firestoreMetadata.bookColumn
        self.bookShelf = firestoreMetadata.bookShelf
    }
}

struct GoogleBookMetaData {
    let id: String
    let title: String
    let authors: String
    let genre: String
    let publishedDate: String
    let pageCount: Int
    let language: String
    let coverImageLink: String
    let description: String
    let isbn: String
}

struct FirestoreMetadata {
    var isbn: String
    var totalNumberOfCopies: Int
    var numberOfIssuedCopies: Int
    var bookColumn: String
    var bookShelf: String
}

struct CampainsEvents {
        var id: String
        var title: String
        var price: Double
        var startDate: Date
        var endDate: Date
        var description: String
}

let isbnList = [
    "9780061120084",
    "9780062316097",
    "9780141439518",
    "9780307474278",
    "9780345391803",
    "9780385490818",
    "9780451524935",
    "9780590353427",
    "9780618640157",
    "9780670097111",
    "9780743273565"
]
