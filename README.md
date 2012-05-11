#Import time entries to mite. from CSV file.

##Usage

##Execute Importer

* `ruby importer.rb`

##Development Environment

Setup according to `README` of project [vagrant-puppet-template][vagrant-puppet-template].

[Ruby][ruby] application managed using [Bundler][gembundler]:

So, first `ssh` into your vagrant box:
    
    vagrant ssh

... there, change path to [Vagrant's][vagrant] shared folder and install all the required `gems`:

    cd /vagrant
    bundle install

[vagrant-puppet-template]: https://github.com/semanticdreamer/vagrant-puppet-template "vagrant-puppet-template"
[mite]: http://mite.yo.lk/ "mite. Sleek time tracking for teams & freelancers."
[mite-rb]: https://github.com/yolk/mite-rb "The official ruby library for interacting with the RESTful mite.api."
[ruby]: http://www.ruby-lang.org/ "Ruby"
[gembundler]: http://gembundler.com/ "Bundler: The best way to manage Ruby applications" 