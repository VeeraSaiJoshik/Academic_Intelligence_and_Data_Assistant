import json
from groq import Groq
import time

class LLM_Processing :
  @staticmethod
  def post_process_output(raw_response: str) -> str :
    formatted_response: str = raw_response.replace("```", "").replace(
        "json", "").replace("{\n", "").replace('"Response" : "', "").replace('"Response": "', "").replace('"Response" :"', "").replace('"\n}', "")
    
    return formatted_response
  
  @staticmethod
  def get_natural_language_response(question: str, context: list[str], model: str):
    client = Groq(
        api_key="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",
    )
    with open("system_content.txt", "r") as file:
      systemContent: str = file.read()

    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": question + '\n'.join(context),
            },
            {
                "role": "system",
                "content": systemContent
            }
        ],
        model=model,
    )
    response = chat_completion.choices[0].message.content
    
    return LLM_Processing.post_process_output(response)
