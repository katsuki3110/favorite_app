User.create!(name:  "example",
             email: "example@test.com",
             password:              "password",
             password_confirmation: "password",
             introduction: "自己紹介",
             image_user: nil,
             admin: true,
             activated: true,
             activated_at: Time.zone.now
)

15.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@test.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               introduction: "自己紹介欄",
               image_user: nil,
               activated: true,
               activated_at: Time.zone.now
  )
end


users = User.order(:created_at).take(5)

5.times do |n|
  spot_array = [{place: "スポット1-#{n+1}", image_spot: nil, explaine: "スポットの説明"},
                {place: "スポット2-#{n+1}", image_spot: nil, explaine: "スポットの説明"},
                {place: "スポット3-#{n+1}", image_spot: nil, explaine: "スポットの説明"},
                {place: "スポット4-#{n+1}", image_spot: nil, explaine: "スポットの説明"},
                {place: "スポット5-#{n+1}", image_spot: nil, explaine: "スポットの説明"}]
  num_array = [1,2,3,4,5]
  num = num_array.sample(1)

  spot = spot_array.sample(num[0])

  users.each do |user|
    user.posts.create!(title: "記事タイトル#{n+1}",
                       image_post: nil,
                       place: "地名#{n+1}",
                       overview: "モデルコースの概要",
                       spots_attributes: spot
    )
  end

end
