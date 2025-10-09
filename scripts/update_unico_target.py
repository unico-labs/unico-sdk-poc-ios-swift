import requests
from bs4 import BeautifulSoup
import re
import subprocess
import os
import textwrap
import time

# ===============================
# Settings
# ===============================
URL = "https://devcenter.unico.io/idcloud/integracao/sdk/integracao-sdks/sdk-ios/release-notes"
DEPENDENCY = "unicocheck-ios"
FILE_TO_UPDATE = "Podfile"

# -------------------------------
# Determinar script_dir / REPO_PATH
# -------------------------------
try:
    # Quando executado como script .py, __file__ existe
    script_dir = os.path.dirname(os.path.abspath(__file__))
except NameError:
    # Em notebooks (Jupyter) __file__ não existe — usamos o cwd como fallback
    script_dir = os.getcwd()

# Permite sobrescrever o caminho do repo via variável de ambiente REPO_PATH (opcional)
REPO_PATH = os.environ.get("REPO_PATH", os.path.abspath(os.path.join(script_dir, '..')))

print(f"Using script_dir: {script_dir}")
print(f"Using REPO_PATH: {REPO_PATH}")

# ===============================
# Step 1: Fetch version, date and release notes from the website
# ===============================
print("🔎 Fetching latest version from Unico's iOS release notes...")
response = requests.get(URL)
soup = BeautifulSoup(response.text, "html.parser")

site_version = None
release_date = None
release_notes = []

# Regex para versão/data
version_pattern = re.compile(r"Versão\s*([\d.]+)\s*-\s*(\d{2}/\d{2}/\d{4})", re.I)

# Encontrar a div que contém "Versão X.Y.Z - DD/MM/YYYY"
header_div = None
for div in soup.find_all("div"):
    text = div.get_text(" ", strip=True)
    if "Versão" in text:
        m = version_pattern.search(text)
        if m:
            header_div = div
            site_version = m.group(1)
            release_date = m.group(2)
            break

if not header_div:
    print("❌ Could not capture the version from the website. Check the HTML structure.")
    exit(1)

print(f"📦 Latest version on the website: {site_version}")
print(f"🗓️ Release date: {release_date}")

# Procurar a primeira <ul> após o header_div cuja classe contenha 'space-y-2'
notes_block = None
for elem in header_div.next_elements:
    if getattr(elem, "name", None) == "ul":
        classes = elem.get("class", []) or []
        if any("space-y-2" in c for c in classes):
            notes_block = elem
            break

# Fallback: procurar dentro do pai (caso esteja aninhado)
if not notes_block:
    parent = header_div.find_parent()
    if parent:
        notes_block = parent.find("ul", class_=lambda x: x and "space-y-2" in x)

# Extrair notas
if notes_block:
    for li in notes_block.find_all("li"):
        p = li.find("p")
        if p:
            text = p.get_text(" ", strip=True)
            if text:
                release_notes.append(text)

if release_notes:
    print("\n📝 Release notes found:")
    for note in release_notes:
        print(f"- {note}")
else:
    print("⚠️ No release notes found on the page (tried next-elements and parent fallback).")

# ===============================
# Step 2: Read Podfile from the target repository
# ===============================
podfile_path = os.path.join(REPO_PATH, FILE_TO_UPDATE)
if not os.path.exists(podfile_path):
    print(f"❌ {FILE_TO_UPDATE} not found in the path: {podfile_path}")
    exit(1)

with open(podfile_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

current_version = None
# Regex para encontrar a versão atual no Podfile (aceita ' ou ")
current_version_pattern = re.compile(
    r"pod\s+['\"]" + re.escape(DEPENDENCY) + r"['\"],\s*['\"]([\d\.]+)['\"]",
    re.I
)

for line in lines:
    m = current_version_pattern.search(line)
    if m:
        current_version = m.group(1)
        break

if not current_version:
    print(f"❌ Could not find the dependency '{DEPENDENCY}' in your {FILE_TO_UPDATE}.")
    exit(1)

print(f"📂 Current version in {FILE_TO_UPDATE}: {current_version}")

# ===============================
# Step 3: Update dependency if necessary
# ===============================
if current_version != site_version:
    print(f"⬆️ New version found! Updating from {current_version} to {site_version}...")

    pattern_version_only = re.compile(
        r"(pod\s+['\"]unicocheck-ios['\"].*?,\s*['\"])([\d.]+)(['\"])",
        re.I
    )

    new_lines = []
    for line in lines:
        if pattern_version_only.search(line):
            new_line = pattern_version_only.sub(site_version, line, count=1)
            new_lines.append(new_line)
        else:
            new_lines.append(line)

    with open(podfile_path, "w", encoding="utf-8") as f:
        f.writelines(new_lines)

    print(f"✅ Updated {DEPENDENCY} to version {site_version} in {FILE_TO_UPDATE}")

    branch = f"update-{DEPENDENCY}-v{site_version}"
    tag = f"{DEPENDENCY}-v{site_version}"

    rel_path = os.path.relpath(podfile_path, REPO_PATH)

    timestamp = int(time.time())
    branch = f"update-{DEPENDENCY}-v{site_version}-{timestamp}"
    tag = f"{DEPENDENCY}-v{site_version}"

    # Git commands executados no REPO_PATH
    subprocess.run(["git", "checkout", "-b", branch], check=True, cwd=REPO_PATH)
    subprocess.run(["git", "config", "user.name", "github-actions"], check=True, cwd=REPO_PATH)
    subprocess.run(["git", "config", "user.email", "github-actions@github.com"], check=True, cwd=REPO_PATH)
    subprocess.run(["git", "add", rel_path], check=True, cwd=REPO_PATH)
    subprocess.run(["git", "commit", "-m", f"chore: bump {DEPENDENCY} to v{site_version}"], check=True, cwd=REPO_PATH)
    subprocess.run(["git", "push", "origin", branch], check=True, cwd=REPO_PATH)

    subprocess.run(["git", "tag", "-a", tag, "-m", f"Release {DEPENDENCY} {site_version} ({release_date})"], check=True, cwd=REPO_PATH)
    subprocess.run(["git", "push", "origin", tag], check=True, cwd=REPO_PATH)

    if release_notes:
        notes_formatted = "\n".join([f"- {n}" for n in release_notes])
    else:
        notes_formatted = "_No release notes available_"

    body = textwrap.dedent(f"""
    Automatic update of `{DEPENDENCY}` to version **{site_version}**

    **Release date:** {release_date}
    🔗 Official Release Notes: {URL}

    **Changelog:**
    {notes_formatted}
    """).strip()

    pr_process = subprocess.run([
        "gh", "pr", "create",
        "--title", f"Update {DEPENDENCY} to v{site_version}",
        "--body", body,
        "--head", branch
    ], check=True, capture_output=True, text=True, cwd=REPO_PATH)

    pr_url = pr_process.stdout.strip()
    print(f"✅ Pull Request created: {pr_url}")

    if "GITHUB_OUTPUT" in os.environ:
        with open(os.environ["GITHUB_OUTPUT"], "a") as f:
            print(f"updated=true", file=f)
            print(f"new_version={site_version}", file=f)
            print(f"release_date={release_date}", file=f)
            print(f"pr_url={pr_url}", file=f)

else:
    print("🔄 Already at the latest version, nothing to do.")
    if "GITHUB_OUTPUT" in os.environ:
        with open(os.environ["GITHUB_OUTPUT"], "a") as f:
            print(f"updated=false", file=f)
