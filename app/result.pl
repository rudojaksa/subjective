#!/usr/bin/perl

# get cgi form values (GET)
for(split /&/,$ENV{QUERY_STRING}) {
  $FORM{$1}=$2 if $_=~/(.*)=(.*)/; }

# get config data
for(split /\n/,`cat index.cfg`) {
  $CONF{$1}=$2 if $_=~/^\h*(.*?):\h*(.*?)\h*$/; }

$css  = `cat template/main.css`; $css=~s/\n$//;
$body = `cat template/result.html`;

$body =~ s/__TITLE__/$CONF{title}/g;
$body =~ s/__CSS__/$css/g;
$body =~ s/__NICK__/$FORM{nick}/g;
$body =~ s/__SUMA__/$FORM{suma}/g;
$body =~ s/__SUMB__/$FORM{sumb}/g;

print "Content-type: text/html\n\n";
print "$body\n";

# R.Jaksa 2022 GPLv3
