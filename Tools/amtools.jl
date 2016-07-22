#=
Owen Lehmer - 7/21/16

This module provides simple principal component analysis tools to both reduce
data size and provide visualizations of data.

=#


module AMTools

function feature_normalize!(data)
    """
    Normalize the features in data. This will mean normalize and scale by the 
    standard deviation. It is assumed that the rows of data represent the 
    training data and the columns are features.

    data is mxn
    """

    mu = mean(data,1) #take mean of the columns, mu is 1xn
    sigma = std(data,1) #standard deviation of each column, std is 1xn

    for i=1:size(data)[1]
        for j=1:size(data)[2]
            data[i,j] = (data[i,j]-mu[j])/sigma[j]
        end
    end
end
function feature_normalize(data)
    """
    See feature_normalize!(data). This version does not modifiy input.
    """
    data = copy(data)
    mu = mean(data,1)
    sigma = std(data,1)
    data = data .- mu
    data = data ./ sigma
    return data
end

function pca(data;k=-1,var_ret=0.99)
    """
    Principal component analysis of data. By default returns the reduced 
    components such that 99% of the variance is retained. The input, data, 
    should have the data in rows, where each column is a feature. Size of data
    is mxn

    Input
    data - the data to process
    k - the dimension of the result (set to 2 or three if plotting)
    var_ret - the variance retained. Defaults to 99%

    Note: If k=-1 (default) k will be set such that var_ret% of the variance is
    retained.

    Returns:
    output - the processed data
    U - the reduction matrix
    var_ret - the varaince retained 
    """

    data_norm = feature_normalize(data)
    m = size(data_norm)[1] #number of rows

    sigma = 1/m*data_norm'*data_norm

    U,S,V = svd(sigma)

    if k < 0
        for i=1:length(S)
            if sum(S[1:i])/sum(S) >= var_ret
                k = i
                break
            end
        end
    end

    var_ret = sum(S[1:k])/sum(S)
    U = U[:,1:k]
    output = data_norm*U

    return output,U,var_ret 
end

function pca_reconstruct(U, z)
    """
    Takes the reprojection values, z, and the corresponding matrix, U, to 
    give the approximate values of the original data.

    Output:
    estimate - the estimate of the original data
    """

    estimate = z*U'
    return estimate
end


export feature_normalize, feature_normalize!, pca, pca_reconstruct

end #end module







