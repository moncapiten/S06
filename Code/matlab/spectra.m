clear all;


dataPosition = '../../Text/Spettri_LED/';
filename = 'LED_11_ros_spectrum';
%filename2 = 'dataBode003';
color = 'red';
mediaposition = '../../Media/';
medianame = 'Spectra';

flagSave = false;

% data import and creation of variance array
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));
%rawData2 = readmatrix(strcat(dataPosition, filename2, '.txt'));

ff = rawData(:, 1);
I = rawData(:, 2);


function y = gauss(params, x)
    sigmasq = params(2)*params(2);
    prefac = params(3)/ sqrt(2 * pi * sigmasq);
    exponent = - ( x-params(1) ).^2 / (2*sigmasq);

    y = prefac * exp( exponent );
end

function y = poisson(params, x)
    y = params(2) * params(1).^x * exp( -params(1) ) / gamma(x);
end
%pd = fitdist(I, "Normal")

p0 = [630, 35, 375000];
p0p = [25, 375000];

I = I - 1500;


[beta, R, ~, covbeta] = nlinfit(ff, I, @gauss, p0);


a = poisson(p0p, ff);


plot(ff, I, '.', Color= '#0027bd' );
hold on


plot(ff, gauss(p0, ff), '--', Color= 'magenta');
plot(ff, a, '--', Color= 'black');

plot(ff, gauss(beta, ff), '-', Color= 'red');


grid on
grid minor

hold off

title('Red Led Spectrum');
legend('Intensity per frequenxy', Location= 'nw');
ylabel('Int [u.a.]');
xlabel('frequency [Hz]');


if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
