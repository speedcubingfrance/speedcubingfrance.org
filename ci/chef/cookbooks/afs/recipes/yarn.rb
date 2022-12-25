bash "setup yarn #{node['yarn']['version']}" do
  code <<-EOF
    corepack enable
    yarn set version #{node['yarn']['version']}
  EOF
end
