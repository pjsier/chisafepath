FROM ruby:2.2.4

RUN apt-get update && apt-get install -y \
  build-essential \
  libxml2-dev \
  libxslt1-dev

RUN mkdir -p /chisafepath
WORKDIR /chisafepath

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . ./

EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
