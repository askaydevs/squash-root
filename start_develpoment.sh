tmux new -s squash-development \
    "cd squash-generation ; python squash/extract_answers.py ; read" \; \
    new-window "cd squash-generation ; python question-generation/interact.py --model_checkpoint question-generation/gpt2_corefs_question_generation --model_type gpt2 ; read" \; \
    new-window "cd squash-generation ; python question-answering/run_squad_demo.py --bert_model question-answering/bert_large_qa_model --do_predict --do_lower_case --predict_batch_size 8 --version_2_with_negative ; read" \; \
    new-window "cd squash-generation ; python squash/filter.py ; read" \; \
    new-window "cd squash-generation ; python squash/cleanup.py ; read" \; \
    detach \;
