# MartiniFinder
This app searches for bars and restaurants that serve martinis near the user's location.

## Build
This app was written in Swift 4.0 in XCode 9.2 with an iOS 11.1 deployment target. To build, download the project as a zip file and open in XCode or clone this repo from GitHub.

## About the API
MartiniFinder uses Yelp's search and business APIs. You can find the documentation for these APIs at Yelp Fusion on Github [here](https://www.yelp.com/developers/documentation/v3/business_search).

Yelp's API places certain restrictions on its use by third parties. Relevant restrictions on the design of this app include, but are not limited to:

* Cache, record, pre-fetch, or otherwise store any portion of the Yelp Content for a period longer than twenty-four (24) hours. The implementation of Core Data in this app allows saving your favorite locations. This feature will be removed when deployed to the App Store to ensure adherence to Yelp's API regulations.

* Selecting specific reviews, e.g. those mentioning the term "martini". Yelp will only allow querying up to three reviews, and only in Yelp's default search order. You can read more about that [here](https://www.yelp-support.com/article/How-is-the-order-of-reviews-determined?). Since it is not possible to cherry pick martini reviews, it's entirely possible you may visit an establishment with a high rating that nevertheless makes terrible martinis. Our apologies.

* Yelp publishes a style guideline and requires its use when displaying star ratings. MartiniFinder complies with these guidelines, which you can read more about [here](https://www.yelp.com/developers/display_requirements). 

**Note:** Ratings are for the establishment as a whole, not specifically martinis. If Yelp's API usage restrictions allow this in the future, we may update the app.

Enjoy your martinis!




