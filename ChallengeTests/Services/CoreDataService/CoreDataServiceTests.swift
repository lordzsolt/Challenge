//
//  CoreDataServiceTests.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/25/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import XCTest
import CoreData
@testable import Challenge

class CoreDataServiceTests: XCTestCase {

    private var service: CoreDataService! = nil
    private var container: NSPersistentContainer! = nil
    
    override func setUp() {
        super.setUp()

        container = NSPersistentContainer(name: "Challenge")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        service = CoreDataService(container: container)
    }


    // MARK: - User

    func testCanAddUser() {
        // Arrange
        let userDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Common.identifier: 1,
            ApiConstants.Key.User.name: "Leanne Graham",
            ApiConstants.Key.User.username: "Bret",
            ApiConstants.Key.User.email: "Sincere@april.biz",
            ApiConstants.Key.User.address: [
                ApiConstants.Key.Address.street: "Kulas Light",
                ApiConstants.Key.Address.suite: "Apt. 556",
                ApiConstants.Key.Address.city: "Gwenborough",
                ApiConstants.Key.Address.zipcode: "92998-3874",
                ApiConstants.Key.Address.geo: [
                    ApiConstants.Key.Address.latitude: "-37.3159",
                    ApiConstants.Key.Address.longitude: "81.1496"
                ]
            ],
            ApiConstants.Key.User.phone: "1-770-736-8031 x56442",
            ApiConstants.Key.User.website: "hildegard.org",
            ApiConstants.Key.User.company: [
                ApiConstants.Key.Company.name: "Romaguera-Crona",
                ApiConstants.Key.Company.catchPhrase: "Multi-layered client-server neural-net",
                ApiConstants.Key.Company.businessStategy: "harness real-time e-markets"
            ]
        ]

        // Act
        service.addUsers(from: [userDetails])

