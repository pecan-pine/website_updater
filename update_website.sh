#!/bin/bash

# bash script to update website files if changed
# script dcmp-auto must be installed for this to work

# TODO: get a more descriptive automated commit message

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

echo -e "\033[0;32mpulling local changes into resume...\033[0m"
cd "$resume_dir"
git pull

echo -e "\033[0;32mpulling GitHub changes into website...\033[0m"
cd "$website_dir"
git pull

# website updating section
echo "Website updater running now..."

# use dcmp-auto to compare files. 
# if any differences are found, dcmp-auto copies all 
# files from input_dir to output_dir
echo "Comparing source files in $input_dir to those in $output_dir"
dcmp-auto "$input_dir" "$output_dir"

# dcmp-auto will output 0 if no changes, or
# will output 3 if there are changes
dcmp_result=$?

if [ $dcmp_result == 3 ]
then
    echo "Copying resume pdf to main site..."
    cp "$pdf_file" "$website_dir"/static/resume.pdf

    echo "Copying resume pdf to commandLine site..."
    cp "$pdf_file" "$website_dir"/commandLineSite/static/resume.pdf

    echo "Pushing website to GitHub..."
    cd "$website_dir"
    git add .
    # TODO: make this more specific
    git commit -m "Updated website files in response to resume update"
    # the -u may not be necessary below
    git push -u origin master

    echo "Making a pull request to pecan-pine version..."
    hub pull-request -h aquilegiataylor2:master -m "automatic pull request"
fi


echo "website updater is done"

