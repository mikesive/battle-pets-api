class CreateBattles < ActiveRecord::Migration[5.0]
  def change
    create_table :battles do |t|
      t.integer :contestant_ids, array: true, default: []
      t.integer :user_id

      t.string :battle_type
      t.string :job_id
      t.string :status
      t.string :unique_hash

      t.references :winner
      t.references :loser

      t.timestamps
    end
  end
end
