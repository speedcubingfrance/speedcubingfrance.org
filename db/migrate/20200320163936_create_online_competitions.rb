class CreateOnlineCompetitions < ActiveRecord::Migration[5.1]
  def change
    create_table :online_competitions do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.boolean :visible

      t.timestamps
    end
  end
end
