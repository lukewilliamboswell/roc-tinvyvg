find . -type f -name "*.roc" -exec bash -c 'roc format "$0"' {} \;
