# Install additional Python packages
pip install pyarrow==0.17.0
pip install koalas==0.32.0
pip install pandas==0.25.3
pip install streamlit==0.59.0
pip install pytest-cov==2.8.1
pip install sphinx==3.0.3
pip install sphinx-autodoc-typehints==1.10.3
pip install sphinx_rtd_theme==0.4.3
pip install pydata-sphinx-theme==0.2.2
pip install requests-kerberos==0.12.0
pip install yapf==0.30.0
pip install pydot==1.4.1
pip install graphviz==0.14
pip install cookiecutter==1.7.2
pip install azure-functions==1.2.1

# Install JupyterLab
pip install jupyterlab==2.1.2
npm install -g jupyterlab-tailwind-theme

# Install and activate Jupyter extensions
pip install jupyter_contrib_nbextensions==0.5.1
jupyter contrib nbextension install --user
jupyter nbextensions_configurator enable --user
pip install rise==5.6.1
jupyter-nbextension enable rise --py --user
jupyter-nbextension enable collapsible_headings/main --user
jupyter-nbextension enable scratchpad/main --user
jupyter-nbextension enable hide_input_all/main --user
jupyter-nbextension enable hide_input/main --user
jupyter-nbextension enable comment-uncomment/main --user
jupyter-nbextension enable code_prettify/code_prettify --user
jupyter-nbextension enable toc2/main --user

# Add custom styling for Jupyter notebook - create folder, change to that folder and download custom.css from GitHub gist
mkdir $env:USERPROFILE/.jupyter/custom
cd $env:USERPROFILE/.jupyter/custom
Invoke-WebRequest -Uri https://gist.githubusercontent.com/simicd/20d40cae61305aecdf372c4ac0cffc4a/raw/9e0c167ccf86fc3c66644a90da5c6ad80a6bb4f2/custom.css -OutFile "custom.css"

# Add VS Code settings file
mkdir $env:USERPROFILE/AppData/Roaming/Code/User
cd $env:USERPROFILE/AppData/Roaming/Code/User
Invoke-WebRequest -Uri https://gist.githubusercontent.com/simicd/7bb64dad99699451264b983e6a671eac/raw/2e3db5ecd9a53257972d233a6ab5e544c8b44db3/settings.json -OutFile "settings.json"

# Change back to user folder
cd $env:USERPROFILE
