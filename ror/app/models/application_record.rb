class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def as_json(args)
    super(args).merge({
      updated_at: self.updated_at.to_i,
      created_at: self.created_at.to_i
    })
  end
end
