import urllib.request
import json
import os
import subprocess
import base64

token = 'nfc_Xewkc9LKzhduN5LbCnunfeSePiZgqbxh7858'
site_id = 'f78ee162-aa64-4368-9c75-34bd91a57764'
base_url = 'https://api.netlify.com/api/v1'
zip_path = 'C:\\Users\\Andrew\\Documents\\projets\\site-vitrine\\site-vitrine.zip'

# Create zip of the site
subprocess.run(['powershell', '-Command', f'Compress-Archive -Path "C:\\Users\\Andrew\\Documents\\projets\\site-vitrine\\*" -DestinationPath "{zip_path}" -Force'], capture_output=True)

with open(zip_path, 'rb') as f:
    zip_data = f.read()

headers = {
    'Authorization': f'Bearer {token}',
    'Content-Type': 'application/json',
    'User-Agent': 'site-vitrine'
}

deploy_data = json.dumps({
    'zip_base64': base64.b64encode(zip_data).decode(),
    'draft': False,
    'branch': 'main'
}).encode()

req = urllib.request.Request(f'{base_url}/sites/{site_id}/deploys', data=deploy_data, headers=headers, method='POST')
try:
    resp = urllib.request.urlopen(req, timeout=30)
    result = json.loads(resp.read().decode())
    print(json.dumps(result, indent=2))
except urllib.error.HTTPError as e:
    body = e.read().decode()
    print(f'Error {e.code}: {body}')
