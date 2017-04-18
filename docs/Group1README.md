# Group1README.md

## Implementation Contributions  
- Justin Chao: 33%     
    * Implemented background changing functionality in Settings view.
    * Implemented changing time format functionality in Settings view.
    * Resolved bugs and fixes in Trip and Itinerary views.
    * Improved on UI experience for Login, Registration, Password Reset, and Itinerary views.
    * Learned and implemented Alamofire for use in Yelp and Google APIs and HTTP requests.
    * Added MapKit to Event Details view and implemented location finding service based on provided
      event location.
    * Added event reminder notification functionality through Event Details view.
    * Added Flights views and began implementing Google QPX Express API for obtaining flights data.


- Julianne Crea: 33% 
    * Created the 3 view controllers in the places storyboard, did UI Elements and constraints for all 3. 
    * Implemented pull places capability to search for attractions near a user-provided location, with a minimum rating (also user-provided). These came from the Yelp Fusion API
    * Function to populate images from a URL returned from Yelp Fusion API


- Connie Liu: 33% 
    * Implemented pull food capability to search for food near a specific address or near user's current location.
    

## Grading Level   
- Same grade for all members  


## Differences  
    * Food and Place features do not yet show information for price or open hours of a business because the YelpAPI Cocoapod used does not have this capability. A newer and more complete method will be implemented in the final release via Alamofire and Yelp Fusion to grab this data.
    * Food and Place features cannot filter searches by price or open now for same reasons listed above.


## Special Instructions   
- requires CocoaPods version 1.0.0 or later
- requires Xcode 7.0 or later (building with XCode 8.3.1 may result in Firebase
  compile warnings, but will not cause SIGABRT)
- requires iOS 7 or later
