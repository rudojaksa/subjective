#!/usr/bin/perl

# get cgi form values (POST)
read(STDIN,$buf,$ENV{CONTENT_LENGTH});
for(split /&/,$buf) {
  $FORM{$1}=$2 if $_=~/(.*)=(.*)/; }

# get config data
for(split /\n/,`cat index.cfg`) {
  $CONF{$1}=$2 if $_=~/^\h*(.*?):\h*(.*?)\h*$/; }

# default nickname
$FORM{nick} = "Anonymous" if not defined $FORM{nick} or $FORM{nick} eq "";

# check whether the nick is already taken and add the number
$nick = $FORM{nick};
if(-f "$CONF{output}/$nick.csv") {
  my $i = 2;
  $nick =~ s/[0-9]*$//;
  $nick = $FORM{nick}.$i++ while -f "$CONF{output}/$nick.csv"; }

# read the description and templates
$dsc  = `cat description.txt`;
$css  = `cat template/main.css`; $css=~s/\n$//;
$body = `cat template/desc.html`;

$dsc  =~ s/\n/<br>\n/g;

$body =~ s/__TITLE__/$CONF{title}/g;
$body =~ s/__CSS__/$css/g;
$body =~ s/__TEXT__/$dsc/g;
$body =~ s/__NICK__/$nick/g;

print "Content-type: text/html\n\n";
print "$body\n";

# debug
# print "<hr>\n";
# print "$_: $CONF{$_}<br>" for keys %CONF;

# R.Jaksa 2022 GPLv3
