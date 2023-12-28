# curl the raw version of the install.sh script and save it to file (-O)
# ! you might need to regenerate the url by going to the file url, pressing 'raw', and then taking the url
# ! don't forget the quotes around the url, or run `noglob curl {url}` to escape special characters (there's a "?" in there that's treated as a wildcard)
curl -O "https://raw.githubusercontent.com/ViktorJT/Configs/main/install.sh?token=GHSAT0AAAAAACG4HVEI7MTTB7WNIVXT4HLIZMNOI2A"

# add execute permission to file
chmod +x install.sh

# run the script
./install.sh
