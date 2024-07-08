# Llama Server API Specification
Endpoint: /llama

Method: POST

Content-Type: application/json

Description: This endpoint receives a JSON payload containing a text prompt and optional parameters, and returns a generated text response in the style specified.

## Request Parameters:
```
prompt (required):          The text prompt for the language model to respond to.
max_length (optional):      Maximum number of tokens to generate. Default is set to 0.
pre_response (optional):    A string to prepend to the model's response, allowing for 
                                continued dialogues or contexts.
```
Request Example:
```
{
    "prompt": "What's your favorite kind of boat?",
    "max_length": 50,
    "pre_response": "Ahoy! "
}
```

### Response:

Success: Returns a JSON object with the generated text.

Error: Returns a JSON object with an error message indicating the missing parameters or any internal errors.

### Success Response Example:
```
"<|system|>\nYou are a succinct chat bot that will do as prompted by the user, or if asked a question will answer that question.</s>\n<|user|>\nWhat is the day that follows Friday?</s>\n<|assistant|>\nThe day that follows Friday is: \n\nSaturday\n\nSunday\n\nMonday\n\nTuesday\n\nWednesday\n\nThursday\n\n"
```

### Error Response Example:
```
{
    "error": "Missing required parameters prompt and/or max_length"
}
```

## Errors:
400 Bad Request: Occurs when the prompt or max_length parameters are missing.

500 Internal Server Error: Indicates an error within the server, such as issues with the model loading or processing.

## Development and Testing:
To start the server for development or local testing:

Run ```python model.py``` to start Flask on host 0.0.0.0 at port 8080 with debugging enabled.
Ensure the environment has all necessary libraries installed, including Flask, torch, transformers, and loguru.
CUDA-enabled GPU environment is required for model inference using the specified device map.
This API is designed for integration with frontend services or other applications that require text generation capabilities. For any issues or further customization, review the server logs or contact the API maintainer.
