dataPosition = '../../Data/';
filename = 'data008';


% data import and creation of variance array
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

tt = rawData(:, 1);
vi = rawData(:, 2);
vo = rawData(:, 3);


plot(tt, vo, 'o', Color = '#0027BD');
hold on
%plot(tt, vo, 'v', Color = 'magenta');
plot(tt, mean(vo) * sin(50*tt), 'Color', 'red');

grid on
grid minor
title('Amplified photodiode voltage');
%legend('', Location= 'ne')
ylabel('Voltage [V]')
xlabel('Time [s]')

hold off



if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
