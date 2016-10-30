require 'uri'
require 'net/https'

class BusinessesController < ApplicationController
  def index
    @output = ''
    if params[:type] == 'Business'
      if params[:googl_api_key].present? && params[:lat].present? && params[:lng].present?
        # @output = search_business(params[:googl_api_key], params[:output_type], params[:lat], params[:lng] , params[:keyword])
        url = 'https://maps.googleapis.com/maps/api/place/radarsearch/' + params[:output_type] + '?key=' + params[:googl_api_key] + '&location=' + params[:lat] + ',' + params[:lng] + '&keyword=' + params[:keyword] + '&radius=50000'
        @output = search_business(url)
      end
    elsif params[:type] == 'Address'
      url = 'https://maps.googleapis.com/maps/api/geocode/' + params[:output_type] + '?key=' + params[:googl_api_key] + '&address=' + params[:address]
      @output = search_business(url)
    end
  end

  def new
  end

  def show
  end

  def search_business(url)
    results = {}
    # url = "https://maps.googleapis.com/maps/api/place/radarsearch/" + output + "?key=" + google_key + "&location=" + lat + "," + lng + "&keyword=" + keyword + "&radius=50000"
    puts url
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 30
    http.read_timeout = 30
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request_post("#{uri.path}?#{uri.query}", '')
    results = case response
    when Net::HTTPOK # 200
      response.body
    when Net::HTTPNoContent # 204
      response.body
    when Net::HTTPBadRequest # 400
      response.body
    when Net::HTTPUnauthorized # 401
      response.body
    when Net::HTTPServiceUnavailable # 503
      response.body
    else
      response.body
    end
    results
  end
end
