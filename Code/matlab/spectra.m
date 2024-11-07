clear all;

% data import/export setup
dataPosition = '../../Text/Spettri_LED/';
filename = ["LED_11_ros_spectrum", "LED_15_ara_spectrum", "LED_13_gia_spectrum", "LED_14_ver_spectrum", "LED_12_blu_spectrum", "LED_25_vio_spectrum"];
color = [ "red", "#ffa500", "#777777", "green", "#0027bd", "#a020f0"];
names = [ "red", "orange", "yellow", "green", "blue", "purple"];
mediaposition = '../../Media/';
medianame = 'Spectra';

flagSave = false;


ff = [];
I = [];

function y = gauss(params, x)
    sigmasq = params(2)*params(2);
    prefac = params(3)/ sqrt(2 * pi * sigmasq);
    exponent = - ( x-params(1) ).^2 / (2*sigmasq);

    y = prefac * exp( exponent );
end


u0 = [630, 610, 590, 520, 460, 400];
s0 = [10, 10, 10, 10, 10, 10];
A0 = [4400, 1000, 800, 3800, 4500, 6500];
A0 = A0 .* sqrt(2*pi*s0.*s0);

uf = [];
sf = [];
Af = [];



for i = 1:length(filename)
    swapmatrix = readmatrix(strcat(dataPosition, filename(i), '.txt'));
    ff = swapmatrix(:, 1);
    I = swapmatrix(:, 2);

    I = I-1503.6;

    %{
    if( i == length(filename))
        ff = ff(230:880);
        I = I(230:880);
        mean(I)
    end
    %}


    p0i = [u0(i), s0(i), A0(i)];

    [beta, R, ~, covbeta] = nlinfit(ff, I, @gauss, p0i);
    uf = [uf, beta(1)];
    sf = [sf, beta(2)];
    Af = [Af, beta(3)];


    plot(ff, I, 'o', Color= color(i));
    if i==1
        hold on
    end

%    plot(ff, gauss(p0i, ff), '--', Color= "magenta");
    plot(ff, gauss(beta,ff), '-', Color= color(length(color)+1-i))
end


legend("red - data", "red - fit", "orange - data", "orange - fit", "yellow - data", "yellow - fit", "green - data", "green - fit", "blue - data", "blue - fit", "purple - data", "purple - fit", location= "ne");


title("LEDs Spectra");
xlabel("frequency [Hz]");
ylabel("Intensity [a.u.]");
fontsize(14, "points");

grid on
grid minor
xlim([350 850]);
ylim([-10 6700]);


hold off

uf
sf












if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
