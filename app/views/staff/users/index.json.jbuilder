json.(@users) do |user|
  json.(user, :created_at, :id, :username, :name, :status, :phone, :exec_staff, :roles)

  json.avatar user.avatar.url(:small)
end