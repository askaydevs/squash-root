tmux new -s squash-development \
    "cd squash-website/squash-backend ; export FLASK_APP=app.py ; fuser -k 3005/tcp ; python -m flask run --host 0.0.0.0 --port 3005 ; read" \; \
    new-window "cd squash-website/squash-frontend ; npm start ; read" \; \
    new-window "cd squash-generation ; python squash/extract_answers.py ; read" \; \
    new-window "cd squash-generation ; export CUDA_VISIBLE_DEVICES=0 ; python question-generation/interact.py --model_checkpoint question-generation/gpt2_corefs_question_generation --model_type gpt2 ; read" \; \
    new-window "cd squash-generation ; export CUDA_VISIBLE_DEVICES=0 ; python question-answering/run_squad_demo.py --bert_model question-answering/bert_large_qa_model --do_predict --do_lower_case --predict_batch_size 16 --version_2_with_negative ; read" \; \
    new-window "cd squash-generation ; python squash/filter.py ; read" \; \
    new-window "cd squash-generation ; python squash/cleanup.py ; read" \; \
    detach \;
