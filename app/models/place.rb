# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  place_id   :string
#  lat        :float
#  lng        :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Place < ActiveRecord::Base
end
