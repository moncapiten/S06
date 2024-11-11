dataPosition = '../../Data/';
filename = 'data013';

mediaposition = '../../Media/';
medianame = 'AmplitudeOffsetIn';

flagSave = false;

% data import and creation of variance array
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

tt = rawData(:, 1);
ch1 = rawData(:, 2);
ch2 = rawData(:, 3);

Ri = 469.98;
Ro = 100.23 * 1e3;

ii = ch1/Ri;
io = ch2/Ro;


semilogy(tt, ii, 'o', Color = '#0027BD');
hold on
semilogy(tt, io, 'o', Color = 'red');

grid on
grid minor
%title('Amlitude and Offset of input signal');
%legend('Amplitude in - 4.5k divider', 'Offset in - 4.5k divider', 'Amplitude in - 45k divider', 'Offset in - 45k divider', Location= 'ne')
ylabel('Vi Amplitude [V]')
xlabel('frequency [Hz]')

hold off



if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
