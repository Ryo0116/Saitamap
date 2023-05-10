source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

gem "rails", "~> 6.1.4"
gem "sprockets-rails"
gem 'pg'
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "slim-rails"
gem "html2slim"
gem "devise"
gem "devise-i18n"
gem "devise-i18n-views"
gem "sassc"
gem "rails-i18n"
gem "pry-rails"
gem "bootstrap"
gem "jquery-rails"
gem "sass-rails"
gem "sassc-rails"
gem "webpacker"
gem "cssbundling-rails"


group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :development, :test do
  gem 'rspec-rails', '~> 5.0.0'
end

group :production do
  gem "pg"
end