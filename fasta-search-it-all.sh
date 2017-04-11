#!/bin/bash
#
# This small tool search all fasta files for matching indexes.
# 
# Usage:
#   fasta-search-it-all.sh <index-file> <fasta-files> ...
#
# Author:
#   Guowei HE <gh50@nyu.edu>
#

fasta-search-one() {
  local idx="$1"
  local ffile="$2"
  if [[ ! -f "${ffile}" ]]; then
    echo "${ffile} does not exist."
    exit 1
  fi
  
  # Notice the >
  awk -v idx="^>$idx\$" '$0~idx{print $idx;flag=1;next}/>/{flag=0}flag' "${ffile}"
}

fasta-search-it-all() {
  # Examine input
  if [[ "$#" -lt 2 ]]; then
    echo "Usage: fasta-search-it-all.sh <index-file> <fasta-files> ..."
    exit 1
  fi
  local index_file="$1"
  local fasta_files="${@:2}"
  if [[ ! -f "${index_file}" ]]; then
    echo "${index_file} does not exists."
    exit 1
  fi

  # Loop over all indexes
  for index in `cat "${index_file}" | xargs`; do
  # Loop over all fasta files
    for fasta_file in ${fasta_files}; do
      fasta-search-one "${index}" "${fasta_file}"
    done
  done
}

fasta-search-it-all "$@"
