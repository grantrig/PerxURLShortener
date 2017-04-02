Feature: Visitors can request api credentials

Scenario: Visitor fills the form correctly and gets api credentials
  Given I am on the home page
  And I fill in "Name" with "Test API"
  When I click on "Get Credentials"
  Then there should be the css element "table.api_credentials"

Scenario: Visitor forgets the name when filling the form
  Given I am on the home page
  When I click on "Get Credentials"
  Then the "Name" field should have an error


