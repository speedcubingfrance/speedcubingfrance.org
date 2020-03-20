class CreateFormats < ActiveRecord::Migration[5.1]
  def change
    create_table :formats, id: false do |t|
      t.string :name
      t.string :id, index: true, primary_key: true
      t.integer :expected_solve_count
      t.string :sort_by
      t.string :sort_by_second
      t.integer :trim_fastest_n
      t.integer :trim_slowest_n
    end
    Format.delete_all
    Format::ALL_FORMATS.each(&:save!)
  end
end
