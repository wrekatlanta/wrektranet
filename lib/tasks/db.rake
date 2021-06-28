# rake tasks to create legacy scheme
# see: http://blog.nistu.de/2012/03/25/multi-database-setup-with-rails-and-rspec

namespace :db do
  namespace :schema do
    # desc 'Dump additional database schema'
    task :dump => [:environment, :load_config] do
      filename = "#{Rails.root}/db/staff_legacy_schema.rb"
      File.open(filename, 'w:utf-8') do |file|
        ActiveRecord::Base.establish_connection(
          :database => "staff_legacy_#{Rails.env}",
          :adapter => 'mysql2',
          :host => 'localhost',
          :username => 'root',
          :password => 'NewPassword',
          :encoding => 'utf8',
          :pool => '5'
        )
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end

  namespace :test do
    # desc 'Purge and load staff_legacy_test schema'
    task :load_schema do
      # like db:test:purge
      abcs = ActiveRecord::Base.configurations
      ActiveRecord::Base.connection.recreate_database(abcs['staff_legacy_test']['database'])
      # like db:test:load_schema
      ActiveRecord::Base.establish_connection(
        :database => 'staff_legacy_test',
        :adapter => 'mysql2',
        :host => 'localhost',
        :username => 'root',
        :password => 'NewPassword',
        :encoding => 'utf8',
        :pool => '5'
      )
      ActiveRecord::Schema.verbose = false
      load("#{Rails.root}/db/staff_legacy_schema.rb")
    end
  end
end
