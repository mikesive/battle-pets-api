class CreateBattlePets < ActiveRecord::Migration[5.0]
  def change
    create_table :battle_pets do |t|
      t.string :name, null: false
      t.integer :user_id, null: false

      t.integer :agility, default: 0, null: false
      t.integer :intelligence, default: 0, null: false
      t.integer :senses, default: 0, null: false
      t.integer :strength, default: 0, null: false

      t.string :job_id
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
