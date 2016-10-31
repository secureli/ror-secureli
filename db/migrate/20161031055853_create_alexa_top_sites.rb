class CreateAlexaTopSites < ActiveRecord::Migration
  def change
    create_table :alexa_top_sites do |t|
      t.integer :rank
      t.string :domain
      t.date :date

      t.timestamps null: false
    end
  end
end
