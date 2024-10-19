import requests
import time
import random

# List of URLs to generate traffic for
urls = [
    "http://checkout.csw.lab:8989/checkout",
    "http://ad.csw.lab:8990/ad",
    "http://recommend.csw.lab:8991/recommend",
    "http://productcatalog.csw.lab:8994/productcatalog",
    "http://shipping.csw.lab:8995/shipping",
    "http://cardvault.csw.lab:8996/get_credit_card",
    "http://cart.csw.lab:8997/carts"
]

# Function to generate GET requests
def generate_get_request(url):
    try:
        response = requests.get(url)
        print(f"GET {url} | Status Code: {response.status_code} | Response: {response.text[:100]}")  # Print only the first 100 characters of the response
    except requests.exceptions.RequestException as e:
        print(f"GET {url} | Error: {e}")

# Function to simulate continuous traffic
def simulate_continuous_traffic():
    while True:
        for url in urls:
            generate_get_request(url)
            # Randomize the wait time between requests to simulate variable traffic, delay between 1 and 3 seconds
            time.sleep(random.uniform(1, 3))

if __name__ == "__main__":
    simulate_continuous_traffic()