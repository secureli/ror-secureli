require 'uri'
require 'net/https'

class BusinessesController < ApplicationController
  def index
  	if params[:googl_api_key].present? && params[:lat].present? && params[:lng].present? && params[:keyword].present?
  		@output = search_business(params[:googl_api_key], params[:output_type], params[:lat], params[:lng] , params[:keyword])
  	end
  end

  def show
  end

  def search_business(google_key="", output="", lat="", lng="" , keyword="")
  	results = { }
  	url = "https://maps.googleapis.com/maps/api/place/radarsearch/" + output + "?key=" + google_key + "&location=" + lat + "," + lng + "&keyword=" + keyword + "&radius=50000"
  	uri = URI.parse(url)
  	http = Net::HTTP.new(uri.host, uri.port)
  	http.open_timeout = 30
	http.read_timeout = 30
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  	response = http.request_post("#{uri.path}?#{uri.query}", "")

	case response
		when Net::HTTPOK # 200
			
			results = response.body

		when Net::HTTPNoContent # 204
			
			results = response.body

		when Net::HTTPBadRequest # 400
			
			results = response.body

		when Net::HTTPUnauthorized # 401
			
			results = response.body

		when Net::HTTPServiceUnavailable # 503
			
			results = response.body

		else
			
			results = response.body
	end
	return results
  end
end
