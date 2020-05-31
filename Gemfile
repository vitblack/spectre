source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Core gems
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'bootsnap', '>= 1.4.2', require: false

# Assets gems
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

# Authentication
gem 'devise', '~> 4.7.1'

# App gems
gem 'interactor', '~> 3.0'
gem 'faraday'

group :development, :test do
  # debugger
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Static code analyzer
  gem 'rubocop-performance', '~> 1.5.1', require: false
  gem 'rubocop-rails', '~> 2.4.0', require: false
  gem 'rubocop-rspec', '~> 1.37.0', require: false
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
