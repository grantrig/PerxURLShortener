= Developer Notes =

This file will contain my thoughts while I develop the application. Older entries are at the bottom.

== Friday, 31st March ==


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