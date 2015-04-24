json.(@play_logs) do |log|
  json.(log, :id, :side, :playtime, :track, :track_title, :performance_by, :format, :album_title, :label)
  json.user log.user, :initials, :id
  json.read true
end