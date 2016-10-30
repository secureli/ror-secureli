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

FactoryGirl.define do
  factory :place do
    place_id 'MyString'
    lat 1.5
    lng 1.5
  end
end
