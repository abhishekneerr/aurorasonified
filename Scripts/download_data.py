"""
Install geckodriver and add to path - for Firefox.
"""

from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions

import time
import os

def open_noaa(driver):
    """Opens the noaa url"""
    url_noaa = "https://www.swpc.noaa.gov/products/real-time-solar-wind"
    try:
        driver.get(url_noaa)
    except:
        print("Could not open url_noaa")


def press_by_id(driver, id):
    """Find and click element by id"""
    count = 0
    sleep_time = 1
    while count < 10:
        try:
            button = driver.find_element_by_id(id)
            button.click()
            print(f"Clicked {id}")
            return True
        except:
            count += 1
            print(f"Could not find and click {id}. Try: {count}.")
            time.sleep(sleep_time)
    return False

def create_driver(download_destination, headless = True):
    """Create an instance of Firefox with appropriate options"""
    options = Options()
    options.headless = headless
    profile = webdriver.FirefoxProfile()
    profile.set_preference("browser.download.folderList", 2) # Don't use standard download folder
    profile.set_preference("browser.download.dir", download_destination) # Path to download destination
    profile.set_preference("browser.helperApps.neverAsk.saveToDisk", "text/plain") # Don't prompt for download
    
    driver = webdriver.Firefox(firefox_profile=profile, options=options)
    return driver
    

def get_download_destination():
    """Just get relative path for download folder"""
    return os.path.abspath("../Downloaded_data")
    
def main():
    print("Starting download script")
    
    path_download = get_download_destination()
    driver = create_driver(path_download, False)

    id_timespan_button = "timespan-button"
    id_2hours_timespan = "ui-id-6"
    id_7days_timespan = "ui-id-10"
    id_save_button = "save_button"

    open_noaa(driver)
    if not press_by_id(driver, id_timespan_button):
        print("Exiting python")
        return 1
    #if not press_by_id(driver, id_2hours_timespan):
    if not press_by_id(driver, id_7days_timespan):
        print("Exiting python")
        return 1
    if not press_by_id(driver, id_save_button):
        print("Exiting python")
        return 1

    # Make sure the file has time to download:
    time.sleep(180)
    driver.quit()
    print("Done")

main()
