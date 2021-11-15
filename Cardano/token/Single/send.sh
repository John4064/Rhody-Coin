
tokenname1="Rhody"
tokenamount="30000000"
output="0"
fee="0"
#policy
policyid="7e4c732038d1df3e926c554b4a3836269c074c341a60b18a6721e66e"
address="addr_test1vqf2qq7lqf0mzmssqgvhtmjsqxvsjl5yzk9ejdyan8524lqyvufxm"
receiver="addr_test1qzxzqwyl9krmcrey4dk8jmgw5tqpz5z4sq6f60eg6l3aj3n3qrrhz7v39mu9dld5gppnxx6hsc6epnqpc3xyy37qjwhshjnmjq"
receiver_output="10000000"
#CHECK Txhash and funds every transaction
txhash="78aa49fea93307783103e6860bfc7101bbfc0d65ff8a47eea8b729cb36df50aa"
txix="0"
funds="24818219"
#NOW THAT THE 10000 Variables are complete
cardano-cli transaction build-raw  \
--fee $fee  \
--tx-in $txhash#$txix  \
--tx-out $receiver+$receiver_output+"30000000 $policyid.$tokenname1"  \
--tx-out $address+$output+"0 $policyid.$tokenname1"  \
--out-file rec_matx.raw

fee=$(cardano-cli transaction calculate-min-fee --tx-body-file rec_matx.raw --tx-in-count 1 --tx-out-count 2 --witness-count 1 --testnet-magic 1097911063 --protocol-params-file protocol.json | cut -d " " -f1)
output=$(expr $funds - $fee - 10000000)

cardano-cli transaction build-raw  \
--fee $fee  \
--tx-in $txhash#$txix  \
--tx-out $receiver+$receiver_output+"30000000 $policyid.$tokenname1"  \
--tx-out $address+$output+"0 $policyid.$tokenname1"  \
--out-file rec_matx.raw

cardano-cli transaction sign --signing-key-file payment.skey --testnet-magic 1097911063 --tx-body-file rec_matx.raw --out-file rec_matx.signed
cardano-cli transaction submit --tx-file rec_matx.signed --testnet-magic 1097911063