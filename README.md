# Perx URL Shortener Development Envirnment


## Introduction

This project uses Vagrant to set up a virtual machine development/test enviroment that installs all required packages/software.   Using vagrant is not required, but it ensures that the system settings (like mysql user/pass) replicate the project development settings perfectly.  This way the development enviroment is tied to the project rather than the computer.

If you are not familier with Vagrant you can still run the app normally.  I can also come to your office to show you how everything works and explain the design and functionality.

## Where to Start

* Follow the instructions below to setup the development environment.
* Read [perx_shortener_app/DEVNOTES.md](perx_shortener_app/DEVNOTES.md) for the developer notes.  **Read them from bottom to top.**
* Read the controller specs [perx_shortener_app/spec/controllers/](perx_shortener_app/spec/controllers/) since they show how the system works best.

## Setting Up Virtual Machine for Tests & Development

### Requirements

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant](http://vagrantup.com)

Install both VirtualBox and Vagrant.

### How To Build The Virtual Machine

Building the virtual machine is this easy:

```bash
git clone https://github.com/grantrig/PerxURLShortener.git
cd PerxURLShortener
vagrant up;vagrant ssh
```

## Creating the db and running the migrations

*You do not need to do this if using vagrant as vagrant will automatically do the migrations*

### Start the vagrant machine and ssh connect to it
```bash
cd PerxURLShortener
vagrant up;vagrant ssh
```

### Once connected to the machine, run the db rake tasks
```bash
cd /perx_shortener_app
bundle install
bin/rake db:create
bin/rake db:migrate
bin/rake db:create RAILS_ENV=test
bin/rake db:migrate RAILS_ENV=test
```

## Running the tests

### Start the vagrant machine and ssh connect to it
```bash
cd PerxURLShortener
vagrant up;vagrant ssh
```

### Once connected to the machine, run the tests
```bash
cd /perx_shortener_app

# Runs all tests
rake

# Run cucumber tests only
cucumber

# Run rspec tests only
rspec
```

## How the API Works

The API uses signed requests for credential verification.  This protects unauthorized access to the url logs.

### Simple Samples

The samples are available at [perx_shortener_samples/](perx_shortener_samples/).

#### Running the samples

First generate the api credentials

In your vagrant ssh session
```bash
cd /perx_shortener_app
rails s
```
Leave the rails server running

Then on your computer 

1. visit http://localhost:3036/
2. Enter your name for the credentials & click Get Credentials
3. Copy the api_key and api_secret and put them in [perx_shortener_samples/api_keys.rb](perx_shortener_samples/api_keys.rb)
4. Run ```vagrant ssh``` in the git directory to launch another vagrant ssh session

##### Create a shortened url

```bash
cd /perx_shortener_samples
bundle install
ruby api_create_shortened_url.rb
```

That will give you a shortened url you can visit.

```bash
ruby api_list_shortened_urls.rb
```

Will give you a list of shortened urls on your api credential

To see the hits, you will need to change the short_code variable to match your url in api_get_hits.rb.  Then.

```bash
ruby api_get_hits.rb
```
Which will show you the hits for that url.
