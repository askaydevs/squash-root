# Package structure
To get started, place this repository as a parent folder to the repository
`askaydevs/squash-generation` and `askaydevs/squash-website`. Make sure that your
folder structure look like this,

```
-|squash-root/
    -|squash-generation/
    -|squash-website/
    -|start_development.sh
    -|start_production.sh
    -|install.txt
```

Create a new Python 3.6 virtual environment and activate it before proceeding further.

There are two modules, `squash-generation/` where the models and backend
code lives, and `squash-website/` is react app with flask as a development
server and WSGI as a production server. Next up installing squash-generation`!

# Install `squash-generation/` Module

1. Go to the `squash-generation/` directory using `cd squash-generation/`

2. Install the requirements using `pip install -r requirements.txt`.

3. Install the `English` spacy library using `python -m spacy download en_core_web_sm`.

4. Since the code uses a slightly modified version of
   huggingface/pytorch-pretrained-BERT, it needs to be installed locally. Run
   `cd pytorch-pretrained-BERT` followed by `pip install --editable .`

Everything else is inplace like models, the data used to train, training and
interact scripts. We may need to reconfigure paths later.

# Setting up the demo

## Backend
The code for the SQUASH APIs and backend is found under `squash-backend/`. All the
code is written in `squash-backend/app.py`. The code requires Python 3.6+ as well
as the python package Flask. Now run the following code to start the backend server.

```
cd squash-backend
export FLASK_APP=app.py
python -m flask run --host 0.0.0.0 --port 3005
```

Finally, in five different terminals (all with `squash-generation/` as the root folder launch the following scripts

```
# terminal 1
python squash/extract_answers.py

# terminal 2
python question-generation/interact.py --model_checkpoint question-generation/gpt2_corefs_question_generation --model_type gpt2

# terminal 3
python question-answering/run_squad_demo.py --bert_model question-answering/bert_large_qa_model --do_predict --do_lower_case --predict_batch_size 16 --version_2_with_negative

# terminal 4
python squash/filter.py

# terminal 5
python squash/cleanup.py
```

(For running these commands together, you might find the tmux command under Production Level Deployment useful)

## Frontend
The SQUASH frontend has been written in ReactJS. To get started, make sure you have
the latest `npm` and `node` installed. The dependencies for the frontend have been
specified in `squash-website/squash-frontend/package.json`.

Note: Demo is a React App, I was able to setup this on machine after alot of
trouble in installing npm dependencies because I had a faulty npm and node installation.
I used `nvm` (node version manager) to reinstall npm and node distributions.

To get started, first edit the `squash-website/squash-frontend/src/url.js` to point to the local server URL
(Its '0.0.0.0/3005' in this context). Then, install the dependencies and run the frontend server.
```
#Go to squash-website/squash-frontend
  cd squash-website`.
  # Install the dependencies
  `npm install`.
  Run the frontend server
  `npm start`
```

# Production Level Deployment
For a production level deployment, you should not use developmental servers.
For the backend server, waitress is used here. To run the server use,
```
cd squash-backend
python waitress_server.py
```

For the frontend server, first create a static website and then serve it. use the following.
```
cd squash-frontend
npm run build
npx serve -s build -l 3000
```
---------------------------------------------------------------------------------------------
You might find this all-in-one `tmux` command useful.
```
tmux new -s squash \
    "cd squash-website/squash-backend ; python waitress_server.py ; read" \; \
    new-window "cd squash-website/squash-frontend ; npx serve -s build -l 3000 ; read" \; \
    new-window "cd squash-generation ; python squash/extract_answers.py ; read" \; \
    new-window "cd squash-generation ; export CUDA_VISIBLE_DEVICES=0 ; python question-generation/interact.py --model_checkpoint question-generation/gpt2_corefs_question_generation --model_type gpt2 ; read" \; \
    new-window "cd squash-generation ; export CUDA_VISIBLE_DEVICES=0 ; python question-answering/run_squad_demo.py --bert_model question-answering/bert_large_qa_model --do_predict --do_lower_case --predict_batch_size 16 --version_2_with_negative ; read" \; \
    new-window "cd squash-generation ; python squash/filter.py ; read" \; \
    new-window "cd squash-generation ; python squash/cleanup.py ; read" \; \
    detach \;
```

In `squash-root/-` folder two scipts are provided `start-development.sh` and `start-production.sh`.
For starting development the backend and frontend servers have to be started manually in two different terminals followed by
running development script in third, in case of production level deployment just run the
production script directly.

```
# Starting the backend server for development
/squash-website/squash-backend$export FLASK_APP=app.py
/squash-website/squash-backend$python -m flask run --host 0.0.0.0 --port 3005

# Starting the frontend server
/squash-website/squash-frontend$npm start

# Serving models and other helper scripts
/squash-root$chmod +x start-development.sh
/squash-root$./start-development.sh
```

Start the production level deployment gpt_question_generation

`/squash-root$./start-production.sh`


## My local machine configurations

|Particulars      |Value                                     |
|-----------------|------------------------------------------|
|Operating System |  Ubuntu 19.04 LTS 64-bit                 |
|Processor        |  Intel® Core™ i5-8500 CPU @ 3.00GHz × 6  |
|GPU              |  4GB, GeForce GTX 1050/PCIe/SSE2         |
|RAM              |  16GB                                    |

I have used Anaconda for managing environments.
