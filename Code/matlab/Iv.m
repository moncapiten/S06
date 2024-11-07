dataPosition = '../../Data/';
filename = [ 'data001' 'data002' ];
%filename2 = 'dataBode003';
color = [ 'red', '#ffa500'];
mediaposition = '../../Media/';
medianame = 'AmplitudeOffsetIn';

flagSave = false;

% data import and creation of variance array
rawData = readmatrix(strcat(dataPosition, filename(1:7), '.txt'));
%rawData2 = readmatrix(strcat(dataPosition, filename2, '.txt'));

vv = rawData(:, 1);
ch1 = rawData(:, 2);
%s_i = repelem(2.1e-3, length(ff));
%oi = rawData(:, 10);
ch2 = rawData(:, 3);
%s_o = repelem(1.5e-2, length(ff));

%ff = rawData(:, 1);
%vi2 = rawData2(:, 4);
%oi2 = rawData2(:, 10);
%vo2 = rawData2(:, 6);

R = 469.98;

i = 1000* ch1/R;

semilogy(ch2, i, Color= color(1));
hold on
grid on
grid minor

for i = 2:length(filename)
    swapRawData = readmatrix(strcat(dataPosition, filename((1+7*i):(2*i*7)), '.txt'));
    swapch1 = swapRawData(:, 2);
    swapch2 = swapRawData(:, 3);
    swapi = swapch1/R;
    semilogy(swapch2, swapi, Color= color(i));
end



hold off

title('Iv plot for LEDs');
legend('Iv - red LED', Location= 'nw');
ylabel('I [mA]');
xlabel('V [V]');


if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
