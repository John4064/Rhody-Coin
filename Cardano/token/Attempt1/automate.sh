#John Parkhurst
#CREATE NATIVE ASSET
#Docs: https://developers.cardano.org/docs/native-tokens/minting
#Global Variables
tokenname1="Mortal"
#tokenname2="Egg"
tokenamount="30000000"
output="0"
#ASSIGN ADDRESS
#Generate Address and fill this in
address="addr_test1vz57ayz826d0mhyjfxjhkxmzf3j0l73k4k94t4zsszmzelckks6vu"
#Your Address
receiver="addr_test1qzxzqwyl9krmcrey4dk8jmgw5tqpz5z4sq6f60eg6l3aj3n3qrrhz7v39mu9dld5gppnxx6hsc6epnqpc3xyy37qjwhshjnmjq"
#Checking Node Stats
#Alonzo Era
#cardano-cli query tip --testnet-magic 1097911063
#Make sure acc has funds
cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json
#GENERATE POLICIES
cardano-cli address key-gen \
    --verification-key-file policy/policy.vkey \
    --signing-key-file policy/policy.skey
echo "KEY GEN COMPLETE NOW"
#Create Empty Policy Script
touch policy/policy.script && echo "" > policy/policy.script
#Fill to script
echo "{" >> policy/policy.script
echo "  \"keyHash\": \"$(cardano-cli address key-hash --payment-verification-key-file policy/policy.vkey)\"," >> policy/policy.script
echo "  \"type\": \"sig\"" >> policy/policy.script
echo "}" >> policy/policy.script
#We Now have a script that defines policy verification key
#To sign minting transactions!
echo "Policy Script is complete"
#Asset Minting saves to policyID
cardano-cli transaction policyid --script-file ./policy/policy.script >> policy/policyID
#Build Raw Transaction
#DECLARE THE VALUES found in console
txhash="dd5d3f336a7f1ddd6437dac03bf8ce71375eae6366df2643a582b1bbb731bd6a"
txix="0"
funds="25000000"
policyid=$(cat policy/policyID)
#Declare maximum fee
fee="300000"
echo "Building the raw minting transaction now!"
cardano-cli transaction build-raw \
     --fee $fee \
     --tx-in $txhash#$txix \
     --tx-out $address+$output+"$tokenamount $policyid.$tokenname1 + $tokenamount $policyid.$tokenname2" \
     --mint="$tokenamount $policyid.$tokenname1 + $tokenamount $policyid.$tokenname2" \
     --minting-script-file policy/policy.script \
     --out-file matx.raw
#Rebuilding the output based on the fee
fee=$(cardano-cli transaction calculate-min-fee --tx-body-file matx.raw --tx-in-count 1 --tx-out-count 1 --witness-count 2 --testnet-magic 1097911063 --protocol-params-file protocol.json | cut -d " " -f1)
output=$(expr $funds - $fee)
cardano-cli transaction build-raw \
--fee $fee  \
--tx-in $txhash#$txix  \
--tx-out $address+$output+"$tokenamount $policyid.$tokenname1 + $tokenamount $policyid.$tokenname2" \
--mint="$tokenamount $policyid.$tokenname1 + $tokenamount $policyid.$tokenname2" \
--minting-script-file policy/policy.script \
--out-file matx.raw
#Now that transaction is made, we sign off on it with our key!
cardano-cli transaction sign  \
--signing-key-file payment.skey  \
--signing-key-file policy/policy.skey  \
--testnet-magic 1097911063 --tx-body-file matx.raw  \
--out-file matx.signed
echo "Signing and Building Worked! Now Submitting!"
#Submit Transaction
cardano-cli transaction submit --tx-file matx.signed --testnet-magic 1097911063
cardano-cli query utxo --address $address --testnet-magic 1097911063
#Send to Wallet!
