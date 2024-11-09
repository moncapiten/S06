clear all;

% data import/export setup
dataPosition = '../../Text/Spettri_LED/';
filename = ["LED_11_ros_spectrum", "LED_15_ara_spectrum", "LED_13_gia_spectrum", "LED_14_ver_spectrum", "LED_12_blu_spectrum", "LED_25_vio_spectrum"];
color = [ "red", "#ffa500", "#777777", "green", "#0027bd", "#a020f0"];
names = [ "red", "orange", "yellow", "green", "blue", "purple"];
mediaposition = '../../Media/';
medianame = 'Spectra';

flagSave = true;


ff = [];
I = [];

function y = gauss(params, x)
    sigmasq = params(2)*params(2);
    prefac = params(3)/ sqrt(2 * pi * sigmasq);
    exponent = - ( x-params(1) ).^2 / (2*sigmasq);

    y = prefac * exp( exponent );
end


function y = lorentz(params, x)
    denom = (x-params(1)).^2 + params(2)^2;
    y = params(3) * params(2) ./ ( pi * denom);
end


u0 = [630, 610, 590, 520, 460, 400];
s0 = [10, 10, 10, 10, 10, 10];
A0 = [4400, 1000, 800, 3800, 4500, 6500];
Ag = A0 .* sqrt(2*pi*s0.*s0);
% at x = x0 ⇒ A = A0/(gam*pi) ⇒ gam = A0/(A*pi)
%gam0 = 1./(A0*pi);
gam0 = repelem(9, length(A0));


ufg = [];
sfg = [];
Afg = [];
ufl = [];
gaml = [];
Afl = [];


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


    p0i = [u0(i), s0(i), Ag(i)];
    p0l = [u0(i), gam0(i), Ag(i)];

    [betag, Rg, ~, covbetag] = nlinfit(ff, I, @gauss, p0i);
    [betal, Rl, ~, covbetal] = nlinfit(ff, I, @lorentz, p0l);
    ufg = [ufg, betag(1)];
    sfg = [sfg, betag(2)];
    Afg = [Afg, betag(3)];

    ufl = [ufl, betal(1)];
    gaml = [gaml, betal(2)];
    Afl = [Afl, betal(3)];

    plot(ff, I, 'o', Color= color(i));
    if i==1
        hold on
    end

%    plot(ff, gauss(p0i, ff), '--', Color= "magenta");
%    plot(ff, lorentz(p0l, ff), '--', Color= 'cyan');
    plot(ff, gauss(betag,ff), '-.', Color= color(length(color)+1-i))
    plot(ff, lorentz(betal, ff), '--', Color= color(length(color)+1-i));
end

legendlist = [];
for i = 1:length(names)
    legendlist = [legendlist,  strcat(names(i), " - data"), strcat(names(i), " - fit Gaussian"), strcat(names(i), " - fit Lorentz") ];
end
%legend("red - data", "red - fit", "orange - data", "orange - fit", "yellow - data", "yellow - fit", "green - data", "green - fit", "blue - data", "blue - fit", "purple - data", "purple - fit", location= "ne");
legend(legendlist, location= "ne");

title("LEDs Spectra");
xlabel("frequency [Hz]");
ylabel("Intensity [a.u.]");
fontsize(14, "points");

grid on
grid minor
xlim([350 850]);
ylim([-10 6700]);


hold off

ufg
sfg
Afg

ufl
gaml
Afl











if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
