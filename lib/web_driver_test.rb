require "selenium-webdriver"
require 'byebug'

START_PAGE_URL = 'https://noqu.ru/group/kultura/kulturno-dosugovye-uchrezhdeniya/munitsipalnoe-byudzhetnoe-uchrezhdenie-gorodskogo-okruga-solnechnogorsk-tsentr-informatsionnoy-kultu/'.freeze

client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 120 # seconds
client.open_timeout = 120 # seconds
driver = Selenium::WebDriver.for :firefox, http_client: client

driver.navigate.to START_PAGE_URL
byebug
element = driver.find_element(name: 'q')
element.send_keys "Hello WebDriver!"
element.submit

puts driver.title

driver.quit