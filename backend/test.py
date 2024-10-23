from embedding_processor import get_context_vectors, getContextSentences
from sentence_transformers import SentenceTransformer
from llm_processor import LLM_Processing
import torch

embeddings, pages_and_text = get_context_vectors(
    "text_chunks_and_embeddings_df.csv")
embeddingModel = embeddingModel = SentenceTransformer(
    model_name_or_path="all-mpnet-base-v2",
    device='cuda' if torch.cuda.is_available() else 'cpu'
)

questions = [
  "How to graduate with honors", 
  "How many credits do you need to move to the next grade?", 
  "how many absences can I get?", 
  "How many credits do I need to graduate?"
]

responses = [
  [],
  [],
  [],
  [],
  [],
]
models = [
  "gemma-7b-it", 
  "gemma2-9b-it",
  "llama-3.1-70b-versatile",
  "llama-3.2-1b-preview",
  "llama-3.1-8b-instant"
]

for question in questions:
  context = getContextSentences(
    question,
    embeddings,
    pages_and_text,
    embeddingModel
  )
  
  print(question)
  print("="*50)
  
  for i in range(len(models)):
    model = models[i]
    
    response = LLM_Processing.get_natural_language_response(question, context, model)
    
    responses[i].append(response)
    print("=" * 10 + model + "=" * 10)
    print(response)

  print()
  print()
