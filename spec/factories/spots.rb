FactoryBot.define do
  factory :spot do
    name {"テストスポット"}
    address {"テスト住所"}
    description {"テスト紹介"}
    image_name { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/post.test.png')) }
    association :users

    trait :invalid do
      name { nil }
    end
  end
end