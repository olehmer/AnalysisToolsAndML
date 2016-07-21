data = readdlm("../../DensityAnalysis/exoplanet_data.txt");

data_ed = data[:,2:end-2];

d2 = []

for i=1:size(data_ed)[1]
    found_neg = false
    for j=1:size(data_ed)[2]
        if data_ed[i,j] < 0
            found_neg = true
        end
    end
    if !found_neg
        push!(d2,data_ed[i,:])
    end
end

d3 = zeros(length(d2),size(data_ed)[2])

for i=1:size(d3)[1]
    for j=1:size(d3)[2]
        d3[i,j] = d2[i][j]
    end
end


