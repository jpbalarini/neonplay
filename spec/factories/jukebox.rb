require 'factory_girl'

FactoryGirl.define do
  factory :jukebox do     
    url "http://0.0.0.0:9292"
    volume 5
    association(:bar)
    repeat false
  end

  factory :jukebox_repeat, :class => Jukebox do     
    url "http://0.0.0.0:9292"
    volume 6

    before(:create) do |jukebox|
      jukebox.bar = FactoryGirl.create(:bar_2)
    end

    repeat true
  end
end

