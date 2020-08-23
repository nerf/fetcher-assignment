class Library < Struct.new(:url, :username, :name, :description, :source, :updated_at, keyword_init: true)
  def as_json(only: nil)
    if only
      only.each_with_object({}) do |atr, obj|
        obj[atr] = public_send(atr)
      end
    else
      to_h
    end
  end
end
