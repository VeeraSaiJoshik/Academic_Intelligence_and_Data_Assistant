# datascrape logic if website in question is not a pdf
from crawl4ai import WebCrawler
import requests
import PyPDF2
from io import BytesIO

"""
This function uses crawl4ai in order to use Artificial Intelligence to identify the important blocks of text on a website, and returns the important
text as chunks of text.
"""
def scrape_website(website_link: str):
  # Create an instance of WebCrawler
  crawler = WebCrawler()

  # Warm up the crawler (load necessary models)
  crawler.warmup()

  # Run the crawler on a URL
  try:
      # Run the crawler
      result = crawler.run(
        url=website_link
      )

      # Check if result and result.markdown exist and are not None
      if result is not None and result.markdown is not None:
          return result.markdown
      else:
          raise ValueError("Error: Encountered NoneType data in the result or markdown.")

  except Exception as e:
      # Handle the error by printing the error message and any existing scraped data
      print(f"Error encountered: {e}")
      if result is not None:
          # Attempt to print whatever part of the data might be available, even if markdown is None
          print("Partial data extracted so far:")
          print(result)  # Print the raw result object for more insight

"""
This function uses a http get request to pull a pdf from a website, and then uses pdf-lib in order to extract the text from a pdf
"""
def scrape_pdf(pdf_link: str):
  response = requests.get(pdf_link)

  # Raise an error if the request was unsuccessful
  response.raise_for_status()

  # Create a PDF reader object from the downloaded content
  pdf_file = BytesIO(response.content)
  pdf_reader = PyPDF2.PdfReader(pdf_file)

  # Extract text from each page
  pdf_text = ""
  for page_num in range(len(pdf_reader.pages)):
      page = pdf_reader.pages[page_num]
      pdf_text += page.extract_text() + "\n"

  # Print the extracted text
  return pdf_text

results = scrape_website(
    "https://bentonvillek12.org/StudentAnnouncements/bwhs")
print(results)
