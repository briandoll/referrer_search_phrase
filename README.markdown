referrer_search_phrase
======================

A common theme online:
 - A user goes to their favorite search engine and search for something fun
 - That search engine happens to provide a link to your site, which the user happily clicks on
 - The user is now on your site, after having searched for something fun.  Awesome.
 
If you've ever wanted to do something with that original search phrase within your app, this library makes it easy to get at it.

<code>
# A simple google example:
ReferrerSearchPhrase.get("http://www.google.com/search?hl=en&source=hp&q=foo+bar&aq=f&oq=&aqi=g8g-s1g1")
=> "foo bar"

# Not a search engine:
ReferrerSearchPhrase.get("http://www.somethingrandom.com/search?foo+bar")
=> nil
</code>