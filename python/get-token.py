import requests

# Define the URL and the headers
url = 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net"'
headers = {
    'Metadata': 'true'
}

# Perform the GET request
response = requests.get(url, headers=headers)

# Store the result in a variable
result = response.text

# Print the result to verify
print(result)

json_response = response.json()
# Access the 'access_token' field from the JSON response
access_token = json_response.get('access_token', 'Access token not found')
print(access_token)