ActiveRecord::Base.configurations = { "test"=> {"adapter"=>"sqlite3", "database"=>":memory:"} }
ActiveRecord::Base.establish_connection :test

class CreateAllTables < ActiveRecord::Migration[7.0]
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