# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Core Rails framework
gem 'rails', '~> 7.0.8'

# Database - SQLite para desenvolvimento/teste
gem 'sqlite3', '~> 1.6'

# Web server - versão com binário pré-compilado para Windows
gem 'puma', '~> 5.6.8'

# Boot optimization
gem 'bootsnap', '>= 1.16', require: false

# Authentication with JWT tokens
gem 'devise', '~> 4.9'
gem 'devise_token_auth', '~> 1.2'

# CORS support for API
gem 'rack-cors', '~> 2.0'

# JSON serialization
gem 'jbuilder', '~> 2.11'

# Pagination
gem 'kaminari', '~> 1.2'

# Força versões com binários pré-compilados
gem 'bcrypt', '~> 3.1.18'
gem 'date', '~> 3.3.3'
gem 'io-console', '~> 0.6.0'

group :development do
  gem 'listen', '~> 3.8'
end

# Windows timezone support
gem 'tzinfo-data', platforms: %i[windows jruby]
