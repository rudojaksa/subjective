### NAME

subjective - simple subjective image test interface

### DESCRIPTION

This is a tool for subjective image tests, tournament type pool of images
surveys, for pairwise image comparison assessment.  It does:

 * starts a session of a sequence of comparisons with a unique nickname,
 * selects one random image from the first set and one from the second set,
 * presents them in randomized order with a given question,
 * collects the participants choices in the CSV file for every session.

It is minimalistic linux/perl/html CGI application.  It expects to be run under
the CGI capable webserver, apache or other.

The survey session is maintained by the chain of http calls, by passing the
nickname and other data from one evaluation page to other.

<span>
<img src=doc/sc1.png width=24% title="write the nickname and start a survey">
<img src=doc/sc2.png width=24% title="evaluate images by a simple choice">
<img src=doc/sc3.png width=24% title="survey is finished, displays your A/B ratio">
<img src=doc/sc4.png width=24% title="detailed report is stored in the out/nickname.csv file">
</span>

### INSTALLATION & USAGE

 1. copy the `app/` directory into your web space
 2. copy your two image sets into `app/img/A` and `app/img/B` directories (configurable)
 3. make the output directory `app/out/` to be accesible by your webserver (configurable)
 4. edit the `index.cfg`
 5. configure your webserver to be able to run the `index.pl` etc. CGI scripts
 6. run the survey with a set of participants
 7. collect the CSV (SSV) outputs from the `app/out/` directory

#### APACHE CONFIGURATION

Use something like this to configure apache to run perl CGI scripts from the
`/www` directory: (so you can copy or symlink the `app/` directory into `/www`
directory)

    LoadModule cgid_module /usr/lib/apache2/modules/mod_cgid.so
    DocumentRoot /www
    <Directory /www>
      Options FollowSymLinks Indexes ExecCGI
      AddHandler cgi-script .pl
      Require all granted
    </Directory>

And this to accept index.pl as automatic index file:

    LoadModule autoindex_module /usr/lib/apache2/modules/mod_autoindex.so
    DirectoryIndex index.html index.pl

