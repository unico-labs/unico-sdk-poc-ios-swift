import requests
from bs4 import BeautifulSoup
import re
import subprocess
import os

# ===============================
# Settings
# ===============================
URL = "https://devcenter.unico.io/idcloud/integracao/sdk/integracao-sdks/sdk-ios/release-notes"
DEPENDENCY = "unicocheck-ios"
FILE_TO_UPDATE = "Podfile"
REPO_PATH = "." 

# ===============================
# 1️⃣ Buscar versão + data no site
# ===============================
print("🔎 Fetching latest version from Unico's release notes...")
response = requests.get(URL)
soup = BeautifulSoup(response.text, "html.parser")

divs = soup.find_all("div") # Busca todas as divs para encontrar a que tem a versão
site_version = None
release_date = None

# Regex para encontrar o padrão "Versão X.X.X - DD/MM/YYYY"
version_pattern = re.compile(r"Versão\s*([\d.]+)\s*-\s*(\d{2}/\d{2}/\d{4})")

for div in divs:
    text_content = div.get_text(strip=True)
    match = version_pattern.search(text_content)
    if match:
        site_version = match.group(1)
        release_date = match.group(2)
        # Encontrou a versão mais recente (geralmente a primeira que aparece), então para a busca
        break

if not site_version:
    print("❌ Could not capture the version from the website. Check the HTML structure.")
    exit(1)

print(f"📦 Latest version on the website: {site_version}")
print(f"🗓️ Release date: {release_date}")


# ===============================
# 2️⃣ Ler Podfile do repo alvo
# ===============================
podfile_path = os.path.join(REPO_PATH, FILE_TO_UPDATE)
if not os.path.exists(podfile_path):
    print(f"❌ {FILE_TO_UPDATE} not found in the path: {podfile_path}")
    exit(1)

with open(podfile_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

current_version = None
# Regex para encontrar a versão atual no Podfile
current_version_pattern = re.compile(r"pod\s+'" + re.escape(DEPENDENCY) + r"',\s+'([\d\.]+)'")

for line in lines:
    match = current_version_pattern.search(line)
    if match:
        current_version = match.group(1)
        break

if not current_version:
    print(f"❌ Could not find the dependency '{DEPENDENCY}' in your {FILE_TO_UPDATE}.")
    exit(1)

print(f"📂 Current version in {FILE_TO_UPDATE}: {current_version}")

# ===============================
# 3️⃣ Atualizar se necessário
# ===============================
if current_version != site_version:
    print(f"⬆️ New version found! Updating from {current_version} to {site_version}.")
    
    new_lines = []
    for line in lines:
        # Substitui a versão antiga pela nova na linha correspondente
        if current_version_pattern.search(line):
            new_line = re.sub(r"'([\d\.]+)'", f"'{site_version}'", line)
            new_lines.append(new_line)
        else:
            new_lines.append(line)

    with open(podfile_path, "w", encoding="utf-8") as f:
        f.writelines(new_lines)

    print(f"✅ Updated {DEPENDENCY} to version {site_version} in {FILE_TO_UPDATE}")

    # --- Automação Git e GitHub ---
    branch = f"chore/update-{DEPENDENCY}-v{site_version}"
    tag = f"v{site_version}"
    commit_message = f"chore: bump {DEPENDENCY} to v{site_version}"

    print("🤖 Starting Git automation...")
    subprocess.run(["git", "checkout", "-b", branch], check=True)
    subprocess.run(["git", "config", "user.name", "github-actions"], check=True)
    subprocess.run(["git", "config", "user.email", "github-actions@github.com"], check=True)
    subprocess.run(["git", "add", FILE_TO_UPDATE], check=True)
    subprocess.run(["git", "commit", "-m", commit_message], check=True)
    subprocess.run(["git", "push", "origin", branch], check=True)

    tag_message = f"Release {DEPENDENCY} {site_version} ({release_date})"
        
    subprocess.run(["git", "tag", "-a", tag, "-m", tag_message], check=True)
    subprocess.run(["git", "push", "origin", tag], check=True)

    pr_body = f"""
    ### 🚀 Automatic Update
    Bumps `{DEPENDENCY}` from `{current_version}` to version **{site_version}**.
    
    - 📅 **Release date**: {release_date}
    - 🔗 **Official Release Notes**: [{URL}]({URL})
    """

    subprocess.run([
        "gh", "pr", "create",
        "--title", commit_message,
        "--body", pr_body,
        "--head", branch,
        "--base", "main" # Altere 'main' para sua branch principal se for outra
    ], check=True)

    print(f"🎉 Successfully created branch, tag, and Pull Request for version {site_version}!")

else:
    print("🔄 Already at the latest version, nothing to do.")