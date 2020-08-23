require 'json'

module ResponseAsObject
  def resp_obj
    JSON.parse(last_response.body)
  end
end
