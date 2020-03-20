class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events, id: false do |t|
      t.string :name
      t.string :preferred_format
      t.string :id, index: true, primary_key: true
      t.integer :rank
    end
    Event.delete_all
    Event::ALL_EVENTS.each(&:save!)
  end
end
