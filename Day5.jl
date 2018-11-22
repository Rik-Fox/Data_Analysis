using DelimitedFiles

exo = readdlm("exoplanet-data.txt")

plot(exo[:,1],exo[:,2])
