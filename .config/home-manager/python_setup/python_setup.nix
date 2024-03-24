{ pkgs }:
pkgs.writeShellScriptBin "python_setup" ''
echo "Setting everything up..." | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat

# Deleting commonly used virtual environment names
rm -rf env
rm -rf venv
rm -rf .venv
rm -rf .env

# Virtual environment inside the project root:
${pkgs.poetry}/bin/poetry config virtualenvs.in-project true

# Init poetry if it isn't already:
if [ -f pyproject.toml ]; then
  echo "Poetry already initialized."
else
  ${pkgs.poetry}/bin/poetry init -n
fi

# Copy over the configuration files:
cp ${./.flake8} ./.flake8
cp ${./.pre-commit-config.yaml} ./.pre-commit-config.yaml

# Create venv manually:
python -m venv .venv
poetry env use ./.venv/bin/python

# Add test dependencies:
${pkgs.poetry}/bin/poetry add pytest pytest-cov --group test

# Add development dependencies:
${pkgs.poetry}/bin/poetry add flake8 black pre-commit --group development

${pkgs.poetry}/bin/poetry install --no-root

# Check for .git, init if not present.
if [ -d ./.git ]; then
  echo "Already a GIT repository."
else
  git init
fi

${pkgs.poetry}/bin/poetry run pre-commit install
${pkgs.poetry}/bin/poetry run pre-commit install --hook-type commit-msg

echo "All set! You are good to go. Enjoy your journey!"

''
