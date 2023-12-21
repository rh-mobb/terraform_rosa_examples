#!/bin/bash

# Function to run terraform apply in a directory and log the output
apply_terraform() {
    dir="$1"
    log_file="${dir}.log"

    echo "Applying Terraform in $dir..."
    cd "$dir" || exit 1

    # Run terraform apply and redirect output to a log file
    terraform apply -auto-approve -var create_vpc=true -var private_cluster=false -var admin_username=admin -var admin_password=Hell0OpenSh!ft123  &> "$log_file"

    # Check the exit status and print a message
    if [ $? -eq 0 ]; then
        echo "Terraform apply in $dir completed successfully."
    else
        echo "Error: Terraform apply in $dir failed. Check $log_file for details."
    fi

    cd - || exit 1
}

# Iterate over subdirectories containing the word "rosa" in parallel
for folder in $(ls | grep rosa); do
    # Run apply_terraform function in parallel for each subdirectory
    apply_terraform "$folder" &
done

# Wait for all background jobs to finish
wait

echo "All Terraform applies completed."

