#!/usr/bin/perl

# read the config file
for(split /\n/,`cat index.cfg`) {
  $CONF{$1}=$2 if $_=~/^\h*(.*?):\h*(.*?)\h*$/; }

$css  = `cat template/main.css`; $css=~s/\n$//;
$body = `cat template/index.html`;

$body =~ s/__TITLE__/$CONF{title}/g;
$body =~ s/__CSS__/$css/g;

print "Content-type: text/html\n\n";
print "$body\n";

# debug
# print "<hr>\n";
# print "$_: $CONF{$_}<br>" for keys %CONF;

# R.Jaksa 2022 GPLv3
