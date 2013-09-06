require 'factory_girl'

FactoryGirl.define do
  factory :song do
    title 'Days are Forgotten'
    artist 'Kasabian'
    album 'Velociraptor'
    price '0.99'
  end

  factory :song_2, :class => Song do
    title 'Dont Look Back In Anger'
    artist 'Oasis'
    album 'Morning Glory'
    price '1.00'
    length 10
  end

  factory :song_3, :class => Song do
    title 'Something'
    artist 'The Beatles'
    album 'One'
    price '2.99'
    length 10
  end
end