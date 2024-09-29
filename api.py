from flask import Flask, request, jsonify
from embedding_processor import get_context_vectors, getContextSentences
from llm_processor import LLM_Processing
from sentence_transformers import SentenceTransformer
import torch
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

embeddings, pages_and_text = get_context_vectors("text_chunks_and_embeddings_df.csv")
embeddingModel = embeddingModel = SentenceTransformer(
    model_name_or_path="all-mpnet-base-v2",
    device='cuda' if torch.cuda.is_available() else 'cpu'
)

@app.route('/get-answer', methods=["POST"])
def get_user():
  question = request.get_json()["question"]
  print(question)
  
  context = getContextSentences(question, embeddings, pages_and_text, embeddingModel)
  
  return LLM_Processing.get_natural_language_response(question, context=context, model="gemma-7b-it")
  

if __name__ == '__main__':
  app.run(debug=True, port=3000)
