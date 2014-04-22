ThinkingSphinx::Index.define :content, :with => :active_record do
  # fields
  indexes :name, :sortable => true
  #indexes year
  #indexes author.name, :as => :author, :sortable => true

  # attributes
  #has author_id, created_at, updated_at
end