json.(@albums) do |album|
  json.(album, :id, :organization, :media_type,
              :album_title, :performance_by,
              :date_auditioned, :auditioned_by,
              :airplay_frequency, :program_status,
              :notes, :recording_year
      )
end