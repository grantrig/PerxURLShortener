RSpec::Matchers.define :have_header do |header_name, expected|
  match do |response|
    # Use transform keys so that "Location" becomes :location, for easier_access.
    response.headers.transform_keys{|key| key.to_s.downcase}.with_indifferent_access[header_name.to_s.downcase.to_sym] == expected
  end
end
