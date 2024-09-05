import sys
import os
import importlib.util
# Get the directory of the current script
current_dir = os.path.dirname(os.path.abspath(__name__))


# Construct the full path to the file you want to import
file_path = os.path.join(current_dir, "01 network init.py")

# Use importlib to import the module
spec = importlib.util.spec_from_file_location("network_init", file_path)
network_init = importlib.util.module_from_spec(spec)
spec.loader.exec_module(network_init)
print(net_name)