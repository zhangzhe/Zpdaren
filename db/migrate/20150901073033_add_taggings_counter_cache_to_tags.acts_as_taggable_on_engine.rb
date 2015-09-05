# This migration comes from acts_as_taggable_on_engine (originally 3)
class AddTaggingsCounterCacheToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :taggings_count, :integer, default: 0

    say_with_time('reset column information') do
      ActsAsTaggableOn::Tag.reset_column_information
      say("reset column information over!")
    end

    say_with_time('reset counters') do
      ActsAsTaggableOn::Tag.find_each do |tag|
        ActsAsTaggableOn::Tag.reset_counters(tag.id, :taggings)
        say("#{tag.id} reset counters!")
      end
    end
  end

  def self.down
    remove_column :tags, :taggings_count
  end
end
