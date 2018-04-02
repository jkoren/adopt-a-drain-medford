# frozen_string_literal: true

require 'test_helper'

class AddressesControllerTest < ActionDispatch::IntegrationTest
  test 'should return latitude and longitude for a valid address' do
    stub_request(:get, 'https://maps.google.com/maps/api/geocode/json').
      with(query: {address: 'City Hall, Boston, MA', sensor: 'false'}).
      to_return(body: File.read(File.expand_path('../fixtures/city_hall.json', __dir__)))
    get address_url, params: {address: 'City Hall', city_state: 'Boston, MA', format: 'json'}
    assert_not_nil assigns :address
  end

  test 'should return an error for an invalid address' do
    stub_request(:get, 'https://maps.google.com/maps/api/geocode/json').
      with(query: {address: ', ', sensor: 'false'}).
      to_return(body: File.read(File.expand_path('../fixtures/unknown_address.json', __dir__)))
    stub_request(:get, 'http://geocoder.us/service/csv/geocode').
      with(query: {address: ', '}).
      to_return(body: File.read(File.expand_path('../fixtures/unknown_address.json', __dir__)))
    get address_url, params: {address: '', city_state: '', format: 'json'}
    assert_response :missing
  end
end
