set style line 1 linewidth 7
set style line 2 linewidth 7
set style line 3 linewidth 7

plot "< tail -n 300 ticker.csv" using 1:2 with lines, "< tail -n 300 ticker.csv" using 1:3 with lines, "< tail -n 300 ticker.csv" using 1:4 with lines
pause 0.05
reread
