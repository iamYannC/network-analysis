import sys
import os
import importlib.util

current_dir = os.path.dirname(os.path.abspath(__name__))
# full path
file_path = os.path.join(current_dir, "01 network init.py")
# load file
spec = importlib.util.spec_from_file_location("network_init", file_path)
network_init = importlib.util.module_from_spec(spec)
spec.loader.exec_module(network_init)
