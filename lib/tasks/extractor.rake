require 'uri'
require 'net/https'

namespace :extractor do
  desc 'fetch address'
  task pull_address: :environment do
    googl_api_key = 'AIzaSyAdd2VqDHX6rMLWekvV4Nlu5OBomHiS4HA'
    path = Rails.root.join('lib/tasks', 'address.txt')
    f = File.open(path)
    records = f.readlines
    records.each do |add|
      url = 'https://maps.googleapis.com/maps/api/geocode/json' + '?key=' + googl_api_key + '&address=' + add
      puts url

      results = {}

      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 30
      http.read_timeout = 30
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.request_post("#{uri.path}?#{uri.query}", '')
      next unless Net::HTTPOK # 200
      results = response.body
      puts
      json = JSON.parse(results)
      json['results'].each do |r|
        if r['geometry']['bounds'].present? && !Address.where(address: add, lat: r['geometry']['bounds']['northeast']['lat'], lng: r['geometry']['bounds']['northeast']['lng']).present?
          Address.create!(address: add, lat: r['geometry']['bounds']['northeast']['lat'], lng: r['geometry']['bounds']['northeast']['lng'])
          puts 'added record'
        end

        if r['geometry']['bounds'].present? && !Address.where(address: add, lat: r['geometry']['bounds']['southwest']['lat'], lng: r['geometry']['bounds']['southwest']['lng']).present?
          Address.create!(address: add, lat: r['geometry']['bounds']['southwest']['lat'], lng: r['geometry']['bounds']['southwest']['lng'])
          puts 'added record'
        end

        unless Address.where(address: add, lat: r['geometry']['location']['lat'], lng: r['geometry']['location']['lng']).present?
          Address.create!(address: add, lat: r['geometry']['location']['lat'], lng: r['geometry']['location']['lng'])
          puts 'added record'
        end

        unless Address.where(address: add, lat: r['geometry']['viewport']['northeast']['lat'], lng: r['geometry']['viewport']['northeast']['lng']).present?
          Address.create!(address: add, lat: r['geometry']['viewport']['northeast']['lat'], lng: r['geometry']['viewport']['northeast']['lng'])
          puts 'added record'
        end

        unless Address.create!(address: add, lat: r['geometry']['viewport']['southwest']['lat'], lng: r['geometry']['viewport']['southwest']['lng']).present?
          Address.create!(address: add, lat: r['geometry']['viewport']['southwest']['lat'], lng: r['geometry']['viewport']['southwest']['lng'])
          puts 'added record'
        end
      end
    end
  end

  desc 'fetch places'
  task pull_places: :environment do
  end
end
