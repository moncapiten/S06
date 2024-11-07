dataPosition = '../../Data/';
filename = 'data008';


% data import and creation of variance array
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

tt = rawData(:, 1);
vi = rawData(:, 2);
vo = rawData(:, 3);


plot(tt, vi, 'o', Color = '#0027BD');
hold on
plot(tt, vo, 'v', Color = 'magenta');

grid on
grid minor
title('Amlitude and Ottset of input signal');
legend('Amplitude in - 4.5k divider', 'Ottset in - 4.5k divider', 'Amplitude in - 45k divider', 'Ottset in - 45k divider', Location= 'ne')
ylabel('Vi Amplitude [V]')
xlabel('frequency [Hz]')

hold ott



if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
