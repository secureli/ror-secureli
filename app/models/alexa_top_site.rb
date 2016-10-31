class AlexaTopSite < ActiveRecord::Base
	validates :domain, uniqueness: true
end
