# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  address    :string
#  lat        :float
#  lng        :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Address < ActiveRecord::Base
end
