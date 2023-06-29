import sys
import re
import yaml

version = ""

def replace(file, searchRegex, replaceExp):
  with open(file, "r+") as file:
      text = file.read()
      text = re.sub(searchRegex, replaceExp, text)
      file.seek(0, 0) # seek to beginning
      file.write(text)
      file.truncate() # get rid of any trailing characters

# read pubspec.yaml variables
with open('pubspec.yaml', "r") as stream:
    data = yaml.safe_load(stream)
    version = data['version']

semver_regex = r"(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?"

# update android
replace("android/src/main/assets/kaleyra_video_wrapper_info.txt", semver_regex, version)

# update ios
replace("ios/Classes/PluginInfo/_KaleyraVideoHybridVersionInfo.swift", semver_regex, version)
