class Transaction < ApplicationRecord
  belongs_to :order
  enum status: {
    'init' => 0,
    'dealing' => 1,
    'success' => 2,
    'failed' => 3,
    'pending' => 4,
    'closed' => 5
  }
  enum transaction_type: { 'payment' => 0, 'refund' => 1, 'void' => 2 }
end