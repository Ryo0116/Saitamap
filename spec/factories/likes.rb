FactoryBot.define do
    factory :like do
      association :spot
      association :user
    end
  end