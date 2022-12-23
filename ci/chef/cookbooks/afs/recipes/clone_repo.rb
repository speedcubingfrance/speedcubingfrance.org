# This can be ran by any user to clone/update the repo

git "afs repo" do
  repository "https://github.com/speedcubingfrance/speedcubingfrance.org.git"
  destination node[:repo_home]
  revision "master"
  user node[:user]
end
