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

  def status_label(status)
    class_name  = case status
                  when 'active'
                    'success'
                  when 'inactive'
                    'secondary'
                  when 'fail'
                    'danger'
                  else
                    'info'
                  end

    "<span class=\"badge badge-#{class_name}\">#{status}</span>".html_safe
  end

  def connection_title(connection)
    return connection[:provider_name] unless connection[:status] == 'active'

    link_to connection[:provider_name], connection_accounts_path(connection[:id])
  end
end
