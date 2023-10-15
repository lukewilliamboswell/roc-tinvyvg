#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

roc='./roc_nightly/roc'

examples_dir='./examples/'

# roc check
for roc_file in $examples_dir*.roc; do
    $roc check $roc_file
done

# roc build
for roc_file in $examples_dir*.roc; do
    $roc build $roc_file
done

# NOT USED
# # check output
# for roc_file in $examples_dir*.roc; do
#     roc_file_only="$(basename "$roc_file")"
#     no_ext_name=${roc_file_only%.*}
#     expect ci/expect_scripts/$no_ext_name.exp
# done

# test building docs website
$roc docs package/main.roc