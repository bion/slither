require 'active_record'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/strip'
require 'erb'
require 'fileutils'
require 'json'
require 'pathname'
require 'pg'
require 'yaml'
require 'zlib' # needed by active record tasks

require_relative 'lib/database_connection'
require_relative 'lib/crawl_domain'

class SeedLoader
  def load_seed
    load "#{ActiveRecord::Tasks::DatabaseTasks.db_dir}/seeds.rb"
  end
end

ActiveRecord::Tasks::DatabaseTasks.tap do |config|
  config.root = Rake.application.original_dir
  config.env = ENV["SLITHER_ENV"] || "development"
  config.db_dir = "db"
  config.migrations_paths = ["db/migrate"]
  config.seed_loader = SeedLoader.new
  config.database_configuration = ActiveRecord::Base.configurations
end

load "active_record/railties/databases.rake"

# db:load_config can be overriden manually
Rake::Task["db:seed"].enhance(["db:load_config"])
Rake::Task["db:load_config"].clear

# define Rails' tasks as no-op
Rake::Task.define_task("db:environment").clear

if Rake::Task.task_defined?("db:test:deprecated")
  Rake::Task["db:test:deprecated"].clear
end

namespace :db do
  desc "Create a migration (parameters: NAME, VERSION)"
  task :create_migration do
    unless ENV["NAME"]
      puts "No NAME specified. Example usage: `rake db:create_migration NAME=create_users`"
      exit
    end

    name = ENV["NAME"]
    version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")

    ActiveRecord::Migrator.migrations_paths.each do |directory|
      next unless File.exist?(directory)

      migration_files = Pathname(directory).children

      if duplicate = migration_files.find { |path| path.basename.to_s.include?(name) }
        puts "Another migration is already named \"#{name}\": #{duplicate}."
        exit 1
      end
    end

    filename = "#{version}_#{name}.rb"
    dirname = ActiveRecord::Migrator.migrations_paths.first
    path = File.join(dirname, filename)
    ar_maj = ActiveRecord::VERSION::MAJOR
    ar_min = ActiveRecord::VERSION::MINOR
    base = "ActiveRecord::Migration"
    base += "[#{ar_maj}.#{ar_min}]" if ar_maj >= 5

    FileUtils.mkdir_p(dirname)
    File.write path, <<-MIGRATION.strip_heredoc
      class #{name.camelize} < #{base}
        def change
        end
      end
    MIGRATION

    puts "Created new migration at:\n"
    puts "  #{path}"
  end
end

desc "pull all websites currently in db"
task :pull_all do
  puts "Pulling all #{Website.count} sites\n"
  require_relative 'lib/pull_website'

  start_time = Time.now

  PullTime = Struct.new(:site_name, :duration)

  errors_thrown = []
  threads = []
  pull_durations = []
  mutex = Mutex.new
  num_threads = (ENV['SLITHER_NUM_THREADS'] || 1).to_i

  num_threads.times.each do
    threads << Thread.new do
      until Website.where(pull_count: 0).empty? do
        website = nil

        mutex.synchronize do
          ActiveRecord::Base.transaction do
            website = Website.where(pull_count: 0).first
            website.update_attributes!(pull_count: 1) if website
          end
        end

        if website
          logfile = File.open("log/#{website.url}.log", 'a')

          puts "Pulling #{website.url}..."
          logfile.write "\nPulling #{website.url}... "

          begin
            local_start = Time.now

            PullWebsite.run(website)

            duration = Time.now - local_start

            mutex.synchronize do
              pull_durations << PullTime.new(website.url, duration)
            end

            logfile.puts "done."
            puts "finished #{website.url} in #{duration.round} seconds."
          rescue => e
            puts e.message
            puts e.backtrace

            errors_thrown << {
              id: website.id,
              url: website.url,
              error: e.message,
              trace: e.backtrace
            }

            logfile.puts "error!"
            puts "error thrown pulling #{website.url}"
          end

          logfile.close
        end
      end
    end
  end

  threads.each(&:join)

  dur = Time.now - start_time

  pull_durations.sort_by!(&:duration)

  puts "\nfinished all in #{dur.round} seconds."
  puts "\nmedian time to crawl: #{pull_durations[pull_durations.size / 2].duration}"
  puts "5 slowest websites:"

  pull_durations
    .reverse
    .take(5)
    .each { |pd| puts "    #{pd.site_name}: #{pd.duration} seconds" }

  unless errors_thrown.empty?
    File.open('errors.json', 'w') { |f| f.write(JSON.generate(errors_thrown)) }

    puts "\n\n****************************************************************\n"
    puts "#{errors_thrown.size} unhandled exceptions written to errors.json"
    puts "\n****************************************************************"
  end
end

desc "pull a single website. Example usage: `rake pull_single URL=zerohedge.com` do note include the protocol"
task :pull_single do
  url = ENV['URL']

  unless url
    puts "No URL specified. Example usage: `rake pull_single URL=zerohedge.com` do note include the protocol"
    exit 1
  end

  website = Website.find_by(url: url)

  unless website
    print "No website found in the database for #{url}, do you want to add it? [y/n] "

    unless STDIN.gets.chomp.downcase == "y"
      puts "okay... whatever"
      exit 0
    end

    website = Website.create! url: url
  end

  print "Pulling #{url}... "
  require_relative 'lib/pull_website'

  error_count = PullWebsite.run(website) || 0
  puts "done with #{error_count} errors."
end


desc "Crawl"
task :crawl do
  CrawlDomain.run(ENV['DOMAIN'])
end
