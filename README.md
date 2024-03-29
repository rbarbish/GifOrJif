# GifOrJif

This app uses the Unsplash API to display images (https://unsplash.com/developers). This API has a 50 request limit per hour.

The app utilizes "keyword search" which calls the corresponding Unsplash API endpoint for a user-input search term. When you launch the app, you will see the search bar defaulted to "Ramen", because Ramen is so very 美味しい.

When you type into the search bar, a 1.5 second delay timer is used before we call the API to search for new results. You will notice how there isn't a Search Button, this is intentional to minimize user interaction, the results will just appear when they finish typing. I have also implemented very basic pagination, which fetches new results when it reaches the bottom of the list and appends the next page's results.

The app also implements the following open source and third party frameworks:
1. RevealingSplashView - You will notice how the launch image appears to animate and fade out revealing the main screen. This is similar to the Twitter iOS intro animation. I think it is a slick animation, most popular apps use this intro animations (AirBnb, Uber, Twitter). I think it is always good to have a good first impression, even if it is somewhat meaningless.
2. Kingfisher - This is framework that allows the caching and asynchrous loading of image URL links. It works seemlessly with UIImageViews. This is what I use in each UITableViewCell for loading the images. The end result is that the ramen images will show immediately upon second load (and any image urls that have been viewed previously).
3. SimpleImageViewer - This is a full-screen photoviewer of images. When you tap an image in the list, it will go full screen. You can then flick/drag to dismiss the image, and it will animate very nicely to where it is in the list. 
4. MBProgressHUD - This is a modal loading spinner that displays while fetching results. I would probably change this to be something less intrusive / more subtle in a production app, like a UIActivityIndicator at the bottom of the list while fetching.

One more feature:
If you click a user's instagram handle (these are real users), the app will open Instagram to their profile (if Instagram is installed on your device).

![alt text](https://image.ibb.co/gAjZPf/IMG-2589.png "Screenshot")