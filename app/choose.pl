#!/usr/bin/perl

# get cgi form values (POST)
read(STDIN,$buf,$ENV{CONTENT_LENGTH});
for(split /&/,$buf) {
  $FORM{$1}=$2 if $_=~/(.*)=(.*)/; }

# get config data
for(split /\n/,`cat index.cfg`) {
  $CONF{$1}=$2 if $_=~/^\h*(.*?):\h*(.*?)\h*$/; }

# debug
# print "Content-type: text/html\n\n";
# print "$buf\n";
# print "$_ --> $ENV{$_}<br>"  for keys %ENV;
# print "$_ --> $CONF{$_}<br>" for keys %CONF;
# print "$_ --> $FORM{$_}<br>" for keys %FORM; exit 0;

# defaults
$CONF{rounds}=20 if not defined $CONF{rounds};
$FORM{round}=0 if not defined $FORM{round};
$FORM{nick}="Anonymous" if not defined $FORM{nick} or $FORM{nick} eq "";

# on the round 1 check whether the nick is already taken
$nick = $FORM{nick};
if($FORM{round}<1 and -f "$CONF{output}/$nick.csv") {
  my $i = 2;
  $nick =~ s/[0-9]*$//;
  $nick = $FORM{nick}.$i++ while -f "$CONF{output}/$nick.csv"; }

# sums
$FORM{suma}=0 if not defined $FORM{suma} or $FORM{suma} eq "";
$FORM{sumb}=0 if not defined $FORM{sumb} or $FORM{sumb} eq "";
$FORM{suma}++ if $FORM{choice} eq "a";
$FORM{sumb}++ if $FORM{choice} eq "b";

# append string to file
sub addtofile {
  my $file = $_[0];
  my $body = $_[1];
  die "Can't append to file \"$file\" ($!)." if not open O,">>$file";
  print O $body;
  close(O); }

# save the last data into CSV
$CONF{output}="out" if not defined $CONF{output};
system "mkdir -p $CONF{output}" if not -d $CONF{output};
$output = "$CONF{output}/$nick.csv";
if($FORM{round}>0) {
  my $ch=1; $ch=2 if $FORM{choice} eq "b";
  addtofile $output,"$FORM{round} $ch $FORM{imga} $FORM{imgb}\n"; }

# check the end of sessions
$FORM{round}++;
if($FORM{round} > $CONF{rounds}) {
  system "QUERY_STRING='nick=$nick&suma=$FORM{suma}&sumb=$FORM{sumb}' perl result.pl";
  exit 0; }

# get templates
$css  = `cat template/main.css`; $css=~s/\n$//;
$body = `cat template/choose.html`;

# form template
my $code=<<EOF;
<div>
<img src=__DIR__/__IMG__>
<span class=cap>
<form action=choose.pl method=post>
<input class=button type=submit value="__TXT__">
<input class=hidden type=text name=round value=__ROUND__>
<input class=hidden type=text name=nick value=__NICK__>
<input class=hidden type=text name=imga value=__IMGA__>
<input class=hidden type=text name=imgb value=__IMGB__>
<input class=hidden type=text name=choice value=__AB__>
<input class=hidden type=text name=suma value=__SUMA__>
<input class=hidden type=text name=sumb value=__SUMB__>
</form>
</span>__SHOWAB____SHOWIMG__
</div>
EOF

# showimg/showab debug
$showimg = "";
$showab  = "";
if(defined $CONF{showimg} and $CONF{showimg}=~/((1)|(rue))/) {
  $showimg = "<span class=cap>__DIR__/__IMG__</span>"; }
if(defined $CONF{showab} and $CONF{showab}=~/((1)|(rue))/) {
  $showab = "<span class=cap>__ABS__</span>"; }
$code =~ s/__SHOWIMG__/$showimg/g;
$code =~ s/__SHOWAB__/$showab/g;

# single form code maker
sub form {
  my  $ab = $_[0]; # a/b
  my $txt = $_[1];
  my   $s = $code;
  if($ab eq "a") {
    $s =~ s/__IMG__/__IMGA__/g;
    $s =~ s/__DIR__/__DIRA__/g;
    $s =~ s/__ABS__/a __SUMA__/g;
    $s =~ s/__AB__/a/g; }
  else {
    $s =~ s/__IMG__/__IMGB__/g;
    $s =~ s/__DIR__/__DIRB__/g;
    $s =~ s/__ABS__/b __SUMB__/g;
    $s =~ s/__AB__/b/g; }
  $s =~ s/__TXT__/$txt/g;
  return $s; }

# create final forms code, and apply it
if(int(rand(2))) {
  $MAIN .= form("a","this one");
  $MAIN .= form("b","or this one"); }
else {
  $MAIN .= form("b","this one");
  $MAIN .= form("a","or this one"); }
$body =~ s/__MAIN__/$MAIN/g;

# select two random images
@imga = split /\n/,`ls $CONF{dira}`;
@imgb = split /\n/,`ls $CONF{dirb}`;
$IMGA = $imga[int(rand($#imga))];
$IMGB = $imgb[int(rand($#imgb))];

# substitute rest of things in the template
$body =~ s/__CSS__/$css/g;
$body =~ s/__TITLE__/$CONF{title}/g;
$body =~ s/__QUESTION__/$CONF{question}/g;
$body =~ s/__ROUNDS__/$CONF{rounds}/g;
$body =~ s/__NICK__/$nick/g;
$body =~ s/__DIRA__/$CONF{dira}/g;
$body =~ s/__DIRB__/$CONF{dirb}/g;
$body =~ s/__IMGA__/$IMGA/g;
$body =~ s/__IMGB__/$IMGB/g;
$body =~ s/__SUMA__/$FORM{suma}/g;
$body =~ s/__SUMB__/$FORM{sumb}/g;

# init the rounds counter and apply it
$body =~ s/__ROUND__/$FORM{round}/g;

# print the result
print "Content-type: text/html\n\n";
print "$body\n";

# R.Jaksa 2022 GPLv3
