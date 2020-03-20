class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.integer :value1
      t.integer :value2
      t.integer :value3
      t.integer :value4
      t.integer :value5
      t.integer :best
      t.integer :average
      t.string :event_id, index: true
      t.string :format_id, index: true
      t.references :user
      t.references :online_competition
    end
  end
end
