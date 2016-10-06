class CreateChinaRegionTables < ActiveRecord::Migration
  def change
    unless table_exists? 'provinces'
      create_table :provinces do |t|
        t.string :name
        t.string :pinyin
        t.string :pinyin_abbr
        t.timestamps
      end

      add_index(:provinces, :name) unless index_exists?(:provinces, :name)
      add_index(:provinces, :pinyin) unless index_exists?(:provinces, :pinyin)
      add_index(:provinces, :pinyin_abbr) unless index_exists?(:provinces, :pinyin_abbr)
    end

    unless table_exists? 'cities'
      create_table :cities do |t|
        t.string :name
        t.integer :province_id
        t.integer :level
        t.string :zip_code
        t.string :pinyin
        t.string :pinyin_abbr
        t.timestamps
      end

      add_index(:cities, :name) unless index_exists?(:cities, :name)
      add_index(:cities, :province_id) unless index_exists?(:cities, :province_id)
      add_index(:cities, :level) unless index_exists?(:cities, :level)
      add_index(:cities, :zip_code) unless index_exists?(:cities, :zip_code)
      add_index(:cities, :pinyin) unless index_exists?(:cities, :pinyin)
      add_index(:cities, :pinyin_abbr) unless index_exists?(:cities, :pinyin_abbr)
    end

    unless table_exists? 'districts'
      create_table :districts do |t|
        t.string :name
        t.integer :city_id
        t.string :pinyin
        t.string :pinyin_abbr
        t.timestamps
      end

      add_index(:districts, :name) unless index_exists?(:districts, :name)
      add_index(:districts, :city_id) unless index_exists?(:districts, :city_id)
      add_index(:districts, :pinyin) unless index_exists?(:districts, :pinyin)
      add_index(:districts, :pinyin_abbr) unless index_exists?(:districts, :pinyin_abbr)
    end
  end
end
