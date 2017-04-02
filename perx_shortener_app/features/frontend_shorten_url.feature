Feature: Visitors can generate a shortened url.

Scenario: Visitor generates a shortened url
  Given I am on the home page
  When I fill in "Url" with "http://www.google.com"
  And I click the button "Shorten"
  Then I should see "Shortened URL:"

Scenario: Visitor does not fill in the url and then sees a form error
  Given I am on the home page
  And I click the button "Shorten"
  Then the "Url" field should have an error

Scenario: Visitor fills in invalid does not fill in the url and then sees a form error
  Given I am on the home page
  When I fill in "Url" with "www.google.com"
  And I click the button "Shorten"
  Then the "Url" field should have an error


Scenario: Visitor generates a shortened url and tests it
  Given I am on the home page
  When I fill in "Url" with "http://www.google.com"
  And I click the button "Shorten"
  Then I should see "Shortened URL:"
  When I visit the shortened url from the "shortened_url" input
  Then I should be at the url "http://www.google.com"
