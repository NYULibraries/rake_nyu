source "http://rubygems.org"

# Declare your gem's dependencies in exlibris-aleph.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec
gem "coveralls", "~> 0.6.0", require: false, :group => :test
gem "debugger", "~> 1.5.0", :group => [:development, :test], :platform => :mri


# Testing gems
group :development, :test do
  platforms :jruby do
    gem "activerecord-jdbcmysql-adapter", "~> 1.2.5"
  end
  platforms :ruby do
    gem 'mysql2'
  end
end