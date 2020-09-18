from flask import Flask, request, Response, redirect
import os

app = Flask(__name__)

@app.route('/', methods=['POST', 'GET'])
def hello_world():
    if request.method == 'POST':
        print("Post!")
        user_agent = request.headers["User-Agent"]
        if "GitHub-Hookshot" in user_agent.split("/"):
            message = request.json
            ref = message["ref"]
            branch = ref.split("/")[-1]
            name = message["repository"]["name"]
            prev_commit = message["before"]
            current_commit = message["after"]
            compare_url = message["compare"]
            
            # expand_json(message) 
            print(name)
            print(branch)
            print(prev_commit)
            print(current_commit)
            print(compare_url)
        else:
            file_test()
            print("The button was pressed")
            return redirect("/")
        return Response(status=200)
    return """Hello, there! Press this button: <form action="/" method="POST"><input type="submit" value="Button"></form>"""

def file_test():
    resume_dir = '../resume'
    input_dir = resume_dir + '/generated_resumes/website'
    website_dir = '../pecan-pine.github.io'
    output_dir = website_dir + '/shared'

    input_files = os.listdir(input_dir)
    print(input_files)
    print(os.listdir(output_dir))

    print(os.system(f'cd { resume_dir }; git pull origin web_version;'))
    print(os.system(f'cd { website_dir }; git pull;'))

    for f in input_files:
        print(f'Copying file {f}...')
        os.system(f'cp { input_dir }/{f} {output_dir}/{f}')
    
    



# expand a json message to better read what is included
def expand_json(message):
    for key in message:
        if type(message[key]) == type({}):
            for k in message[key]:
                print("values of", key, "key:", k, ":", message[key][k])
        else:
            print("value of", key, ":", message[key])
