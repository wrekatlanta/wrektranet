json.(@users) do |user|
  json.(user, :created_at, :id, :username, :name, :status, :phone, :admin, :exec_staff, :roles, :points)

  json.avatar user.avatar.url(:small)

  json.shows do
    json.(user.legacy_profile.shows) do |show|
      json.(show, :id, :name)
    end
  end

  json.teams do
    json.(user.legacy_profile.teams) do |team|
      json.(team, :id, :name)
    end
  end
end
