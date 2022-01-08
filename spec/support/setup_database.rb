ActiveRecord::Base.configurations = { "test"=> {"adapter"=>"sqlite3", "database"=>":memory:"} }
ActiveRecord::Base.establish_connection :test

version = "#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"
class CreateAllTables < ActiveRecord::Migration[version]
  def change
    create_table :users do |t|
      t.integer :gender, null: false, default: 0, limit: 1
      t.integer :status, null: false, default: 0, limit: 1

      t.timestamps
    end
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.new.change
