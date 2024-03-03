# Lucius VII
 The bot itself but now with a brain, powered by [Ollama](https://ollama.com/)

## Folder Structure
```
 src
  ├── LuciusVII             # Actual main folder
  │   ├── API.hs            # File where all the api interactions with Ollama are handled
  │   ├── Commands          # The discord slash commands
  │   │   ├── GetModels.hs
  │   │   └── SetModel.hs
  │   ├── Commands.hs       
  │   └── Utils.hs          # Bunch of helper functions
  └── LuciusVII.hs          # "Real" Main executable 
```

## Ollama

### References:
- [Official Ollama GitHub Page](https://github.com/ollama/ollama?tab=readme-ov-file)
- [ModelFile](https://github.com/ollama/ollama/blob/main/docs/modelfile.md)
- [Ollama API Endpoints](https://github.com/ollama/ollama/blob/main/docs/api.md)

### REST API

URL http://localhost:11434

 Method |                Route                |   Arguments   | Description
--------|-------------------------------------|---------------|-------------
  POST  | /api/generate | model, prompt | `model`: name of the model to use (see ollama). `prompt`: message sent
  POST  | /api/create   | `name`, `modelfile`, `stream` | creates a new model via a modelfile
  POST  | /api/chat     | `model`, `messages`: [{ `role`, `content` }], `stream`, `keep_alive` | Generates the next message in a chat
  GET   | /api/show     | `name` | Shows information abouta model
  GET   | /api/tags     |      | Lists all locally available models