class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :mentioning, foreign_key: {to_table: :reports}, null: false
      t.references :mentioned, foreign_key: {to_table: :reports}, null: false

      t.timestamps
    end
    add_index :mentions, [:mentioning_id, :mentioned_id], unique: true
  end
end
