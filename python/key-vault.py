# See https://techcommunity.microsoft.com/t5/apps-on-azure-blog/how-to-connect-azure-key-vault-from-python-app-service-using/ba-p/4088152

from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

KEY_VAULT_URL = "https://kvt-demo-01.vault.azure.net/"

credential = DefaultAzureCredential()

# Get secret from Azure Key Vault
secret_name = "SuperSecret"
secret_client = SecretClient(vault_url=KEY_VAULT_URL, credential=credential)
retrieved_secret = secret_client.get_secret(secret_name)
print(f"The secret value is: {retrieved_secret.value}")

