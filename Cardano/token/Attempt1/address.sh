#The Address
cardano-cli address key-gen --verification-key-file payment.vkey --signing-key-file payment.skey
cardano-cli address build --payment-verification-key-file payment.vkey --out-file payment.addr --testnet-magic 1097911063
address=$(cat payment.addr)
echo $address
#Here we put out the txhash
cardano-cli query utxo --address $address --testnet-magic 1097911063
