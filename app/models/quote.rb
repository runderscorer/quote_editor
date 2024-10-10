class Quote < ApplicationRecord
  validates :name, presence: true

  after_create_commit -> { broadcast_prepend_to 'quotes', partial: 'quotes/quote', locals: { quote: self }, target: 'quotes' }
  # This can be moved into a background job by using broadcast_prepend_later_to
  #
  # Can be shortened to: after_create_commit -> { broadcast_prepend_to 'quotes' } if using Rails conventions
  #
  # partial defaults to instance.to_partial_path (e.g., 'quotes/quote')
  # locals defaults to { model_name.element.to_sym => self } (e.g., { quote: self })
  # target defaults to model_name.plural (e.g., 'quotes')
  after_update_commit -> { broadcast_replace_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: self }
  # Can also be shortened to: after_create_commit -> { broadcast_replace_to 'quotes' } if using Rails conventions
  after_destroy_commit -> { broadcast_remove_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: self }
  #
  # And all of these can be combined into one method: broadcasts_to -> (quote) { 'quotes' }, inserts_by: :prepend

  scope :ordered, -> { order(created_at: :desc) }
end