        // Assert
        let user: User? = getEntities().first
        XCTAssertNotNil(user)
    }

    func testCanAddTwoUsers() {
        // Arrange
        let userDetails: Array<Dictionary<String, Any>> = [
            [
                ApiConstants.Key.Common.identifier: 1,
                ApiConstants.Key.User.name: "Leanne Graham",
                ApiConstants.Key.User.username: "Bret",
                ApiConstants.Key.User.email: "Sincere@april.biz",
                ApiConstants.Key.User.address: [
                    ApiConstants.Key.Address.street: "Kulas Light",
                    ApiConstants.Key.Address.suite: "Apt. 556",
                    ApiConstants.Key.Address.city: "Gwenborough",
                    ApiConstants.Key.Address.zipcode: "92998-3874",
                    ApiConstants.Key.Address.geo: [
                        ApiConstants.Key.Address.latitude: "-37.3159",
                        ApiConstants.Key.Address.longitude: "81.1496"
                    ]
                ],
                ApiConstants.Key.User.phone: "1-770-736-8031 x56442",
                ApiConstants.Key.User.website: "hildegard.org",
                ApiConstants.Key.User.company: [
                    ApiConstants.Key.Company.name: "Romaguera-Crona",
                    ApiConstants.Key.Company.catchPhrase: "Multi-layered client-server neural-net",
                    ApiConstants.Key.Company.businessStategy: "harness real-time e-markets"
                ]
            ],
            [
                ApiConstants.Key.Common.identifier: 2,
                ApiConstants.Key.User.name: "Ervin Howell",
                ApiConstants.Key.User.username: "Antonette",
                ApiConstants.Key.User.email: "Shanna@melissa.tv",
                ApiConstants.Key.User.address: [
                    ApiConstants.Key.Address.street: "Victor Plains",
                    ApiConstants.Key.Address.suite: "Suite 879",
                    ApiConstants.Key.Address.city: "Wisokyburgh",
                    ApiConstants.Key.Address.zipcode: "90566-7771",
                    ApiConstants.Key.Address.geo: [
                        ApiConstants.Key.Address.latitude: "-43.9509",
                        ApiConstants.Key.Address.longitude: "-34.4618"
                    ]
                ],
                ApiConstants.Key.User.phone: "010-692-6593 x09125",
                ApiConstants.Key.User.website: "anastasia.net",
                ApiConstants.Key.User.company: [
                    ApiConstants.Key.Company.name: "Deckow-Crist",
                    ApiConstants.Key.Company.catchPhrase: "Proactive didactic contingency",
                    ApiConstants.Key.Company.businessStategy: "synergize scalable supply-chains"
                ]
            ]
        ]

        // Act
        service.addUsers(from: userDetails)

        // Assert
        let users: [User]? = getEntities()
        XCTAssertTrue(users?.count == 2)
    }

    func testAddedUserHasDetailsSet() {
        // Arrange
        let id = 1
        let name = "Leanne Graham"
        let username = "Bret"
        let email = "Sincere@april.biz"
        let street = "Kulas Light"
        let suite = "Apt. 556"
        let city = "Gwenborough"
        let zipcode = "92998-3874"
        let latitude = "-37.3159"
        let longitude = "81.1496"
        let phone = "1-770-736-8031 x56442"
        let website = "hildegard.org"
        let companyName = "Romaguera-Crona"
        let catchPhrase = "Multi-layered client-server neural-net"
        let bs = "harness real-time e-markets"

        let userDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Common.identifier: id,
            ApiConstants.Key.User.name: name,
            ApiConstants.Key.User.username: username,
            ApiConstants.Key.User.email: email,
            ApiConstants.Key.User.address: [
                ApiConstants.Key.Address.street: street,
                ApiConstants.Key.Address.suite: suite,
                ApiConstants.Key.Address.city: city,
                ApiConstants.Key.Address.zipcode: zipcode,
                ApiConstants.Key.Address.geo: [
                    ApiConstants.Key.Address.latitude: latitude,
                    ApiConstants.Key.Address.longitude: longitude
                ]
            ],
            ApiConstants.Key.User.phone: phone,
            ApiConstants.Key.User.website: website,
            ApiConstants.Key.User.company: [
                ApiConstants.Key.Company.name: companyName,
                ApiConstants.Key.Company.catchPhrase: catchPhrase,
                ApiConstants.Key.Company.businessStategy: bs
            ]
        ]

        // Act
        service.addUsers(from: [userDetails])

        // Assert
        let user: User? = getEntities().first

        XCTAssertEqual(user?.id, Int64(id))
        XCTAssertEqual(user?.name, name)
        XCTAssertEqual(user?.username, username)
        XCTAssertEqual(user?.email, email)
        XCTAssertEqual(user?.phone, phone)
        XCTAssertEqual(user?.website, website)

        XCTAssertEqual(user?.address?.street, street)
        XCTAssertEqual(user?.address?.suite, suite)
        XCTAssertEqual(user?.address?.city, city)
        XCTAssertEqual(user?.address?.zipCode, zipcode)
        XCTAssertEqual(user?.address?.latitude, latitude)
        XCTAssertEqual(user?.address?.longitude, longitude)

        XCTAssertEqual(user?.company?.name, companyName)
        XCTAssertEqual(user?.company?.catchPhrase, catchPhrase)
        XCTAssertEqual(user?.company?.businessStrategy, bs)
    }

    func testCanUpdateStubUser() {
        // Arrange
        let id = 1
        let userId = 2

        let postDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Post.userId: userId,
            ApiConstants.Key.Common.identifier: id,
            ]

        service.addPosts(from: [postDetails])

        let name = "Leanne Graham"

        let userDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Common.identifier: userId,
            ApiConstants.Key.User.name: name
        ]

        // Act
        service.addUsers(from: [userDetails])

        // Assert
        let post: Post? = getEntities().first
        XCTAssertEqual(post?.user?.name, name)
    }

    func testUpdatesAreCorrectlyReflected() {
        // Arrange
        let id = 1
        let name = "Leanne Graham"

        let userDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Common.identifier: id,
            ApiConstants.Key.User.name: name,
        ]
        service.addUsers(from: [userDetails])

        let updatedName = "Zsolt Kovacs"
        let updatedDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Common.identifier: id,
            ApiConstants.Key.User.name: updatedName,
            ]

        // Act
        service.addUsers(from: [updatedDetails])

        // Assert
        let user: User? = getEntities().first
        XCTAssertEqual(user?.name, updatedName)
    }


    // MARK: - Post

    func testCanAddPost() {
        // Arrange
        let postDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Post.userId: 1,
            ApiConstants.Key.Common.identifier: 1,
            ApiConstants.Key.Post.title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            ApiConstants.Key.Post.body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
        ]

        // Act
        service.addPosts(from: [postDetails])

        // Assert
        let post: Post? = getEntities().first
        XCTAssertNotNil(post)
    }

    func testCanAddTwoPosts() {
        // Arrange
        let postDetails: Array<Dictionary<String, Any>> = [
            [
                ApiConstants.Key.Post.userId: 1,
                ApiConstants.Key.Common.identifier: 1,
                ApiConstants.Key.Post.title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                ApiConstants.Key.Post.body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
            ],
            [
                ApiConstants.Key.Post.userId: 1,
                ApiConstants.Key.Common.identifier: 2,
                ApiConstants.Key.Post.title: "qui est esse",
                ApiConstants.Key.Post.body: "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla"
            ]
        ]

        // Act
        service.addPosts(from: postDetails)

        // Assert
        let posts: [Post]? = getEntities()
        XCTAssertTrue(posts?.count == 2)
    }

    func testAddedPostHasDetailsSet() {
        // Arrange
        let id = 1
        let title = "sunt aut facere repellat provident occaecati excepturi optio reprehenderit"
        let body = "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"

        let postDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Common.identifier: id,
            ApiConstants.Key.Post.title: title,
            ApiConstants.Key.Post.body: body
        ]
        
        // Act
        service.addPosts(from: [postDetails])
        
        // Assert
        let post: Post? = getEntities().first
        XCTAssertEqual(post?.id, Int64(id))
        XCTAssertEqual(post?.title, title)
        XCTAssertEqual(post?.body, body)
    }

    func testUserGetsCreatedForPost() { // When adding a post where the User with userId isn't created yet, a stub user should be created
        // Arrange
        let id = 1
        let userId = 1

        let postDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Post.userId: userId,
            ApiConstants.Key.Common.identifier: id,
        ]

        // Act
        service.addPosts(from: [postDetails])

        // Assert
        let post: Post? = getEntities().first
        XCTAssertNotNil(post?.user)
        XCTAssertEqual(post?.user?.id, Int64(userId))
        XCTAssertNil(post?.user?.name, "This should be a stub user")
    }


    // MARK: - Album

    func testCanAddAlbum() {
        // Arrange
        let albumDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Album.userId: 1,
            ApiConstants.Key.Common.identifier: 1,
            ApiConstants.Key.Album.title: "quidem molestiae enim"
        ]

        // Act
        service.addAlbums(from: [albumDetails])

        // Assert
        let album: Album? = getEntities().first
        XCTAssertNotNil(album)
    }

    func testCanAddTwoAlbums() {
        // Arrange
        let albumDetails: Array<Dictionary<String, Any>> = [
            [
                ApiConstants.Key.Album.userId: 1,
                ApiConstants.Key.Common.identifier: 1,
                ApiConstants.Key.Album.title: "quidem molestiae enim"
            ],
            [
                ApiConstants.Key.Album.userId: 1,
                ApiConstants.Key.Common.identifier: 2,
                ApiConstants.Key.Album.title: "sunt qui excepturi placeat culpa"
            ]
        ]

        // Act
        service.addAlbums(from: albumDetails)

        // Assert
        let albums: [Album]? = getEntities()
        XCTAssertTrue(albums?.count == 2)
    }

    func testAddedAlbumHasDetailsSet() {
        // Arrange
        let id = 1
        let title = "quidem molestiae enim"

        let albumDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Common.identifier: id,
            ApiConstants.Key.Album.title: title
        ]

        // Act
        service.addAlbums(from: [albumDetails])
        
        // Assert
        let album: Album? = getEntities().first
        XCTAssertEqual(album?.id, Int64(id))
        XCTAssertEqual(album?.title, title)
    }

    func testUserGetsCreatedForAlbum() { // When adding a post where the User with userId isn't created yet, a stub user should be created
        // Arrange
        let id = 1
        let userId = 1

        let postDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Album.userId: userId,
            ApiConstants.Key.Common.identifier: id,
            ]

        // Act
        service.addAlbums(from: [postDetails])

        // Assert
        let album: Album? = getEntities().first
        XCTAssertNotNil(album?.user)
        XCTAssertEqual(album?.user?.id, Int64(userId))
        XCTAssertNil(album?.user?.name, "This should be a stub user")
    }


    // MARK: - Photo

    func testCanAddPhoto() {
        // Arrange
        let photoDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Photo.albumId: 1,
            ApiConstants.Key.Common.identifier: 1,
            ApiConstants.Key.Photo.title: "accusamus beatae ad facilis cum similique qui sunt",
            ApiConstants.Key.Photo.url: "http://placehold.it/600/92c952",
            ApiConstants.Key.Photo.thumbnailUrl: "http://placehold.it/150/92c952"
        ]

        // Act
        service.addPhotos(from: [photoDetails])

        // Assert
        let photo: Photo? = getEntities().first
        XCTAssertNotNil(photo)
    }

    func testCanAddTwoPhoto() {
        // Arrange
        let photoDetails: Array<Dictionary<String, Any>> = [
            [
                ApiConstants.Key.Photo.albumId: 1,
                ApiConstants.Key.Common.identifier: 1,
                ApiConstants.Key.Photo.title: "accusamus beatae ad facilis cum similique qui sunt",
                ApiConstants.Key.Photo.url: "http://placehold.it/600/92c952",
                ApiConstants.Key.Photo.thumbnailUrl: "http://placehold.it/150/92c952"
            ],
            [
                ApiConstants.Key.Photo.albumId: 1,
                ApiConstants.Key.Common.identifier: 2,
                ApiConstants.Key.Photo.title: "reprehenderit est deserunt velit ipsam",
                ApiConstants.Key.Photo.url: "http://placehold.it/600/771796",
                ApiConstants.Key.Photo.thumbnailUrl: "http://placehold.it/150/771796"
            ]
        ]

        // Act
        service.addPhotos(from: photoDetails)

        // Assert
        let photos: [Photo]? = getEntities()
        XCTAssertTrue(photos?.count == 2)
    }

    func testAddedPhotoHasDetailsSet() {
        // Arrange
        let id = 1
        let title = "accusamus beatae ad facilis cum similique qui sunt"
        let url = "http://placehold.it/600/92c952"
        let thumbnailUrl = "http://placehold.it/150/92c952"

        let photoDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Common.identifier: id,
            ApiConstants.Key.Photo.title: title,
            ApiConstants.Key.Photo.url: url,
            ApiConstants.Key.Photo.thumbnailUrl: thumbnailUrl
        ]
        
        // Act
        service.addPhotos(from: [photoDetails])
        
        // Assert
        let photo: Photo? = getEntities().first
        XCTAssertEqual(photo?.id, Int64(id))
        XCTAssertEqual(photo?.title, title)
        XCTAssertEqual(photo?.url, url)
        XCTAssertEqual(photo?.thumbnailUrl, thumbnailUrl)
    }

    func testAlbumGetsCreatedForPhoto() { // When adding a photo where the Album with albumId isn't created yet, a stub Album should be created
        // Arrange
        let id = 1
        let albumId = 1
        let title = "accusamus beatae ad facilis cum similique qui sunt"
        let url = "http://placehold.it/600/92c952"
        let thumbnailUrl = "http://placehold.it/150/92c952"

        let photoDetails: Dictionary<String, Any> = [
            ApiConstants.Key.Common.identifier: id,
            ApiConstants.Key.Photo.albumId : albumId,
            ApiConstants.Key.Photo.title: title,
            ApiConstants.Key.Photo.url: url,
            ApiConstants.Key.Photo.thumbnailUrl: thumbnailUrl
        ]

        // Act
        service.addPhotos(from: [photoDetails])

        // Assert
        let photo: Photo? = getEntities().first
        XCTAssertNotNil(photo?.album)
        XCTAssertEqual(photo?.album?.id, Int64(albumId))
        XCTAssertNil(photo?.album?.title, "This should be a stub Album")
    }


    // MARK: - Helpers

    func getEntities<T: NSFetchRequestResult>() -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        guard let result = try? container.viewContext.fetch(request) else {
            return []
        }

        return result
    }
}
