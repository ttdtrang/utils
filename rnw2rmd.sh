inrnw=$1

echo "---"
echo "title: \"Title\""
echo "author: \"Author\""
echo "date: \"01/10/2016\""
echo "output: "
echo "  html_document:"
echo "      self_contained: false"
echo "---"

in_code=0
regex_codechunk="^<<([^,]+),(.+)>>\="
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ $line =~ ^% ]];then
        continue
    else
        if [[ $line =~ \\([a-z,A-Z]+)\{(.+)\} ]]; then
            cmd=${BASH_REMATCH[1]}
            args=${BASH_REMATCH[2]}
            if [[ $cmd =~ ^(.*)section  ]];then
                level=$((`grep -o sub <<< $cmd | wc -l` +1))
                printf '#%.0s'  `seq 1 $level`
                echo " $args"
            fi
        elif [[ $line =~ $regex_codechunk ]]; then
            printf '`%.0s' {1..3}
            echo "{r ${BASH_REMATCH[1]},${BASH_REMATCH[2]}}"
        elif [[ $line =~ ^@ ]]; then
            echo "\`\`\`"
        else
            echo $line
        fi
    fi
done < $inrnw
