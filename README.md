sabPreProcessing
================
*A pre-processing script for SABnzbd in BASH!*

I always loved the "click and forget" possibility of Sickbeard and Couchpotato.<br />
But sometimes I need to add an nzb file myself – no category is set, only the default post-script is used and mostly the folder name just looks like crap. And even when Couchpotato or Sickbeard added something,<br/>
there was a chance it was not what I wanted it to be.<br /><br/>
I needed a pre-processing script.<br />
There where various SABnzbd post-processing scripts out there,<br />
but not many pre-processing scripts with various features – so I wrote my own in BASH.

### FEATURES
* Set SABnzbd category automatically by tv-show-regex, IMDB-ID or games group
* Set post-processing script and priority according to category
* Refuse download according to size and category (which movie is under 400mb?)
* Automatically set high priority on low size
* Extract password and add to a password file to be used in SabNZBd
* Get the release name out of the nzb name and use as final folder name
* Clean out many UseNet exceptions
* Disable script for own exceptions
* Refuse nzbs using a badword filter
* Many configurable variables
* Exact log file

### HOW TO INSTALL
Move to your SABnzbd script folder and clone the script:
```bash
cd '/home/username/.sabnzbdplus/scripts';
git clone 'https://github.com/HashWorks/sabPreProcessing.git';
```

Add a symlink inside your SABnzbd script folder to the script file:
```bash
ln -s 'sabPreProcessing/sabPreProcessing.sh' 'sabPreProcessing.sh';
```

Make a copy of the default configuration file and name it 'config.sh':
```bash
cp 'sabPreProcessing/default.config.sh' 'sabPreProcessing/config.sh';
```

Edit your configuration file and set your variables.<br />
Remove the variables you wish to stay at default value.<br />
You can extend default arrays by `ARRAY+=('bar');`.

Make the script files executable. This may need root rights:
```bash
chmod a+x 'sabPreProcessing/default.config.sh';
chmod a+x 'sabPreProcessing/config.sh';
chmod a+x 'sabPreProcessing/sabPreProcessing.sh';
```

Add the pre-processing script to your SABnzbd settings and save them: http://i.imgur.com/N4soUIr.png<br />
And you are done!


### TESTING
You can test it by running:
```bash
sabPreProcessing/sabPreProcessing.sh 'Dexter S07E06 FRENCH 720p HDTV x264-JMT Testmessage, not part of releasename http://hashworks.net / securepassword' '3' 'standard' '' '-100' '9711567550'
```

It should return something like:
```
1
Dexter.S07E06.FRENCH.720p.HDTV.x264-JMT / securepassword
3
series
sabToSickBeard.py
1
```

### UPDATING
To update the script, simply move to the sabPreProcessing folder and run: `git pull`
