# run all test, it generates files in the test/files directory
cd ..
mix test
# run the python script to validate the generated files
cd test/files
output=$(python3 validate.py)



# Check if the output contains the first string
if echo "$output" | grep -q '<Element {http://uri.etsi.org/01903/v1.1.1#}SignatureContent'; then
    echo "Found SignatureContent"
else
    echo "SignatureContent not found"
fi

# Check if the output contains the second string
if echo "$output" | grep -q '<Element {http://uri.etsi.org/01903/v1.3.2#}SignedProperties'; then
    echo "Found SignedProperties"
else
    echo "SignedProperties not found"
fi


