class AddHelloAssoNameToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :hello_asso_name, :string
    remove_column :subscriptions, :receipt_url, :string
  end
end
