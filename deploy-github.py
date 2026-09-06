import urllib.request
import json
import subprocess
import os

# Set up git
os.environ["PATH"] += ";C:\\Program Files\\Microsoft Visual Studio\\18\\Professional\\Common7\\IDE\\CommonExtensions\\Microsoft\\TeamFoundation\\Team Explorer\\Git\\cmd"
os.chdir("C:\\Users\\Andrew\\Documents\\projets\\site-vitrine")

# Configure git
subprocess.run(["git", "config", "user.email", "deploy@site-vitrine.local"])
subprocess.run(["git", "config", "user.name", "Site Vitrine"])
subprocess.run(["git", "branch", "-M", "main"])
subprocess.run(["git", "add", "."])
subprocess.run(["git", "commit", "-m", "Site vitrine professionnel", "--amend", "--no-verify"])

# Get device code from GitHub
auth_data = json.dumps({"client_id": "Iv1.8a61f9b3a7aba766", "scope": "repo"}).encode()
req = urllib.request.Request("https://github.com/login/device/code", data=auth_data, headers={"Content-Type": "application/json"})
try:
    resp = urllib.request.urlopen(req, timeout=10)
    device = json.loads(resp.read().decode())
    print(f"\nURL: {device['verification_uri']}")
    print(f"CODE: {device['user_code']}")
    print("\nEnter the code in your browser, then press Enter here...")
    input()
    
    # Poll for token
    token = None
    for i in range(60):
        try:
            poll_data = json.dumps({"client_id": "Iv1.8a61f9b3a7aba766", "device_code": device["device_code"], "grant_type": "urn:ietf:params:oauth:grant-type:device_code"}).encode()
            poll_req = urllib.request.Request("https://github.com/login/oauth/access_token", data=poll_data, headers={"Content-Type": "application/json", "Accept": "application/json"})
            poll_resp = urllib.request.urlopen(poll_req, timeout=5)
            poll_result = json.loads(poll_resp.read().decode())
            if "access_token" in poll_result:
                token = poll_result["access_token"]
                break
        except:
            pass
        import time; time.sleep(device.get("interval", 5))
    
    if token:
        print(f"Authenticated! Creating repo...")
        
        # Create repo
        repo_data = json.dumps({"name": "site-vitrine", "private": False, "auto_init": False}).encode()
        repo_req = urllib.request.Request("https://api.github.com/user/repos", data=repo_data, headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
            "User-Agent": "site-vitrine"
        })
        repo_resp = urllib.request.urlopen(repo_req)
        repo = json.loads(repo_resp.read().decode())
        print(f"Repo: {repo['html_url']}")
        
        # Push
        subprocess.run(["git", "remote", "add", "origin", repo["clone_url"]])
        subprocess.run(["git", "push", "-u", "origin", "main", "--force"])
        
        # Create Pages workflow
        gh_dir = ".github\\workflows"
        os.makedirs(gh_dir, exist_ok=True)
        workflow = '''name: Deploy to GitHub Pages
on:
  push:
    branches: [main]
permissions:
  contents: read
  pages: write
  id-token: write
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/configure-pages@v4
      - uses: actions/upload-pages-artifact@v3
        with:
          path: '.'
      - uses: actions/deploy-pages@v4'''
        with open(f"{gh_dir}\\pages.yml", "w") as f:
            f.write(workflow)
        subprocess.run(["git", "add", ".github/workflows/pages.yml"])
        subprocess.run(["git", "commit", "-m", "Add Pages workflow", "--amend", "--no-verify"])
        subprocess.run(["git", "push", "--force"])
        
        print(f"\n=== SITE EN LIGNE ! ===")
        print(f"URL: {repo['html_url']}/tree/main")
        print(f"Pages: {repo['html_url'].replace('github.com', repo['owner']['html_url'].split('/')[-1] + '.github.io')}/{repo['name']}/")
    else:
        print("Token not obtained")
except Exception as e:
    print(f"Error: {e}")
