from flask import Flask, request, jsonify
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, pipeline
import torch
from transformers import pipeline

from loguru import logger
# Create a Flask object
app = Flask("Llama server")

# Initialize the model and tokenizer variables
# text_gen = None

@app.route('/llama', methods=['POST'])
def generate_response():
    
    try:
        data = request.get_json()
        
        # Must at least have a prompt
        if 'prompt' in data:
            logger.info(f"Received LLM generation request:\n{data}")
            prompt = data['prompt']
            
            max_length = int(data.get('max_length', 0))
            
            pre_response = data.get('pre_response', '')
            
            messages = [
                {
                    "role": "system",
                    "content": "You are a succinct chat bot that will do as prompted by the user, or if asked a question will answer that question."
                },
                {"role": "user", "content": prompt},
            ]
            
            prompt = pipe.tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
            outputs = pipe(prompt + pre_response, max_new_tokens=max_length, do_sample=True, temperature=0.7, top_k=50, top_p=0.95)
            
            logger.info(f"Generated outputs\n{outputs}")
            
            return jsonify(outputs[0]["generated_text"])

        else:
            return jsonify({"error": "Missing required parameters `prompt` and/or `max_length`"}), 400

    except Exception as e:
        return jsonify({"Error": str(e)}), 500 


if __name__ == '__main__':
    
    prompt = "What is the sum of 2+2? Only output the numerical sum."
    
    global pipe
    pipe = pipeline("text-generation", model="TinyLlama/TinyLlama-1.1B-Chat-v1.0", torch_dtype=torch.bfloat16, device_map="cuda:0")
        
    app.run(host='0.0.0.0', port=8080)