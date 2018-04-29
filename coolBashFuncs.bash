# SHUTDOWN (with process name part)
# this kill -9 all processes running on your unix machine whose name contain
# the first parameter passed to this command
sd() {
        allRelvntProcesses="$(
                ps -aux | grep "$1" | sed '/grep --color=auto '"$1"'/d'
        )"
        relvntPids="$(
                sed -n 's/^[^ ][^ ]*  *\([0-9][0-9]*\)  *.*$/\1/p' <<< "$allRelvntProcesses"
        )"
        echo "$relvntPids"
        while read -r pidLine; do
                kill -9 "$pidLine"
        done <<< "$relvntPids"
}

# FOREGROUND (with) REGEX
# a bash script that uses "jobs", "gnu sed" and "fg" and that
# puts in the foreground the first process, in the list of background child processes, 
# whose name contains the only parameter passed to this function.
# i.e. imagine jobs returns:
#[7]   Stopped                 vim views/index.scala.html  (wd: ~/workspace/wordsOccurences/server/app)
#[8]-  Stopped                 vim ../public/javascripts/main.js  (wd: ~/workspace/wordsOccurences/server/app)
#[9]   Stopped                 vim controllers/CountOccurences.scala  (wd: ~/workspace/wordsOccurences/server/app)
#[10]   Stopped                 vim public/stylesheets/main.css
#[11]+  Stopped                 vim ~/.bashrc
#
# then typing 'fgr main' in your terminal would put 'vim ../public/javascripts/main.js'
# in the foreground

fgr() {
        processNamePart="$1"

        if [ -z "$processNamePart" ]; then
                fg
		return 1
        fi

        nb=$(jobs | sed -n 's/^.*\[\([0-9][0-9]*\)\].*'"$processNamePart"'.*$/\1/p')
        if [ -z "$nb" ]; then
                echo "no child process of that terminal that has name containg $processNamePart is currently running"
                return 1
        fi
        processNbArray=(${nb})

        echo "${processNbArray[0]}"
        fg "${processNbArray[0]}"
}

