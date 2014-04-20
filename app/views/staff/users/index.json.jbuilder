json.(@users) do |user|
  json.(user, :id, :username, :name, :status, :phone, :exec_staff, :roles)
end