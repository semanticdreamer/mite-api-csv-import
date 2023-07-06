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

- [Ruby][ruby] (tested with **ruby 3.2.2** Docker and **3.0.6** Windows)

## Setup

Install required `gems` (see `Gemfile`) - preferably using [Bundler][gembundler]:

    bundle install

## Usage

Provide CSV file - have a look at `example.csv` file for format reference.

Rename `config.yml.dist` to `config.yml` and adjust to your needs.

**Notes**

- Make sure your CSV file is valid, e.g. proper use of text delimiter, etc.
- Don't forget to provide proper column header mapping!

Execute importer

    ruby importer.rb

## Development Environment

Built by [Docker][docker] and Managed by [GNU Make][make].

[mite]: http://mite.yo.lk/ "mite."
[mite.api]: http://mite.yo.lk/en/api/index.html "mite.api"
[docker]: https://www.docker.com/ "Docker"
[make]: https://www.gnu.org/software/make/ "GNU Make"
[mite]: http://mite.yo.lk/ "mite. Sleek time tracking for teams & freelancers."
[mite-rb]: https://github.com/yolk/mite-rb "The official ruby library for interacting with the RESTful mite.api."
[ruby]: http://www.ruby-lang.org/ "Ruby"
[gembundler]: http://gembundler.com/ "Bundler: The best way to manage Ruby applications" 

```shell
# Generate Gemfile.lock
make bundle-install

# Build Container
make build

# Run importer
make importer

# Run bash shell
make shell
```

### Build Windows executable for Ruby script 



```powershell
# Windows

# https://rubyinstaller.org/
# download and install rubyinstaller-devkit-3.0.6-1-x64.exe
# https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.6-1/rubyinstaller-devkit-3.0.6-1-x64.exe

gem install mite-rb

# https://github.com/larsch/ocra
gem install ocra

gem install minitest

# https://github.com/liveeditor/net_http_ssl_fix
gem install net_http_ssl_fix

ocra --console --chdir-first --icon importer.ico --output importer.exe --no-enc --add-all-core --no-autoload --dll ruby_builtin_dlls\libssl-1_1-x64.dll --dll ruby_builtin_dlls\libyaml-0-2.dll --dll ruby_builtin_dlls\libgmp-10.dll --dll ruby_builtin_dlls\libcrypto-1_1-x64.dll --no-dep-run --gem-full --gemfile .\Gemfile .\importer.rb
```