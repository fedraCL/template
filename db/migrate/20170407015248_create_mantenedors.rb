class CreateMantenedors < ActiveRecord::Migration
  def change
    create_table :mantenedors do |t|
      t.string :tipo
      t.string :valor
      t.string :misc
      t.string :codigo

      t.timestamps
    end
  end
end
