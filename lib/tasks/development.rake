desc "Start the server in development mode"
task :start => :environment do
  unless `ps ux | grep Postgres93.app`.include?('Applications/Postgres93.app')
    pid = spawn('open /Applications/Postgres93.app')
    Process.detach(pid)
  end
  exec 'RAILS_ENV=development foreman start -f ./Procfile.development'
end
