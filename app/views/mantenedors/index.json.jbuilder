json.array!(@mantenedors) do |mantenedor|
  json.extract! mantenedor, :id, :tipo, :valor, :misc, :codigo
  json.url mantenedor_url(mantenedor, format: :json)
end
