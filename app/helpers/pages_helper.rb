# frozen_string_literal: true

module PagesHelper
  def transactions_count(account)
    transactions_count = account[:extra][:transactions_count]

    return 0 if transactions_count.blank?

    posted  = transactions_count[:posted].to_i
    pending = transactions_count[:pending].to_i
    total   = posted + pending

    return 0 if total.zero?

    link_to(total, connection_transactions_path(account[:connection_id], account_id: account[:id]))
  end
end
