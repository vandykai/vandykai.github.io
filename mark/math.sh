md_file=<MD File>
awk '{
if ($0 ~ /^\s*\$\$\s{0,10}$/)
	print "\n"$0"\n"
else 
  print $0
}' $md_file > temp.md

cat -s temp.md > $md_file
rm -rf temp.md
