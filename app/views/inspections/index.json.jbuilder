json.array!(@inspections) do |inspection|
  json.extract! inspection, :id, :inspect_id, :inspect_date, :results, :violations
  json.url inspection_url(inspection, format: :json)
end
