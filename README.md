# Scenario #
You need to implement an app that:
- Reads JSON from a publicly available REST API endpoint
- Parses it and shows the contents in a table view or collection view
- Tapping on a table or collection view item shows a detailed view of that item
- Persists the contents of the JSON data locally, so if the app is used without an
Internet connection, it will show previously downloaded content. If there is no internet
and no previously available data, please display an error in a user friendly way.
- Compiles and runs using the latest App Store version of Xcode.
- Written in Swift only

What we don’t want to see:
- Overengineering your code
- Massive view controller
- Lack of unit testing
- Over-reliance on third party libraries
- Persisting data in UserDefaults

Initial Research
- Based on the API suggested, the simplest way to  illustrate this is to build a simple news reader app. The master list shall display list of story titles, and the detail page can then display the body of the message. We can consider displaying the posts if time permits.

## Plan 26 Sep 2019 ##

### Consideration: ###
As I'm a believer of a repository pattern, and I'm not a adept CoreData developer, I'd continue using the repository pattern despite the fact that it negates the advantages of CoreData as an object graph.

### Personal Objectives: ###
- []Experiment with Integration test with plain ol' XCUITest
- []Replace Alamofire with URLSessionn if time permits

#### Phase 1: Basic app: upon launching, fetch all posts and populate screen ####

Master Scene
- [x] upon launch, call dataProvider
    - if dataProvider returns empty array from network
      - [x] present placeholder label
    - else
      - [x] update master list of posts
- [x] upon tapping pass post object to detail scene

Detail Scene
- [x] populate story

DataProvider
  - [x] expose function for view models to call to fetch data
  - [x] build network requests
    - [x] Call network NetworkClient
      - [x] if network succeed then parse response

NetworkClient - Alamofire
  - [x] Call GetPost API
  
- [x] Create POSO Post Object
- [x] Create POSO Post Translator Object

#### Phase 2: Store posts upon successful request ####
DataProvider
- [ ] given network call is successful, invoke localStorageProvider to save object

LocalStorageProvider
- [ ] given POSO Post Object, insert CoreDataObjects into DB

#### Phase 3: Display posts from stored posts  ####
DataProvider
    - [ ] given network call is unsuccessful, invoke localStorageProvider to retrieve object

LocalStorageProvider
    - [ ] retrieve core data object
    - [ ] convert core data object to POSO object

Master Scene (without network)
  - upon launch, call dataProvider
  - if dataProvider returns empty array from local storage
    - [ ] present placeholder label
  - else
    - [ ] update master list of posts

## Retrospective 27 Sep 2019 ##
