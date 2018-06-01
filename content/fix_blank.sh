MATCHES=$(grep -ro '[[:blank:]]$' . | wc -l)

find . -type f -print0 | xargs -0 sed -i 's/[ \t]*$//'

TEXTLINES="( find . -type f -print0 | xargs -0 cat ) | wc -l"
TEXTLINES=$(eval "$TEXTLINES")
echo "changed lines: $MATCHES"
echo "total text lines: $TEXTLINES"

