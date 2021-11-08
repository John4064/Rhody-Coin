#John Parkhurst
#CREATE NATIVE ASSET
#Docs: https://developers.cardano.org/docs/native-tokens/minting
#Global Variables
tokenname1="Tidal"
tokenname2="Tidalstorm"
tokenamount="10000000"
output="0"
#ASSIGN ADDRESS
#address="addr_test1qpancyer75zhcpfvgme3nu0ts89464ss7smepnedxd0cjat3qrrhz7v39mu9dld5gppnxx6hsc6epnqpc3xyy37qjwhs9fye9v"
address="addr_test1vpfu25cj37xqg8u3ykn78xxw23yu68mmhjek74v6pwn4npqwtwf2l"
#TEST ADDRESS addr_test1vrlakq7nw35yvkwvj80e3faytylcw8cafcmqc4jkt5er89qjnkzm6
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
txhash="db2d6bdf5853ca50450b266072394f51186423aef21b8feb191729750a0773b2"
txix="0"
funds="120000000"
policyid=$(cat policy/policyID)
#Declare maximum fee
fee="300000"
cardano-cli transaction build-raw \
     --fee $fee \
     --tx-in $txhash#$txix \
     --tx-out $address+$output+"$tokenamount $policyid.$tokenname1 + $tokenamount $policyid.$tokenname2" \
     --mint="$tokenamount $policyid.$tokenname1 + $tokenamount $policyid.$tokenname2" \
     --minting-script-file policy/policy.script \
     --out-file matx.raw

