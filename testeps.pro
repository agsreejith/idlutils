pro testeps

x = findgen(50)

set_plot, 'ps'
device, /encapsulated, filename='~/Documents/SFSU/research/Thesis/figures/testeps.ps'
plot, x
device, /close
set_plot, 'x'


end; testeps.pro