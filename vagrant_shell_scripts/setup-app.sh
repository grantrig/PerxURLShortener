cd /perx_shortener_app
bundle install
bin/rake db:create
bin/rake db:migrate

cd /perx_shortener_samples
bundle install
