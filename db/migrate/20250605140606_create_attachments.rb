class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.references :task, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
