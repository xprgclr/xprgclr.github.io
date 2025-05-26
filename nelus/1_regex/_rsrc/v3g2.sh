cat kit.txt | awk -f stage.awk \
            | perl -pe 's/[ ,]+"$/"/' \
            | grep -P ROOM \
            | sort \
            | uniq -c \
            | nl \
            | tr -d '"' \
            | perl -pe 's/ROOM: //' \
            | awk '{print $1, $4, $3, $2}' \
            | sort