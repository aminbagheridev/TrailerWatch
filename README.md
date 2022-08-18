
![Logo](https://github.com/bagheriamin/TrailerWatch/blob/main/TRAILER.png?raw=true)


# TrailerWatch

An app perfect for all movie lovers around the globe, allowing you to watch trailers for any movie your heart desires.
## Technologies Used

**Tech Stack:** 
UIKIT, CoreData, REST API, Webkit

**Architecture:**
MVVM

**Swift:** WKWebView, Programmatic UI (no storyboards), Image Caching, Protocol+Delegate Pattern, URL Session, Codable, JSON Parsing, Async / Sync Programming

**UIKIT:**
UICollectionView, UITableView, UINavigationViewController, UITabBarController

## TrailerWatch Demo
![Alt Text](https://github.com/bagheriamin/TrailerWatch/blob/main/Simulator%20Screen%20Recording%20-%20iPhone%2011%20-%202022-08-17%20at%2020.51.56.gif?raw=true)



## Movie API Reference

#### Example of getting trending movies info: images, title, description etc

```http
  GET https://api.themoviedb.org/3/trending/movie/day?api_key=[api_key]
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `api_key` | `string` | **Required**. The API key |

There are other API endpoints that you can hit, such as Top Rated movies or Upcoming as well. Check out https://api.themoviedb.org for the full list.

#### Searching for specific movie information:

```http
  GET https://api.themoviedb.org/3/search/movie?api_key=[api_key]&query=\(query)"
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `api_key` | `string` | **Required**. The API key |
| `query` | `string` | **Required**. The movie title |


#### The object model for returned movies
![alt text](https://github.com/bagheriamin/TrailerWatch/blob/main/carbon-10.png?raw=true)

## Searching for movie trailer on the YouTube API:

```http
  GET https://youtube.googleapis.com/youtube/v3/search?q=\[query]&key=[api_key]
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `api_key` | `string` | **Required**. The API key |
| `query` | `string` | **Required**. The movie title |

#### Returned JSON from YoutubeAPI
```
items = (
            {
        etag = "ZL83K-82x1HtSMVou_zqaRTo5aU";
        id =             {
            kind = "youtube#video";
            videoId = "z4K2F_OALPQ";
        };
        kind = "youtube#searchResult";
    }
)
```

#### Youtube API Object Model
![](https://github.com/bagheriamin/TrailerWatch/blob/main/carbon-11.png?raw=true)


## Implementing Search Feature

To implement the search feature, I opted to use a UISearchController and UISearchViewController setup, as it allows for the greatest funcionality when it comes to search functionality. 

For example, with a SearchViewController, I can present a whole different view, rather than just refiltering with a regular SearchBar, as shown:

![](https://github.com/bagheriamin/TrailerWatch/blob/main/Simulator%20Screen%20Recording%20-%20iPhone%2011%20-%202022-08-17%20at%2021.57.53.gif?raw=true)

To prevent API overload / to protect the API from getting too many requests, I prevented any searches from being made if the search bar was empty or if there was less than 3 characters of text, as shown. This is very important for lowering API Quota costs, especially in real production applications.

![](https://github.com/bagheriamin/TrailerWatch/blob/main/carbon-12.png?raw=true)

## Implementing Video Feature

Implementingthe video feature is very simple, as Apple has made playing videos extremely simple. Once I do a YouTube API GET Request from the search text entered by a user, I put together the pieces of the API Model and construct a youtube video embed url, as seen:

![](https://github.com/bagheriamin/TrailerWatch/blob/main/carbon-13.png?raw=true)


Then, I simply use that url to load the YouTube video in the WKWebView(), as shown:

![](https://github.com/bagheriamin/TrailerWatch/blob/main/carbon-14.png?raw=true)

## Implementing Movie Save Feature

The final feature I would like to talk about is the 'save' feature. While the app doesn't support the actual downloading of videos, it *does* support the ability to save titles to the device, so that we can easily access them and watch trailers as we wish. 

I used **Core Data** to make this happen, and it was surprisingly simple to implement within the already existing codebase.

**Core Data Step One**

First, I created the *managed object model*, which maps directly to my previous Model for Trending Titles:
![](https://github.com/bagheriamin/TrailerWatch/blob/main/Screen%20Shot%202022-08-17%20at%2010.21.28%20PM.png?raw=true)


**Core Data Step Two**

I then added the Core Data App Delegate required methods, which would have been added automatically had I began the application with Core Data in mind, but since I hadn't, I had to add the methods manually.

**Core Data Step Three**

Now I had to setup my Core Data Manager class, where I would host all of the methods that would allow for easy access to the Persistent Container wherever I needed it.

The three methods I added were simple. The first allows me to save objects to Core Data, the C in CRUD. The second, allows me to retrieve a list of objects from core data, the R in CRUD. The final allows me to delete objects, the D in CRUD. Updating is not necassary as the movies are not user made objects and have fixed data.



## Installation

Download the project via Code > Download as ZIP

If the SDWebImage package has not downloaded properly, here is the link to install it in the Swift Package Manager as a third-party dependency:
https://github.com/SDWebImage/SDWebImage.git
