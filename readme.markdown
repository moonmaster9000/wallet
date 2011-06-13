# Wallet

Wallet, a simple ruby DSL for centralizing action cache configuration inside your Rails app.

## Installation

Wallet is a gem, available from http://rubygems.org. 

Add the following to your Rails 3 app's Gemfile:

    gem 'wallet', '~> 1.0'

## Usage

Let's imagine your app has a controller `HomeController`, and you want to action cache the index action inside of it. First, create a `config/wallet.rb` inside your rails root, then open your `Wallet` and add some `cash`:

    Wallet.open do
      cash :home do
        index
      end
    end

Next, open your `ApplicationController`, and add the following into it: 

    class ApplicationController < ActionController::Base
      include Wallet::Cash
      cash!
    end

The `cash!` method will setup action caching for your controllers (if they have any cache configuration in Wallet). 

With this code in place, Rails will action cache the `index` action inside your home controller for the default TTL (time-to-live) duration: 10 minutes. You can change the default ttl by passing a duration to the `default_ttl` method:

    Wallet.default_ttl = 2.minutes

Now, suppose we have another controller, `ArticlesController`, and we want to cache the `show` and `index` actions on it for a duration of 20 minutes. Simple!

    Wallet.open do
      cash :articles, :for => 20.minutes do
        show
        index
      end
    end

This will cache only the `show` and `index` actions on the `ArticlesController`.

Now imagine we've added a third action, `comments`, to our `ArticlesController`, and we want to cache it for only 1 minute:

    Wallet.open do
      cash :articles, :for => 20.minutes do
        show
        index
        comments 1.minute
      end
    end

## Before filters and action caching

Sometimes, even though an action is cached, you want a before filter to run before Rails try's to serve out the cached response. Authentication is one common use case. You can accomplish this with Wallet by simply calling `cash!` after the before filters:

    class ApplicationController < ActionController::Base
      include Wallet::Cash

      before_filter :authentication
      cash!

      private
      def authentication
        #...
      end
    end

Now, the `authentication` method will run before your before filters. 

## Engines

Wallet plays nice with engines. If you'd like to use Wallet inside your engine, create a `config/wallet.rb` file inside your engine, then include `Wallet::Railtie` inside your Engine railtie:

module Comments
  class Engine < Rails::Engine
    include Wallet::Railtie
  end
end

Now, Rails will load the `config/wallet.rb` inside your engine before your controllers load. 
