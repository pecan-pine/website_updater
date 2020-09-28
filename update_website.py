#!/usr/bin/python3
import os

print("Python website updater running now...")
# TODO: get a more descriptive automated commit message 
# (before, I parsed a webhook, so this was easy. There is 
# probably an easy way to do it.)

def update_website(commit_message):
    resume_dir = '../resume'
    input_dir = resume_dir + '/generated_resumes/resumes/website'
    website_dir = '../pecan-pine.github.io'
    output_dir = website_dir + '/shared'
    pdf_file = resume_dir + '/generated_resumes/resumes/programming/resume.pdf'    

    # print(os.system(f"cd { resume_dir }; git pull;"))
    # print(os.system(f"cd { website_dir }; git pull;"))

    input_files = os.listdir(input_dir)
    print(input_files)
    print(os.listdir(output_dir))


    for f in input_files:
        print(f"Copying file {f}...")
        os.system(f"cp { input_dir }/{f} {output_dir}/{f}")

    print(f"Copying resume pdf to main site")
    os.system(f"cp { pdf_file } { website_dir }/static/resume.pdf")

    print(f"Copying resume pdf to commandLine site")
    os.system(f"cp { pdf_file } { website_dir }/commandLineSite/static/resume.pdf")

    print(os.system(f"cd { website_dir }; git add .; git commit -m \"{ commit_message }\"; git push -u origin master;"))
    print("Website git repository updated")
       
    print("making pull request to main site...")
    print(os.system(f"cd { website_dir }; hub pull-request -h aquilegiataylor2:master -m 'automatic pull request'"))
    # print(os.system(f"cd { website_dir }; hub pull-request -b pecan-pine:master -h aquilegiataylor2:master -m 'automatic pull request after resume update'"))
    print("python--out--")
    print("python is done")


update_website("Updated website files in response to resume update")

    
def write_commit_message(request):
    message = request.json
    ref = message["ref"]
    branch = ref.split("/")[-1]
    name = message["repository"]["name"]
    prev_commit = message["before"]
    current_commit = message["after"]
    compare_url = message["compare"]
    prev_commit_message = message["head_commit"]["message"]
    
    # expand_json(message) 
    commit_message_output = f"Updated resume-related files in website in \
response to commit # { current_commit } in \
pecan-pine/resume repository. The message for this commit \
was: '{ prev_commit_message }'. The previous commit was \
# { prev_commit }. Compare the changes here: { compare_url }."

    return commit_message_output


# expand a json message to better read what is included
def expand_json(message):
    for key in message:
        if type(message[key]) == type({}):
            for k in message[key]:
                print("values of", key, "key:", k, ":", message[key][k])
        else:
            print("value of", key, ":", message[key])
