json.(@album, :album_id, :org_id, :media_type,
              :album_title, :performance_by,
              :date_auditioned, :auditioned_by,
              :airplay_frequency, :program_status,
              :notes, :recording_year
    )

json.tracks @album.tracks do |track|
  json.id track.track_id
  json.side track.side
  json.track track.track
  json.track_title track.track_title
  json.performance_by track.performance_by
  json.format track.format
  json.play_logs track.play_logs.recent do |log|
    json.playtime log.playtime
    json.user log.user, :initials
  end
end