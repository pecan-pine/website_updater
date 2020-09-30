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

echo -e "\033[0;32mpulling local changes into resume...\033[0m"
cd "$resume_dir"
git pull

echo -e "\033[0;32mreading commit message...\033[0m"
# get commit hash and previous commit hash
commit="$(git log --format=%h -n 1)"
prev_commit="$(git log --format=%p -n 1)"
commiter_name="$(git log --format=%cn -n 1)"
commiter_email="$(git log --format=%ce -n 1)"
commit_date="$(git log --date=format:%c --format=%ad -n 1)"
commit_message="$(git log --format=%B -n 1)"

# create new commit message
message="Updated resume-related files in website in response to commit #$commit in pecan-pine/resume repository at $commit_date by $commiter_name ($commiter_email). 

The message for this commit was: 
'$commit_message'

Compare changes made here: https://github.com/pecan-pine/resume/compare/$prev_commit...$commit

This message was automatically generated."

# pull changes into website repository
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
    git commit -m "$message"
    # the -u may not be necessary below
    git push -u origin master

    echo "Making a pull request to pecan-pine version..."
    hub pull-request -h aquilegiataylor2:master -m "automatic pull request"
fi


echo "website updater is done"

