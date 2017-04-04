cd /perx_shortener_app
bundle install
bin/rake db:create
bin/rake db:migrate
bin/rake db:create RAILS_ENV=test
bin/rake db:migrate RAILS_ENV=test

cd /perx_shortener_samples
bundle install
