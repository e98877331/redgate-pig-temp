from pprint import pprint
import json

with open('data2.json') as data_file:
  data1 = json.load(data_file)

pprint(data1)

