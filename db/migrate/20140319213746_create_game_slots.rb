class CreateGameSlots < ActiveRecord::Migration
  def change
    create_table :game_slots do |t|
      t.text :game
      t.string :game_type
      t.string :card_style

      t.timestamps
    end
  end
end
