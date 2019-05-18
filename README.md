# Scenario #
Build a simple master-detail application listing people in your Pipedrive account (using the /persons endpoint)

- perform the http requests, map the received structure to model objects;
- optionally persist model objects locally and use them when you can't fetch data from the API;
- display people one person per row, use names as titles;
- tapping on a person should open the detail view, which has an avatar (use Gravatar as a source) and a few additional attributes of your own choosing;
- bonus points for adding paginated fetching.

Initial Research
- Gravatar API: https://www.gravatar.com/avatar/{md5 hash of lowercase email }?s=200&r=pg eg: b5f6c2a999a22d0204532a6ede7ba92d
    - potential solution: https://stackoverflow.com/a/32166735

## Plan 9 May 2019 ##
Since Pipedrive follows MVVM-C architecture, this project can be written in similar ways too.

### Consideration: ###
Based on the nature of the theory questions, it is possible that the application built will be stressed test under an account with a lot of contacts.
Using a function (which I don't understand) to create md5 hash seems insecure and scary, but in the interest of time, it might be the best choice.

### Personal Objectives: ###
TDD with plain XCTests
Experiment with SwiftGen (if time permits) to explore localisation

### Initial Design: ###

#### Phase 1: Basic app: upon launching, fetch all contacts and populate screen, use userDefaults to store response as JSON and images as NSData ####

Master Scene
  - upon launch, call dataProvider [x ]
    - if dataProvider returns empty array from network
      - present placeholder label [x ]
    - elseif dataProvider returns empty array from local
      - present placeholder label [x ]
    - else
      - update master contact list [x ]
  - upon tapping [x ]
    - pass contact object to detail scene [x ]

Detail Scene
  - populate labels [ x]
  - upon loading: call dataProvider for avatar [ ]
    - update image when ready [ ]

DataProvider
  - expose 2 functions for view models to call to fetch data [ x]
  - build network requests [x ]
    - Call network NetworkClient [ x]
      - if network succeed [ x]
        - parse response [x ]
        - store response [ x ]
      - else return local data [ x ]

NetworkClient - Alamofire
  - Call ContactList API [ x]
  - Call Gravatar API [ ]
  
Create POSO Person Object [x ]
Create POSO Person Translator Object [x ]
Create POSO Image Object [ ]
Create POSO Image Translator Object [ ]

#### Phase 2: Implement Pagination UI ####
Master Scene
  - when user reach bottom of page and pull-to-fetch
    - call data provider [ ]
DataProvider
  - modify method to build network request [ ]
  - whenever a new page of contact list is saved locally, delete all stored images [ ]

#### Phase 3: Implement more UI Feedback ####
DataProvider
  - when returning stored objects, notify caller [ ]

Master Scene & Detail Scene
  - present loading indicators when making request to data provider [ ]
  - remove loading indicators when data provider returns something [ ]
  - when stored objects are returned, display banner [ ] https://github.com/Daltron/NotificationBanner
  - else, remove banner if it was data from network [ ]
  
  possibly explore: https://github.com/ashleymills/Reachability.swift

#### Phase 4: Implement CoreData ObjectModels ####
DataManager
  - create date models and relationships [ ]
  - transform CoreData Objects to POSO and vice versa [ ]
  - expose API to store CoreData Objects when receiving POSO [ ]
  - expose API to fetch CoreData Object [ ]
  - delete associated image object when user is deleted [ ]
