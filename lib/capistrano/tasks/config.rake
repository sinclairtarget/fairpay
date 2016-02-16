desc "Uploads git-ignored config files to the shared folder."
namespace :config do
  task :upload do
    on roles(:app) do
      upload! ".rbenv-vars", "#{shared_path}/.rbenv-vars"
    end
  end
end
