json.(@play_logs) do |log|
  json.(log, :id, :playtime)
  json.track log.track, :id, :side, :track, :track_title, :performance_by, :format, :album
  json.organization log.track.album.organization, :id, :org_name
  json.user log.user, :initials, :id
  json.read true
end