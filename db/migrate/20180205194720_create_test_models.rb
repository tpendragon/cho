class CreateTestModels < ActiveRecord::Migration[5.1]
  def change
    create_table :test_models do |t|
      t.text :file_data
      t.timestamps
    end
  end
end
