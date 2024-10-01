import json
from groq import Groq
import time

class LLM_Processing :
  @staticmethod
  def validate_response(response):
    keywords = [('dont', 'context'), ('no', 'context'),
                ('lack', 'context'), ('not', 'context'),
                ('provided text', 'does not contain', 'any information regarding')]
    contains_no_context = any(
        all(word in response for word in keyword) for keyword in keywords)

    if contains_no_context:
      return "Sorry, but I do not have this information at the time. Please email or visit your counselor to get the accurate answer to your question!"

    return response
  
  @staticmethod
  def post_process_output(raw_response: str) -> str :
    return LLM_Processing.validate_response(json.loads(raw_response)["Response"])
  
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
        temperature=0.3,
        max_tokens=356,
        response_format={
          "type": "json_object"
        }
    )
    
    response = chat_completion.choices[0].message.content
    return LLM_Processing.post_process_output(response)
