= Developer Notes =

This file will contain my thoughts while I develop the application. Older entries are at the bottom.

== Tuesday, 4th April ==

=== JSON API Format ===

==== Shortened URL Show ====

```GET /s/:short_code```
===== Query =====
{json_data: {api_key: '', utc_time_in_seconds: 0, short_code: '', since_utc_seconds: 0, until_utc_seconds: 0}, verification_hash: ''}

===== Result =====
{hits: [{ip_address: '', utc_seconds: 0, operating_system: '', operating_system_version: '', browser_type: '', browser_version: '', device: '', accept_language: '', user_agent: '', url: '', referer: ''},{}...]}, query: {short_code: '',since_utc_seconds: 0, until_utc_seconds: 0}

==== API Credential Show ====

```GET /api_credentials/:api_key```
===== Query =====
{json_data: {api_key: '', utc_time_in_seconds: 0}, verification_hash: ''}

===== Result =====
{json_data: {api_key: '', shortened_urls: [{short_code: '', url: '', created_at_utc_seconds: 0},{}...]}}



== Sunday, 2nd April ==

=== Hit Logging Data Considerations ===

I will be using a user-agent parser to store extra information about each hit the shortened urls have.  The main questions is how much to normalize the browser data.  There are two options.

* Store the information in the hit table as strings (operating system, os version, browser type, browser version, device)
* Normalize the data and just reference them via belongs to.  belongs_to :operating_system_version, belongs_to :browser_version (operating system version would have os name and version)
* Where there is a table named operating_system_version which has operating_system_type_id and version.

Fourth Normal form would give us the most space saving and has the highest querying performance.  It also has the most clarity of design if other developers need to work on the code  But has the cost of additional queries for each hit.  If performance becomes a problem, we could cache the tables for faster querying.  I will go with 4NF since this design is not aiming for high performance at the start.  Need to make sure it's easy to refactor if we need to switch to a different form. If the service is expected to handle a large number of hits then First Normal Form would most likely be optimal.

=== Hit & Related Tables Design ===

I'm planning on implementing a change url feature, so we will need to store what url it was redirected to rather than just shortened_url_id

* Shortened Url Hit
  * shortened_url_id
  * url
  * operating_system_version_id
  * browser_version_id
  * device_id
  * ip_address
  * accept_language
  * user_agent
  * referer
  
* Operating System Version
  * operating_system_id
  * name

* Operating System
  * name

* Browser Version
  * browser_id
  * name

* Browser
  * name

* Device
  * name


=== Change to Hash Signature ===

After doing a bit of research on api authentication it seems like MD5 is not a good choice for the hash signature to verify the api secret.  The authentication I'm using is https://en.wikipedia.org/wiki/Hash-based_message_authentication_code which is vulnerable to a length extension attack (https://en.wikipedia.org/wiki/Length_extension_attack).  This shouldn't cause any problems as the api authentication is not that important for this service.  However, I can defend against it by using a slightly different hash signature.  Instead of md5(secret + data) which is vulnerable, I can use md5(secret + md5(secret + data)).  I could switch to SHA-3 instead of MD5 but that doesn't have great support in ruby and other languages.

== Saturday, 1st April ==

=== Home Page Form Object Creation ===

The home page is normally displayed from dashboards#home.  The home method creates 2 objects for the forms @api_credential and @shortened_url.  Since api_credential#create and shortened_url#create both will need to display the home page again if form validation fails I need to have a way to create the other object easily.  I've decided to make a simple module which has a function render_dashboard_home.  That method will create each object if it doesnt exist and then call render to display dashboards#home.  That way all the controller methods can use that function to set things up.  It seems like there should be a more standard way of handling this but I have not found any. I decided to use a module rather than adding the function on ApplicationController so that it's clear what is happening since it requires an include statement.

=== Detailed API Request Format ===

==== Shorten URL (shortened_url put) ====

