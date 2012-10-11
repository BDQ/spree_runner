require 'rubygems'
require "bundler/setup"
require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'parallel'
require 'faker'

Capybara.run_server = false
Capybara.app_host = 'http://somestore.spree.mx'
Capybara.register_driver :webkit do |app|
  Capybara::Driver::Webkit.new(app, :ignore_ssl_errors => true)
end
Capybara.reset_sessions!

module SpreeRunner
  class Checkout
    def start(id)
      puts "#{id}: Starting session."
      s = Capybara::Session.new(:webkit)

      puts "#{id}: visiting root"
      s.visit('/')

      product_link = s.all('ul#products a[title]').sample
      puts "#{id}: visiting random product"
      product_link.click

      puts "#{id}: adding to cart"
      s.click_button('add-to-cart-button')

      puts "#{id}: checking out"
      s.click_link('Checkout')

      puts "#{id}: registering as guest"
      s.fill_in('order_email', :with => Faker::Internet.email)
      s.click_button('Continue')


      puts "#{id}: filling in address"
      s.fill_in('order_bill_address_attributes_firstname', :with => Faker::Name.first_name)
      s.fill_in('order_bill_address_attributes_lastname', :with => Faker::Name.last_name)
      s.fill_in('order_bill_address_attributes_address1', :with => Faker::Address.street_name)
      s.fill_in('order_bill_address_attributes_city', :with => Faker::Address.city)
      s.select(Faker::Address.state, :from => 'order_bill_address_attributes_state_id')
      s.fill_in('order_bill_address_attributes_zipcode', :with => Faker::Address.zip_code)
      s.fill_in('order_bill_address_attributes_phone', :with => Faker::PhoneNumber.phone_number)
      s.check('order_use_billing')
      s.click_button('Save and Continue')

      puts "#{id}: selecting shipping"
      # just use default
      s.click_button('Save and Continue')

      puts "#{id}: filling payment details"
      s.fill_in('card_number', :with => '4111111111111111')
      s.fill_in('card_code', :with => '123')
      s.click_button('Save and Continue')


      puts "#{id}: confirming"
      s.click_button('Place Order')
      # s.driver.render("#{id}.png")
    end
  end
end


# Parallel.map((1..2).to_a, :in_processes => 2) do |i|
  c = SpreeRunner::Checkout.new
  c.start(1)
# end
