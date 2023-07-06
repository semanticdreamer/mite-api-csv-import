FROM ruby:3.2.2

# remove warning
RUN bundle config --global silence_root_warning 1

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY importer.rb ./
RUN chmod +x ./importer.rb

CMD ["./importer.rb"]