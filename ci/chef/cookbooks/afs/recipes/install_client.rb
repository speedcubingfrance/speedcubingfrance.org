bash "run the client actions" do
  cwd "/home/btest/btest/client"
  code <<-EOF
    yarn install
  EOF
  user "btest"
end
