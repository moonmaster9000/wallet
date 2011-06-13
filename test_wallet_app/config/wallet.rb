puts "about to configure wallet!"

Wallet.open do
  cash :home do
    index
  end
end
