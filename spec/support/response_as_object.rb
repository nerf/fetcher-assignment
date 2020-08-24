require 'json'

module ResponseAsObject
  def resp_obj
    @response_as_object ||= JSON.parse(last_response.body)
  end
end
