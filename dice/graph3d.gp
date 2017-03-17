set terminal png
set title "Fudgeless Fate"
set xlabel "Difficulty"
set ylabel "Dice"
set zlabel "Probability"
set output "graph3d.png"
set data style linespoints
splot 'graph3d.data' matrix title ""
