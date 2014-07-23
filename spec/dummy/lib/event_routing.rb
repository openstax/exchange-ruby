module EventRouting
  def event_routes(res, options = {})
    resources res, {only: :create,
                    controller: "#{res.to_s.singularize}_events".to_sym}
                   .merge(options)
  end
end

ActionDispatch::Routing::Mapper.send :include, EventRouting
