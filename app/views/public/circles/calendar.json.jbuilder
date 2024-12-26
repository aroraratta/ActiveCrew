json.array!(@events) do |event|
  json.id event.id
  json.circle_idcircle_id
  json.event_title event.event_title
  json.event_place event.event_place
  json.event_memo event.event_memo
  json.start event.start.in_time_zone("Tokyo")
  json.end event.end.in_time_zone("Tokyo")
end