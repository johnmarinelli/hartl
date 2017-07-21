FROM ruby:2.3.1

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs

# Main working directory.
# base directory for future commands.
RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy main app
COPY . ./

# Expose port 3000 to docker host so we can access from outside
EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
