FactoryBot.define do
    factory :favorite do
      association :spot
      association :user
    end
  end