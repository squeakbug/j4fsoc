# This default.nix builds a tarball containing a library archive and some manpages.  
# Likely to only work on linux.
#
# Just run 'nix-build' and fish the tarball out of 'result/'.
#
# To update the Nixpkgs snapshot (which also includes tooling), use:
#
#  $ niv update nixpkgs -b master
#