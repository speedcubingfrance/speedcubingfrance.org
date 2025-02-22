class UpdateSubscriptionsSchema < ActiveRecord::Migration[6.1]
  def change
    # Unlike its name may suggest, 'order_number' is not unique: multiple rows
    # may have been bought in the same order.
    add_column :subscriptions, :order_number, :bigint
    add_index :subscriptions, :order_number
    add_index :subscriptions, :payed_at

    reversible do |dir|
      dir.up do
        special_promo = {
          "LOGO-ZEFZE": 58535181,
          "LOGO-AZDOA": 49894999,
          "LOGO-AODJO": 79029039,
          "LOGO-PAKJP": 65388554,
        }
        # This is highly inefficient, but luckily we don't have *that many*
        # subscriptions, and it's necessary because we didn't have clean
        # identifiers until now.
        Subscription.all.each do |sub|
          if sub.receipt_url.start_with?("https")
            sub.update(order_number: sub.receipt_url.sub("https://www.helloasso.com/associations/association-francaise-de-speedcubing/adhesions/adhesions-2016/paiement-attestation/", "").to_i)
          else
            sub.update(order_number: special_promo[sub.receipt_url.to_sym] || 0)
          end
        end
      end
      # No down, we just delete the column.
    end
  end
end
