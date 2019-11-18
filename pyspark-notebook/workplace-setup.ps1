# Install additional Python packages
pip install pyarrow --upgrade
pip install koalas --upgrade
pip install streamlit --upgrade
pip install pytest-cov --upgrade
pip install sphinx --upgrade
pip install requests-kerberos --upgrade
pip install yapf --upgrade

# Install and activate Jupyter extensions
pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
jupyter nbextensions_configurator enable --user
pip install RISE
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
wget https://gist.githubusercontent.com/simicd/20d40cae61305aecdf372c4ac0cffc4a/raw/082096fe90fd58095f84aab9030fa8a643713ec3/custom.css -OutFile custom.css
