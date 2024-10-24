# datascrape logic if website in question is not a pdf
from crawl4ai import WebCrawler

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
          raise ValueError(
              "Error: Encountered NoneType data in the result or markdown.")

  except Exception as e:
      # Handle the error by printing the error message and any existing scraped data
      print(f"Error encountered: {e}")
      if result is not None:
          # Attempt to print whatever part of the data might be available, even if markdown is None
          print("Partial data extracted so far:")
          print(result)  # Print the raw result object for more insight


results = scrape_website("https://bentonvillek12.org/StudentAnnouncements/bwhs")

print(results)
