Given(/^I am on the home page$/) do
  visit root_path
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

When(/^I click the button "([^"]*)"$/) do |name|
  click_button name
end

Then(/^I should see "([^"]*)"$/) do |text|
  puts page.text unless page.has_content?(text)
  expect(page.has_content?(text)).to eq(true)
end

Then(/^I should be at the url "([^"]*)"$/) do |url|
  # URI.parse is used to compare between url's that are the same but might match the string.  Like http://www.google.com vs http://www.google.com/
  expect(URI.parse(current_url)).to eq(URI.parse(url))
end

When(/^I visit the shortened url from the "([^"]*)" input$/) do |field_selector|
  shortened_url = find_field(field_selector).value
  visit shortened_url
end

When(/^I click on "([^"]*)"$/) do |name|
  click_on name
end

Then(/^there should be the css element "([^"]*)"$/) do |selector|
  expect(page).to have_css(selector)
end

Then(/^there should be an error for the form stating "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end


Then /^the "([^\"]*)" field should( not)? have an error$/ do |field, negate|
  expectation = negate ? :should_not : :should
  if negate
    expect(page).to not_have_css('.has-error', :text => field)
  else
    expect(page).to have_css('.has-error', :text => field)
  end

end