The json_data will be a json encoded hash.  The verification_hash is a MD5 hash of json_data + api_secret (both strings).
````
{
  json_data: {
    url: "http://www.google.com",
    api_key: "898h89hh9",
    utc_time_in_seconds: 1491023893
  },
  verification_hash: "0cbc6611f5540bd0809a388dc95a615b"
}
````

== Friday, 31st March ==

=== API Request Authorization ===

I'm making a simple secure authorization system which uses a secret key that is added to the data to gen an MD5 hash.  That way the system can check if the request is valid.  The data (post or get) for an api request will have the following fields:

```{json_data: "(data in json format...url, api_key, utc_unix_time, etc)", verification_hash: "a hash of the json_data string + the api_secret"}```

The API Secret is never transmitted in the API Request.  The utc_unix_time is passed so that the request stops working after 10 minutes to make it not be possible to resubmit at a later time and spam the server.


=== Validations Testing ===

Unable to validate using rspec for uniqueness on shortened_url.  Read shortened_url_spec.rb for info.

=== Rubocop ===

I use rubocop for all of my code to ensure I'm following the ruby style guide.  bin/rubocop_auto is a shell script I made which runs rubocop on any files that you change.  It uses MD5 to check for changes.  Vagrant shared file systems do not support linux inotifywait on file change events, this is due to virtual box shared folders, so I have to use MD5 to check for changes.  To use it just pass the filenames like this:

```bin/rubocop_auto app/models/shortened_url.rb spec/models/shortened_url_spec.rb```

Filename globbing (*) also works.


=== Testing Model with RSpec ===

I'm not used to testing the model using rspec.  I'm not sure how to do a proper test of the short code getting set when create.  I'll just test that it gets set on create.

=== Short Code Generation ===

I'm tempted to write code so I can do something like 6.random_letters.  However, I need to have a limited char set rather than all letters so I cannot make an extension.  Anyways it's best not to make extensions that aren't very important.  I'll just code a function on the model class to generate the sequence.  I'm splitting up the functions into one that makes a random code and one that checks if it is unique or not.  This way it's more understandable and DRY.

=== Development Plan/Order/Tasks ===

# Create models

# Write rspec tests for shortened_url model (get new short code)

# Write rspec tests for api authentication

# Plan api format/functions

# Write cucumber tests for frontend (create api, shorten url)

# Write tests rspec for api actions (create shortened url, update shortened url, get log shortened url, get stats shortened url)

# Setup basic gem

# Write tests for gem (rspec)

# TDD for tests in order



== Thursday, 30th March ==

=== Testing ===

I normally use cucumber as my main testing tool and do all testing as behavior from the users perspective. Since this app is meant to have an api and I'll be testing it thoroughly I'll use rspec.

=== Project Notes ===

I normally focus on what the end users (the client) is using the app for in order to make my decisions.  It's very important that I consider the project from the end-users point of view rather than my own.  In this case I'm writing the program based on the following assumptions:

* The api will require api keys which are available through the frontend.

* The web frontend will only have 2 functions: generate api key and shorten url.

* The shortened URLs may be used for printed advertising where people might need to type the shortened url, so it's important to ensure the letters are clear (don't use i's or l's)

* At this stage performance with a high load is not a concern.  Although that is the case for now, the system should still be easy to refactor for better throughput/speed.

* A limit of 19,000,000 possible urls is acceptable.  Although this should be able to be raised without causing issues.

* Users will only be able to get the url stats using the API, not through the frontend.



=== Table Design ===

==== Primary Key on Shortened URL Table ====
The short code will be a varchar field rather than the primary key.  
* Performance issues (longer reads, joins, etc)
* Cannot use a CHAR field (due to needing longer lengths in the future)
* Storage size for the table tracking hits (the record that is used to track hits will need to store it instead of an int/bigint column)


==== Using Table to Store Hits ====

The main reason for storing hits in a db table is for ease of querying. Once performance needs to be improved this would be a key area of focus due to each "hit" adding an entry in the table.  Also, I don't have much experience with non relational db storage of info so at this stage I'm sticking with a mysql table.
