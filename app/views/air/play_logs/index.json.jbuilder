json.(@play_logs) do |log|
  json.(log, :playtime)
  json.track log.track, :id, :track, :track_title, :performance_by, :format, :album
  json.organization log.track.album.organization, :id, :org_name
  json.user log.user, :initials
  json.read true
end