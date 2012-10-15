Spree Runner
============

This is a simple script that runs multiple checkouts in parallel against a remote Spree store.

It is not a load tester, it runs an instance or webkit_server for every concurrent checkout.

Usage
-----

Checkout, bundle install: then:

````bash
bundle exec ./checkout --help
````

````bash
bundle exec ./checkout --url http://www.example.com
````

YMMV
