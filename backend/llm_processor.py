import json
from groq import Groq
import time

llm_api_key = "[Censored]"

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
        api_key=llm_api_key,
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

  @staticmethod
  def inject_context_into_prompt(previousPrompts: list[str], previousResponses: list[str], currentPrompt: str, model:str):
    client = Groq(
        api_key="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",
    )
    with open("context_injection.txt", "r") as file:
      systemContent: str = file.read()
    
    
    chatHistory = ""
    for i in range(len(previousPrompts)):
      chatHistory += "[user_response]" + previousPrompts[i] + "\n"
      chatHistory += "[chatbot]" + previousResponses[i] + "\n"
    chatHistory += "[current_prompt]" + currentPrompt
    
    print(chatHistory)

    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": chatHistory
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
    return response
  
  @staticmethod
  def get_chat_title(initialMessage: str, model: str):
    client = Groq(
        api_key="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",
    )
    
    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": initialMessage
            },
            {
                "role": "system",
                "content": "You are a helpful summarizer. Given the first message in a series of texts with an AI chatbot, please provide a meaningful title for that conversation that is 3-5 words long that represnts the contents of the initial message. Response with the title value the value of a 'title' key in the json object"
            }
        ],
        model=model,
        temperature=0.3,
        max_tokens=356,
        response_format={
            "type": "json_object"
        }
    )
    
    print(chat_completion)
    
    return chat_completion.choices[0].message.content
