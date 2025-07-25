# Base image: Ruby with necessary dependencies for Jekyll
FROM ruby:3.2

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN #groupadd -g 1000 appuser && useradd -m -u 1000 -g appuser appuser

# Set the working directory inside the container
WORKDIR /usr/src/app

# Install bundler
RUN gem install bundler:2.3.26

# Switch to the non-root user
#USER appuser

# Copy Gemfile into the container (necessary for `bundle install`)
#COPY --chown=appuser:appuser Gemfile Gemfile.lock ./
COPY Gemfile Gemfile.lock ./

# Install dependencies specified in Gemfile
RUN bundle install

# Copy the rest of your application code
#COPY --chown=appuser:appuser . .
#COPY . .

# Expose port 4000 for Jekyll server
EXPOSE 4000

# Command to serve the Jekyll site
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--watch"]