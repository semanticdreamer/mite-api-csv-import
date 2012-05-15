# Import time entries to mite. from CSV file.

Import time tracking data from CSV data source using RESTful Webservices provided by [mite.api][mite.api] (wrapped by [mite-rb - The official ruby library for interacting with the RESTful mite.api][mite-rb]).

## Features
- auto create [mite.][mite] project records - if not found by project name
- auto create [mite.][mite] customer records and project relation - if project name didn't exist
- auto create [mite.][mite] service records - if not found by service name
- auto create [mite.][mite] time entries - if tracked time greater than 0 minutes
- display stats about created [mite.][mite] records

## Example Output

    -------------------------------------------
              mite. API CSV Import            
    -------------------------------------------
     - import to account 'YOUR MITE ACCOUNT'.
     - 5 rows processed.
     - 3 customer(s) created.
     - 5 project(s) created.
     - 1 service(s) created.
     - 5 time entries created.
    -------------------------------------------

## Prerequisites

- [Ruby][ruby] (tested with **ruby 1.9.2p290**)

## Setup

Install required `gems` (see `Gemfile`) - preferably using [Bundler][gembundler]:

    bundle install

## Usage

Provide CSV file - have a look at `example.csv` file for format reference.

Rename `configuration.yml.dist` to `configuration.yml` and adjust to your needs.

**Notes**

- Make sure your CSV file is valid, e.g. proper use of text delimiter, etc.
- Don't forget to provide proper column header mapping!

Execute importer

    ruby importer.rb

## Development Environment

- Proudly Built by [Vagrant][vagrant] and Managed by [Puppet][puppet] leveraging [vagrant-puppet-template][vagrant-puppet-template].
- For setup instructions checkout `README` of [vagrant-puppet-template][vagrant-puppet-template].
- [Ruby][ruby] application managed using [Bundler][gembundler].

[mite]: http://mite.yo.lk/ "mite."
[mite.api]: http://mite.yo.lk/en/api/index.html "mite.api"
[vagrant]: http://vagrantup.com/ "Vagrant"
[puppet]: http://projects.puppetlabs.com/projects/puppet "Puppet"
[vagrant-puppet-template]: https://github.com/semanticdreamer/vagrant-puppet-template "vagrant-puppet-template"
[mite]: http://mite.yo.lk/ "mite. Sleek time tracking for teams & freelancers."
[mite-rb]: https://github.com/yolk/mite-rb "The official ruby library for interacting with the RESTful mite.api."
[ruby]: http://www.ruby-lang.org/ "Ruby"
[gembundler]: http://gembundler.com/ "Bundler: The best way to manage Ruby applications" 