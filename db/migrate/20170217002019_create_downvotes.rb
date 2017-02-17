class CreateDownvotes < ActiveRecord::Migration[5.0]
  def change
    create_table :downvotes do |t|
      t.references :user, foreign_key: true
      t.references :article, foreign_key: true

      t.timestamps
    end
  end
end
