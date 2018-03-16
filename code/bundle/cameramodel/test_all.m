function test_all

tests={'xlat2', 'xlat3', 'scale2', 'scale3', 'lin3', 'lin2', 'pinhole', ...
       'eulerrotmat', ...
       'affine2mat', 'affine2', 'aniscale', 'skew', ...
       'lens_rad2', 'power_vec', 'rad_scale', 'tang_scale', 'brown_rad', ...
       'brown_tang', 'brown_dist', ...
       'world2cam', 'eulerpinhole', ...
       'res_euler_brown_0', ...
       'res_euler_brown_1', ...
       'res_euler_brown_2', ...
       'res_euler_brown_3' };

unused={'brown_dist_rel','affscale2', 'brown_affine'};

%for i=length(tests):-1:1
for i=1:length(tests)
    fprintf('Testing %s...',tests{i});
    fail=feval(tests{i},'selftest');
    if fail
        fprintf('FAIL.\n');
    else
        fprintf('OK.\n');
    end
end
