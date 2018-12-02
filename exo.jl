using Plots,NaNMath,Statistics,DelimitedFiles, FastTransforms, FFTW
pyplot()

data = readdlm("exoplanet-data.txt")

cleaner = data[:,2] .!=NaN
clean_data = copy(data[cleaner,:])
data = copy(clean_data)
I0 = findmax(data[:,2])
I0 = copy(I0[1])
plot(data[:,1],data[:,2],legend=false)
title!("Exoplanet Data")
ylabel!("Intensity")
xlabel!("Days")

savefig("dataplot.png")

data[collect(235:469),:]

shifted = length(data[:,1])/2
shifted_data = vcat(data[collect(235:469),:],data[collect(2:234),:])

function fuck(avg_measure,data)
    for i=2:length(data)
        avg_measure += (data[i-1]-data[i])/length(data[:])
    end
    return avg_measure
end

avg_measure = 0
avg_measure = fuck(avg_measure,data[:,2])

firstbit = data[collect(1:100),2]

maxi = findmax(firstbit)

FT = fft(firstbit/maxi[1])
power = real(fftshift(FT.*conj(FT)))




steps = [i*(1/avg_measure) for i in -(length(firstbit)/2)+1:(length(firstbit)/2)]





plot(steps,power,legend=false,ylim=(0,0.001))
title!("Fourier Analysis")
ylabel!("ĤH")
xlabel!("Frequency")
savefig("sym.png")


dip = zeros(4)

dip[1]= argmin(data[:,2])
next = argmin(data[:,2])-1

dip[2] = argmin(data[1:next,2])
next2 = Int.(dip[2]-2)

dip[3] = argmin(data[1:next2,2])
next3 = Int.(dip[3]-2)

dip[4] = argmin(data[1:next3,2])
next4 = Int.(dip[4]-3)

dip = Int.(dip[1:4])

plot(collect(-6:1:5),data[dip[1]-6:dip[1]+5,2],label=data[dip[1],1])
plot!(collect(-6:1:5),data[dip[2]-6:dip[2]+5,2],label=data[dip[2],1])
plot!(collect(-6:1:5),data[dip[3]-6:dip[3]+5,2],label=data[dip[3],1])
plot!(collect(-6:1:5),data[dip[4]-6:dip[4]+5,2],label=data[dip[4],1])
xaxis!(collect(-6:1:5))
title!("Intensity Dips")
xlabel!("Number of mesurements away from local minima")
ylabel!("Intensity")
savefig("dips.png")

T1 = (data[Int.(dip[1]),1]-data[Int.(dip[2]),1])
T2 = (data[Int.(dip[2]),1]-data[Int.(dip[3]),1])
T3 = (data[Int.(dip[3]),1]-data[Int.(dip[4]),1])

T = (T1 + T2 + T3)/3

I = (data[Int.(dip[1]),2] + data[Int.(dip[2]),2] + data[Int.(dip[3]),2] + data[Int.(dip[4]),2])/4

maxi = findmax(data)

transit1=collect(data[dip[1],1]-5:data[dip[1],1]+4)
transit2=collect(data[dip[2],1]-5:data[dip[2],1]+4)
transit3=collect(data[dip[3],1]-5:data[dip[3],1]+4)
transit4=collect(data[dip[4],1]-5:data[dip[4],1]+4)

remover = vcat(transit1,transit2,transit3,transit4)

I0=mean(data[Int.(remover),2])
IE=mean(data[Int.([dip[1],dip[2],dip[3],dip[4]]),2])
R_ratio=sqrt(1-IE/I0)


trans_mag1 = (data[dip[1]+4,1]) - (data[dip[1]-5,1])
trans_mag2 = (data[dip[2]+4,1]) - (data[dip[2]-5,1])
trans_mag3 = (data[dip[3]+4,1]) - (data[dip[3]-5,1])
trans_mag4 = (data[dip[4]+4,1]) - (data[dip[4]-5,1])


Transit = (trans_mag2+trans_mag4+trans_mag1+trans_mag3)/4
