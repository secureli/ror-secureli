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

FactoryGirl.define do
  factory :address do
    address 'MyString'
    lat 1.5
    lng 1.5
  end
end
