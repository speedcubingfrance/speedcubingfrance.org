class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.integer :value1, default: 0
      t.integer :value2, default: 0
      t.integer :value3, default: 0
      t.integer :value4, default: 0
      t.integer :value5, default: 0
      t.integer :best, default: 0
      t.integer :average, default: 0
      t.string :event_id, index: true
      t.string :format_id, index: true
      t.references :user
      t.references :online_competition
    end
  end
end
