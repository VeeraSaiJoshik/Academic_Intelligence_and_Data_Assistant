import pandas as pd
import numpy as np
import torch
from sentence_transformers import util

def get_context_vectors(vector_csv_file_name: str):
  text_chunks_df: pd.DataFrame = pd.read_csv(vector_csv_file_name)

  print(text_chunks_df)

  text_chunks_df["embedding"] = text_chunks_df["embedding"].apply(
      lambda x: np.fromstring(x.strip("[]"), sep=" "))
  pages_and_chunks = text_chunks_df.to_dict(orient="records")

  embeddings = torch.tensor(
      np.array(text_chunks_df["embedding"].tolist()),
      dtype=torch.float32
  ).to(
      'cuda' if torch.cuda.is_available() else 'cpu'
  )

  return embeddings, pages_and_chunks


def getContextSentences(query, contextEmbeddings, pages_and_chunks, embeddingModel):
  query_vector = embeddingModel.encode(query, convert_to_tensor=True)
  
  dot_score = util.dot_score(a=query_vector, b=contextEmbeddings)[0]
  top_k_dot_score = torch.topk(dot_score, k=5)

  return [pages_and_chunks[idx]["sentence_chunk"] for score, idx in zip(top_k_dot_score[0], top_k_dot_score[1])]
