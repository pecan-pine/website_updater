#!/bin/bash

# bash script to update website files if changed
# script dcmp-auto must be installed for this to work

# define folders
resume_dir=~/resume

resume_files_dir=~/resume/generated_resumes/resumes
input_dir="$resume_files_dir"/website

website_dir=~/pecan-pine.github.io
output_dir="$website_dir"/shared

pdf_file="$resume_files_dir"/programming/resume.pdf

echo "$input_dir"
echo "$output_dir"
echo "$pdf_file"

# pull changes into repositories
echo "Website pre-update running now..."

echo "pulling local changes into resume..."
cd "$resume_dir"
git pull

echo "pulling GitHub changes into website..."
cd "$website_dir"
git pull

echo "Website updater running now..."
