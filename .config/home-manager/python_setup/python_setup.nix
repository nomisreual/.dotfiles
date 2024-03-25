{ pkgs }:
pkgs.writeShellScriptBin "python_setup" ''
echo "Setting everything up..." | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat

# Deleting commonly used virtual environment names
rm -rf env
rm -rf venv
rm -rf .venv
rm -rf .env

poetry config virtualenvs.in-project true

# Init poetry if it isn't already:
if [ -f pyproject.toml ]; then
  echo "Poetry already initialized."
else
  echo "Initializing poetry..."
    poetry init -n
  echo "Poetry initialized."
fi


# Get the Python version string
python_version_output=$(python --version 2>&1)

# Extract the version number using awk
version=$(awk '{print $2}' <<< "$python_version_output")

# Extract major and minor version parts
major_minor=$(cut -d '.' -f 1,2 <<< "$version")

# Form the desired version string
python_version="^$major_minor"

sed -i "s/python = \".*\"/python = \"$python_version\"/g" pyproject.toml

# Copy over the configuration files:
echo "Copying over configuration files..."

# Flake8
if [ -f ./.flake8 ]; then
  echo ".flake8 already exists."
else
  echo "Copying .flake8..."
  cp ${./.flake8} ./.flake8
fi

# Pre-commit-config
PRECOMMIT="pre-commit-config.yaml"

if [ -f "$PRECOMMIT" ] || [ -f ".$PRECOMMIT" ]; then
  echo "A pre-commit config file already exists."
else
  echo "Copying .pre-commit-config.yaml..."
  cp ${./.pre-commit-config.yaml} ./.pre-commit-config.yaml
fi

# Gitignore
if [ -f ./.gitignore ]; then
  echo ".gitignore already exists."
else
  echo "Copying .gitignore..."
  cp ${./.gitignore} ./.gitignore
fi

# Add test dependencies:
poetry add pytest pytest-cov --group test

# Add development dependencies:
poetry add flake8 black pre-commit --group development

# Check for .git, init if not present.
if [ -d ./.git ]; then
  echo "Already a GIT repository."
else
  git init
fi

poetry run pre-commit install
poetry run pre-commit install --hook-type commit-msg

if [ -f README.md ]; then
  echo "README.md already exists."
else
  touch README.md
fi

echo "All set! You are good to go. Enjoy your journey!"

''
