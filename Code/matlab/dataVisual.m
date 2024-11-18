dataPosition = '../../Data/';
filename = 'data008';


% data import and creation of variance array
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

tt = rawData(:, 1);
vi = rawData(:, 2);
vo = rawData(:, 3);
s_vo = repelem(0.0015, length(vo));

function y=sine(p, x)
    y = p(1) * sin(p(2) * x + p(3)) + p(4);
end


errorbar(tt, vo, s_vo, 'o', Color = '#0027BD');
hold on
p0 = [(max(vo)-min(vo))/2, 2*pi*100, 1.25*pi, mean(vo)];
[beta, R, ~, covbeta] = nlinfit(tt, vo, @sine, p0);

%plot(tt, sine(p0, tt), '--', Color= 'magenta');
plot(tt, sine(beta, tt), '-', Color= 'red');

f_fit = beta(2)/(2*pi)
s_f_fit = sqrt(covbeta(2, 2)) / beta(2) * f_fit


k = 0;
for j = 1:length(R)
    k = k + R(j)^2/s_vo(j)^2;
end
k = k/(length(tt)-3);
k


grid on
grid minor
title('Amplified photodiode output voltage');
legend('Photodiode voltage', 'Sin fit', Location= 'ne')
ylabel('Voltage [V]')
xlabel('Time [s]')

hold off

fontsize(14, "points");



if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
