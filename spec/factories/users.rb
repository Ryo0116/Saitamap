FactoryBot.define do
    factory :user do
      name { "test" }
      sequence(:email) { |n| "TEST#{n}@example.com" }
      password { "testuser" }
      password_confirmation { "testuser" }
  
      trait :with_image do
        image_name { Rack::Test::UploadedFile.new("#{Rails.root}/spec/factories/test.jpg", "image/jpeg") }
      end
    end
  end