class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table(:messages) do |t|
      t.column :text, :string, :limit => 60, :null => false
      t.column :color, :string, :limit => 10, :default => '0000FF', :null => false
      t.column :node, :string, :limit => 1, :default => '1', :null => false
      t.timestamp :last_displayed_at
      t.timestamps
    end    
  end

  def self.down
    drop_table(:messages)
  end
end
