json.extract! profile, :id, :name, :email, :twitter, :created_at, :updated_at
json.url profile_url(profile, format: :json)
