source "http://rubygems.org"

# Declare your gem's dependencies in exlibris-aleph.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec
gem "coveralls", "~> 0.7.0", require: false, :group => :test
gem "debugger", "~> 1.6.0", :group => [:development, :test], :platform => :mri


# Testing gems
group :development, :test do
  platforms :jruby do
    gem "activerecord-jdbcmysql-adapter", "~> 1.3.0"
  end
  platforms :ruby do
    gem 'mysql2', "~> 0.3.0"
  end
end