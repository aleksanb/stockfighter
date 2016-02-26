.PHONY:
all:
	bundle install

.PHONY:
live:
	gnuplot liveplot.gnu
