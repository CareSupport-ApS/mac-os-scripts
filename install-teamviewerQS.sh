#!/bin/sh

#mkdir /tmp/caresupport
#cd /tmp/caresupport
cd /Applications

curl "https://customdesignservice.teamviewer.com/download/mac/v15/694b2ks/TeamViewerQS.zip?sv=2020-04-08&se=2023-05-26T08%3A46%3A24Z&sr=b&sp=r&sig=0rfMTl7xT6AcQDFUsOj9ko0qXCA3BKgItpihoyn%2BNYc%3D" -L -o TeamViewer.zip
#mv "TeamViewer.zip" /Applications/TeamViewer.zip
#cd /Applications
unzip -o TeamViewer.zip
rm TeamViewer.zip