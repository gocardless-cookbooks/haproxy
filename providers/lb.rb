use_inline_resources

action :create do
  #While there is no way to have an include directive for haproxy
  #configuration file, this provider will only modify attributes !
  listener = []
  listener << "bind #{new_resource.bind}" unless new_resource.bind.nil?
  listener << "balance #{new_resource.balance}" unless new_resource.balance.nil?
  listener << "mode #{new_resource.mode}" unless new_resource.mode.nil?
  listener += new_resource.servers.map {|server| "server #{server}" }
  listener += new_resource.acls.map {|acl| "acl #{acl}" }
  listener += new_resource.use_backend.map {|backend| "use_backend #{backend}" }
  listener += new_resource.capture_headers.map {|header| "capture request header #{header} len 15" } unless new_resource.capture_headers.empty?

  if new_resource.params.is_a? Hash
    listener += new_resource.params.map { |k,v| "#{k} #{v}" }
  else
    listener += new_resource.params
  end

  node.default['haproxy']['listeners'][new_resource.type][new_resource.name] = listener
end

