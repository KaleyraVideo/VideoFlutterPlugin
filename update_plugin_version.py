import sys
import re
import yaml

if len(sys.argv) <= 1:
    raise Exception("Missing arguments, call this script passing 'patch', 'minor' or 'major' as argument depending on wich kind of release you want to do")

release_kind = sys.argv[1]

if (release_kind != 'patch') & (release_kind != 'minor') & (release_kind != 'major'): 
    raise Exception("Invalid argument: " + release_kind + " use only 'patch', 'minor' or 'major' as argument")

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

version_comonents = version.split('.')

if len(version_comonents) != 3:
    raise Exception("Invalid version format in pubspec.yaml")
    
if release_kind == 'patch':
    version_comonents[2] = str(int(version_comonents[2]) + 1)

elif release_kind == 'minor':
    version_comonents[1] = str(int(version_comonents[1]) + 1)
    version_comonents[2] = '0'

elif release_kind == 'major':
    version_comonents[0] = str(int(version_comonents[0]) + 1)
    version_comonents[1] = '0'
    version_comonents[2] = '0'

else: 
    raise Exception("Invalid release_kind")

new_version = ".".join(version_comonents)

replace("pubspec.yaml", "version: " + version, "version: " + new_version)

semver_regex = r"(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?"

# update android
replace("android/src/main/assets/kaleyra_video_wrapper_info.txt", semver_regex, new_version)

# update ios
replace("ios/Classes/PluginInfo/_KaleyraVideoHybridVersionInfo.swift", semver_regex, new_version)

print(new_version)