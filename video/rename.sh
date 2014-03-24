ls MagicShifter_*.png | cat -n | while read n f; do mv "$f" "mspcb_`printf %04d $n`.png"; done
# ls | egrep -o MagicShifter_[0-9]+ | egrep -o [0-9]+