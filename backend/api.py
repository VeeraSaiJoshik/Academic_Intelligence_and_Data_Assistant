from flask import Flask, request, jsonify
from flask_cors import CORS
from sqlalchemy import create_engine, text
from sentence_transformers import SentenceTransformer

import torch

from embedding_processor import get_context_vectors, getContextSentences
from llm_processor import LLM_Processing, llm_api_key

embeddings, pages_and_text = get_context_vectors(
    "text_chunks_and_embeddings_df.csv")
embeddingModel = embeddingModel = SentenceTransformer(
    model_name_or_path="all-mpnet-base-v2",
    device='cuda' if torch.cuda.is_available() else 'cpu'
)
app = Flask(__name__)
CORS(app)

# Database connection string
DATABASE_URL = "postgresql://notenest:flasH$12@notenest.c1ecaegqc9l9.us-east-2.rds.amazonaws.com/postgres"
engine = create_engine(DATABASE_URL)

@app.route('/get-answer', methods=["POST"])
def get_answer():
    question = request.get_json()["question"]

    context = getContextSentences(question, embeddings, pages_and_text, embeddingModel)
    return LLM_Processing.get_natural_language_response(question, context=context, model="gemma-7b-it")

@app.route('/inject-context', methods=['POST'])
def inject_prompt():
    data = request.get_json()
    injected_prompt = LLM_Processing.inject_context_into_prompt(
        currentPrompt=data['currentPrompt'],
        previousPrompts=data['previousPrompts'],
        previousResponses=data['previousResponses'],
        model="gemma-7b-it"
    )
    return injected_prompt

@app.route('/get-chat-title', methods=['POST'])
def get_chat_title():
    data = request.get_json()
    
    chatTitle = LLM_Processing.get_chat_title(
        initialMessage=data['message'],
        model="gemma-7b-it"
    )
    return chatTitle

@app.route('/create-user', methods=['POST'])
def create_user():
    data = request.get_json()
    user_id = data['userId']
    
    # SQL to create a user (modify according to your schema)
    with engine.connect() as connection:
        connection.execute(text("INSERT INTO users (id) VALUES (:id)"), {"id": user_id})
    
    return jsonify({'success': True})

@app.route('/get-chat-data', methods=['POST'])
def get_chat_data():
    data = request.get_json()
    user_id = data['userId']

    query = """
      SELECT c.id AS chat_id, c."chatName", c.date, 
             m.id AS message_id, m.message, m.source
      FROM "Chat" c
      LEFT JOIN "Message" m ON c.id = m."chatId"
      WHERE c."userId" = :userId
      ORDER BY c.id, m.id;
    """

    with engine.connect() as connection:
        result = connection.execute(text(query), {"userId": user_id})
        print("here are the results")
        chats = [
            {
                "chat_id": row[0],
                "chatName": row[1],
                "date": row[2],
                "message_id": row[3],
                "message": row[4],
                "source": row[5],
            }
            for row in result.fetchall()
        ]
        
    print("i am done bro")
    print(chats)
    return jsonify({
        "data": chats
    })

if __name__ == '__main__':
  if llm_api_key == "[Censored]":
    raise ValueError("The API Key has not been entered, please contact the developer at joshikdevelop@gmail.com to get access to the credentials")
  
  app.run(debug=True, port=38866)
