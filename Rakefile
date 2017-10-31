require "sinatra/activerecord/rake"

namespace :db do
  task :load_config do
    require "./app"
  end
end

namespace :assets do
  desc 'Compile scss to css'
  task :precompile do
    next if ENV['RACK_ENV'] == 'production'

    # from scss to css
    file_list = FileList.new('assets/stylesheets/*.scss')
    file_list.each do |file|
      file_name = File.basename(file, ".*")
      file_ext = File.extname(file)

      if File.extname(file) == '.scss'
        `scss #{file}:public/css/#{file_name}.css --style compressed`
        `rm public/css/*.map`
      end
    end
  end
end
