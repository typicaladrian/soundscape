#!/bin/bash
# BE SURE TO SET END OF LINE SEQUENCE TO LF, NOT CRLF
# run . ./export_env_variables.sh
if [ -f .env/.env ]; then
    while IFS= read -r line; do
        if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
            eval export "$line"
            echo "Exported: $line"
        fi
    done < .env/.env
else
    echo ".env file not found."
fi
