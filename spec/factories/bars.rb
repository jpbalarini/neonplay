require 'factory_girl'

FactoryGirl.define do
  factory :bar do
    name "Bremen"
    token '8093c64331ab2486'

    after(:create) do |bar|
      bar.songs << FactoryGirl.create(:song_2)
    end
  end

  factory :bar_2, :class => Bar do
    name "Moe's Bar"
    token 'b0ffdf84fd2e7e2e'

    after(:create) do |bar|
      bar.songs << FactoryGirl.create(:song_2)
      bar.songs << FactoryGirl.create(:song_3)
    end
  end
end

