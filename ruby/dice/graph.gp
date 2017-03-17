set terminal png
set title "Fudgeless Fate"
set xlabel "Dice"
set ylabel "Success Rate"
set yrange [0:1]
set output "graph.png"
set data style linespoints
plot 'graph.data' using 1 title "Difficulty 1", \
'graph.data' using 2 title "Difficulty 2", \
'graph.data' using 3 title "Difficulty 3", \
'graph.data' using 4 title "Difficulty 4", \
'graph.data' using 5 title "Difficulty 5", \
'graph.data' using 6 title "Difficulty 6", \
'graph.data' using 7 title "Difficulty 7", \
'graph.data' using 8 title "Difficulty 8", \
'graph.data' using 9 title "Difficulty 9", \
'graph.data' using 10 title "Difficulty 10" \


