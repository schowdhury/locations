set :application, "my-location"
set :repository,  "git@github.com:schowdhury/locations.git"
set :deploy_to,     "/var/www/rails/#{application}"
set :rake, 'rake'
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

begin
  set :branchto, (branchto||'master')
rescue
  set :branchto, 'master'
end

# This change was done to be able to deploy to only one production server
begin
  set :serverto, (serverto||'all')
rescue
  set :serverto, 'all'
end

task :production do
  if ( "#{serverto}" == "all")
    role :web, 'my-location.sameerchowdhury.com'
    role :app, 'my-location.sameerchowdhury.com'
    role :db,  'my-location.sameerchowdhury.com', :primary => true
  else
   role :web,  "#{serverto}"
   role :app,  "#{serverto}" 
   role :db,   "#{serverto}" , :primary => true
  end

  set :deploy_role, 'production'
  set :rails_env, 'production'
  set :branch, "#{branchto}"
end


set :keep_releases, 5

set :user, 'deploy'
set :use_sudo, false

namespace :deploy do
  task :migrations do
    run <<-CMD
      source /etc/profile; source ~/.bashrc; cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} db:migrate
    CMD
  end
  
  task :symlink_configs, :roles => :app, :except => {:no_symlink => true} do
    run <<-CMD
      cd #{release_path} && ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml
    CMD
  end
  
  task :clear_cache, :roles => :app do
    run "rm -rf #{current_path}/public/cache/*; rm -rf #{current_path}/tmp/cache/*"
  end
  
  task :start, :roles => :app do
    run "source /etc/profile; source ~/.bashrc; cd #{current_path}; passenger start -p 9000 -d -e #{rails_env}"
    #run "touch #{current_release}/tmp/restart.txt"
  end
 
  task :stop, :roles => :app do
    run "source /etc/profile; source ~/.bashrc; rvm rvmrc trust #{current_path}; cd #{current_path}; passenger stop -p 9000;"
  end
 
  task :restart, :roles => :app do
    #run "touch #{current_release}/tmp/restart.txt"
    stop
    start
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    run("cd #{release_path}/vendor; ln -s #{shared_path}/vendor/bundle bundle")
  end
 
  task :bundle_new_release, :roles => :app do
    run "source /etc/profile; source ~/.bashrc; rvm rvmrc trust #{release_path}; cd #{release_path} && bundle install --gemfile #{release_path}/Gemfile --path #{shared_path}/bundle --deployment --quiet --without development test "
  end
end
 
after 'deploy:update_code', 'bundler:bundle_new_release'
after 'deploy:update_code', 'post_update'

task :post_update, :roles => :app do
  run "mkdir -p #{release_path}/tmp/cache"
end  

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end