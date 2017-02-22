class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.text :body
      t.text :source

      t.timestamps
    end
  end
end
