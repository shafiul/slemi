function delete_cluster_jobs( is_delete )
%DELETE_CLUSTER_JOBS Summary of this function goes here
%   Detailed explanation goes here

if ~ is_delete
    return;
end

myCluster = parcluster('local');
delete(myCluster.Jobs);

end

