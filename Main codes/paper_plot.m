close all;
% Amplitude

figure('Position', [10 10 900 600]);
y = [-15.688575	-11.899696	10.773699	17.047962;
-17.089745	-9.5748596	10.68366	18.393894;
-17.127531	-10.26338	10.716357	18.875361;
-17.206969	-10.014045	10.356731	18.970516;
-24.214279	-13.663709	9.1340157	19.556529;
-15.700668  -10.057398  9.6836456   17.322605]';
y_error = [2.187155	1.21333	1.695242	1.22989;
1.17229	1.041077	1.327551	1.651015;
1.442365	1.253689	1.049203	1.076073;
1.230206	1.321196	1.044352	1.202498;
0.9869192	0.8088394	0.7006645	0.7091214;
1.873424    0.522741    1.024612    2.056078]';

bar(y,'grouped')
hold on
%errorbar(y,y_error)

% Find the number of groups and the number of bars in each group
ngroups = size(y, 1);
nbars = size(y_error, 2);

% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));

% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(:,i), y_error(:,i), 'k', 'linestyle', 'none');
end

set(gca,'xticklabel',{'A','B','C','D'});
set(gca, 'FontName', 'Times New Roman', 'FontSize', 16);

yline(-22,'-.k', 'A : -22 deg.');
yline(-11,'-.k', 'B : -11 deg.');
yline(22,'-.k', 'D : 22 deg.');
yline(11,'-.k', 'C : 11 deg.');

title('Saccade Amplitude');
xlabel('Target Location'); 
ylabel('Saccade Amplitude - degrees'); 

hold off 
legend({'BP','BR','CVM','CAM','EL','LR'}, "Location", "northwest");

% Accuracy
figure('Position', [10 10 900 600]);
y = [9.1972043	5.8751338	5.156426	6.973949;
7.2125343	3.5649308	4.3529315	6.8305602;
7.3086941	3.9160937	3.2948365	4.8824469;
6.6831391	4.1548783	3.2931755	5.6006825;
3.544384	3.4323407	2.5022335	2.5886208;
7.4428624   2.2674792   3.2606913   6.5618474]';
y_error = [1.116086	0.8366407	1.239318	0.9571786;
0.7599914	0.6545057	1.01744	1.371918;
0.9836953	0.9400772	0.7099798	0.7285242;
0.7828177	0.9571601	0.6508075	0.9932491;
0.8121445	0.4203145	0.4671728	0.7018016
1.427631    0.3793483   0.6097197   1.343825]';

bar(y,'grouped')
hold on
%errorbar(y,y_error)

% Find the number of groups and the number of bars in each group
ngroups = size(y, 1);
nbars = size(y_error, 2);

% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));

% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(:,i), y_error(:,i), 'k', 'linestyle', 'none');
end

set(gca,'xticklabel',{'A','B','C','D'});
set(gca, 'FontName', 'Times New Roman', 'FontSize', 16);

title('Saccade Error');
xlabel('Target Location'); 
ylabel('Saccade Error - degrees'); 

hold off 
legend({'BP','BR','CVM','CAM','EL','LR'}, "Location", "northeast");

% Peak Vel
figure('Position', [10 10 900 600]);
y = [297.53576	238.3882	247.82396	345.61614;
255.73862	236.7825	256.40277	294.60873;
187.78503	153.07393	161.22792	212.54146;
111.50257	104.36718	117.68895	112.78996;
%1104.4488	887.01375	1037.8946	1454.2062;
36.328657   28.424839   24.974905   40.3398]';
y_error = [14.64912	21.26613	25.23641	21.67129;
18.32647	24.6261	42.62854	23.66537;
10.16955	13.7747	17.67743	8.651051;
20.815	19.25053	22.98981	18.21578;
%379.3686	232.5608	437.3298	406.6172
3.286789    2.792816    3.260625    3.132961]';

bar(y,'grouped')
hold on
%errorbar(y,y_error)

% Find the number of groups and the number of bars in each group
ngroups = size(y, 1);
nbars = size(y_error, 2);

% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));

% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(:,i), y_error(:,i), 'k', 'linestyle', 'none');
end

set(gca,'xticklabel',{'A','B','C','D'});
set(gca, 'FontName', 'Times New Roman', 'FontSize', 16);

title('Saccade Peak Velocity');
xlabel('Target Location'); 
ylabel('Peak Velocity - m/s'); 

hold off 
legend({'BP','BR','CVM','CAM','LR'}, "Location", "northwest");

% Latency
figure('Position', [10 10 900 600]);
y = [0.65806007	0.79241925	0.83016074	0.74778653;
0.80622385	0.80776441	0.89022043	0.81600459;
0.73551427	0.73840328	0.78964352	0.77372521;
0.71691584	0.83029708	0.74795997	0.72130964;
0.60675623	0.76527689	0.92462657	0.66243143
0.96150623  0.99830105  0.97612096  0.98879232]';
y_error = [0.0766101	0.1404733	0.1113711	0.08045419;
0.08221232	0.0940008	0.1094191	0.06784854;
0.05138629	0.07849202	0.07177342	0.05962039;
0.07427168	0.1247215	0.06897229	0.05737802;
0.03467376	0.1806179	0.3982384	0.0373226
0.06158214  0.07509673  0.06206889  0.05561781]';

bar(y,'grouped')
hold on
%errorbar(y,y_error)

% Find the number of groups and the number of bars in each group
ngroups = size(y, 1);
nbars = size(y_error, 2);

% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));

% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(:,i), y_error(:,i), 'k', 'linestyle', 'none');
end

set(gca,'xticklabel',{'A','B','C','D'});
set(gca, 'FontName', 'Times New Roman', 'FontSize', 16);

title('Saccade Latency');
xlabel('Target Location'); 
ylabel('Latency - s'); 

hold off 
legend({'BP','BR','CVM','CAM','EL','LR'}, "Location", "northeast");