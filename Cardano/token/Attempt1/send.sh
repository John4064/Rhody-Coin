#here we send our new token
tokenname1="Mortal"
tokenname2="Egg"
tokenamount="10000000"
output="0"
fee="0"
#policy
policyid="5ebbe5b2f2f9a48967a7b693853fb4f2242a7726385c4b648490d1a3"
address="addr_test1vz57ayz826d0mhyjfxjhkxmzf3j0l73k4k94t4zsszmzelckks6vu"
receiver="addr_test1qzxzqwyl9krmcrey4dk8jmgw5tqpz5z4sq6f60eg6l3aj3n3qrrhz7v39mu9dld5gppnxx6hsc6epnqpc3xyy37qjwhshjnmjq"
receiver_output="10000000"
#CHECK Txhash and funds every transaction
txhash="39967f3232b6333f647dc48b25ce627eabed7087cf8775a2cb439bb282296df6"
txix="0"
funds="16000000"
#NOW THAT THE 10000 Variables are complete
cardano-cli transaction build-raw  \
--fee $fee  \
--tx-in $txhash#$txix  \
--tx-out $receiver+$receiver_output+"50000 $policyid.$tokenname1"  \
--tx-out $address+$output+"9900000 $policyid.$tokenname1 + 9950000 $policyid.$tokenname2"  \
--out-file rec_matx.raw

fee=$(cardano-cli transaction calculate-min-fee --tx-body-file rec_matx.raw --tx-in-count 1 --tx-out-count 2 --witness-count 1 --testnet-magic 1097911063 --protocol-params-file protocol.json | cut -d " " -f1)
output=$(expr $funds - $fee - 10000000)

cardano-cli transaction build-raw  \
--fee $fee  \
--tx-in $txhash#$txix  \
--tx-out $receiver+$receiver_output+"50000 $policyid.$tokenname1"  \
--tx-out $address+$output+"9900000 $policyid.$tokenname1 + 9950000 $policyid.$tokenname2"  \
--out-file rec_matx.raw

cardano-cli transaction sign --signing-key-file payment.skey --testnet-magic 1097911063 --tx-body-file rec_matx.raw --out-file rec_matx.signed
cardano-cli transaction submit --tx-file rec_matx.signed --testnet-magic 1097911063