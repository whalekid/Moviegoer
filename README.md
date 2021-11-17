# Moviegoer
An iOS demo app that finds movies in [The Movie Database API](https://developers.themoviedb.org/3/getting-started/introduction). 

![intro](https://media.giphy.com/media/ZK290Yq0v3UduWM75t/giphy.gif) ![CoreData](https://media.giphy.com/media/Ra5qt5UPoGM9zixQAa/giphy.gif)
## Features
- [X] The user can find specific movies by entering their query in the search field.
- [X] If the request is incorrect, the user will be notified with an alert.
- [X] Pagination is included, the application supports infinite scrolling.
- [X] The first 20 movies of the last request are automatically saved using CoreData
- [X] The next time the application is launched, these movies will be visible to the user.
- [X] UI was created programmatically using  Snapkit without using storyboards.
- [X] User can view movie details by tapping on a cell.
- [X] Detail controller contains all the info and full overview of certain movie.

## Description

This app has an MVC with a VIewModel architecture with two screens. UI is made with Snapkit without storyboards. The Main search screen allows the user to enter movie keywords and begin a search, it also shows the results. By scrolling down user can see all the films using pagination. Tapping on a cell of result will transition to a Detail screen to show some more information for the chosen movie. 

### User Interface:
* `MainViewController`: uses a `MainView` property to present results, can show an alert to show errors. Implements UITableViewDelegate and UITableViewDataSource protocols.
* `MainView`: uses a table view, register a `MovieCell` as a TableViewCell. Also has an activityIndicatorView.
* `MovieCell`:` a custom table view cell used to show a movie in the main view controller. Contains a title, a movie realise year, beginning of an overview and a poster. Also implements a setup for constraints via Snapkit.
* `DetailViewController`: uses a `MainView` property to present movie details, including a full overview.
* `DetailView`: uses a  UIView used to show a movie in the `DetailViewController`. Contains a title, a movie realise year, full overview and a poster. Also implements a setup for constraints via Snapkit.

### Models:
* `Movie`: Decodable struct that represents summary information about a movie. Also has a private enum CodingKeys.
* `MoviesData`: Decodable struct which contains an array of `Movie` entities. Also has a private enum CodingKeys.

### ViewModel:
Contains actual array of `Movie` models, interacts with `MainViewController`, tells the data source to return the number of rows as a length of movies' array, provides the setting of cells with movies' data, passes the chosen movie to `DetailViewController`.  Also implements interaction between controllers and networking. Contains `NetworkDataFetcher` and  `CoreDataProvider` instances. 


### Networking:
* `NetworkService`: implements URLSession datatasks for movies and their posters. Passes the results of dataTask in completion blocks to `NetworkDataFetcher`.
* `NetworkDataFetcher`: fetches the data that is passed by `NetworkService` with JSONDecoder and passes the results of data fetching in completion block to `ViewModel`.
* `URLBuilder`: builds the url with path and queryItems. Contains apiKey constant.

### CoreDataModules
* `CoreDataStack`: a singleton which has a persistent container property, implements saving context.
* `CoreDataProvider`: makes all the Core Data work: saves 20 first movies from the last user search, updates context via `CoreDataStack` singleton, sets the array of last searched movies when an app launches next time.

## Future Development.

- Unit tests would help to provide stability for an app perfomance.
- CoreData should't contain BLOBs which are our posters, even if we store only 20 or less posters. So in the future i should store BLOBs with a proper way like to store them as resources on the file system and to maintain links.
- It could be good to allow the user to save favourite movies. 

