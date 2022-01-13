import json
"""
Repeated Names Within an Object
The RFC specifies that the names within a JSON object should be unique, but does not mandate how repeated names in JSON objects should be handled.
By default, this module does not raise an exception;
instead, it ignores all but the last name-value pair for a given name
"""

def unique(json_input):
    json_input = json.loads(json_input)
    print(json.dumps(json_input, indent = 4, sort_keys=True))