# Scenario #
You need to implement an app that:
- Allows user to search for city on a search bar and display weather of the selected city
- Display list of previously view city

## Plan 30 Sep 2019 ##

### Consideration: ###
Since there is  no mention of persistence store preference, I intend to use the basic user defaults


### Personal Objectives: ###
- [ ] Experiment with Integration test with plain ol' XCUITest
- [ ] Implement throttling without RxSwift

### Use Case 1. ###

As a user

Given I am on the home screen

When I type in to the search bar on the home page

- [x] Then I will see a list of available cities that pattern matches what I have typed

### Use Case 2. ###

As a user

Given I am on the home screen

And there is a list of available cities (based on what I've typed)
 
When I tap on a city

- [x] Then I will be on the city Screen

- [x] Then I will see the current weather image

- [x] Then I will see the current humidity

- [x] Then I will see the current weather in text form

- [x] Then I will see the current weather temperature

### Use Case 3. ###

As a user

Given I am on the home screen

And I have not viewed a City's weather

- [ ]  Then I should see a list view empty state

### Use Case 4. ###

As a user

Given I am on the home screen

And I have previously viewed any city's weather

- [ ] Then I should see a ordered list of the recent 10 cities that I have previously seen.

And I should see the latest City that I have viewed at the top of the list
 

### Use Case 5. ###

As a user

Given I have previously viewed any city's weather

When I have relaunched the app (terminating the app and relaunched)

- [ ] Then I should see a ordered list of the recent 10 cities that I have previously seen.

## TODO ##
Handle error cases for search api
- [ ] handle network failure when fetching cities
- [ ] handle no result found failure
- [ ] handle network failure when fetching weather
## Retrospective 2 Oct 2019 ##
