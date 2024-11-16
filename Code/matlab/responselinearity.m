clear all;
dataPosition = '../../Data/';


filenames = [];
for i = 1:6
    filenames = [filenames, strcat("data0", num2str(i + 18))];
end
color = [ "red", "#ffa500", "#777777", "green", "#0027bd", "#a020f0"];

mediaposition = '../../Media/';
medianame = 'AmplitudeOffsetIn';

flagSave = false;

% data import and creation of variance array
thr = 0.04;

Ri = 469.98;
Ro = 100.23 * 1e3;

Afl = 1.0e+05 * [0.8563, 0.2429, 0.1484, 1.3423, 1.0094, 1.1120];
ufl = [629.9471  611.6782  593.7855  526.7789  460.6394  399.2741];%nm
gaml = [6.5112    7.8116    6.2143   11.4325    7.5963    5.3239 ];


Afl = Afl ./ gaml;



function y = lin(params, x)
    y = params(1) * x ;%+ params(2);
end

m_original = [];
s_m_original = [];
m_rescaled = [];
s_m_rescaled = [];
k_original = [];
k_rescaled = [];

t = tiledlayout(2, 2, "TileSpacing","tight", "Padding","tight");

% first plot, original data no scaling and just linear fit
ax1 = nexttile();
for i = 1:length(filenames) 

    rawData = readmatrix(strcat(dataPosition, filenames(i), '.txt'));
    tt = rawData(:, 1);
    ch1 = rawData(:, 2);
    ch2 = rawData(:, 3);
    

    vi = [];
    vo = [];
    for j = 1:length(ch1)
        if ch1(j) > thr
            vi = [vi, ch1(j) ];
            vo = [vo, ch2(j) ];
        end
    end
    ii = vi ./ Ri;
    io = vo ./ Ro;

    s_vi = repelem(0.015, length(vi));
    s_vo = repelem(0.015, length(vo));

    rel_s_vi = s_vi ./ vi;
    rel_s_vo = s_vo ./ vo;

    s_ii = rel_s_vi .* ii;
    s_io = rel_s_vo .* io;

    ii = ii * 1e3;
    s_ii = s_ii * 1e3;
    io = io * 1e6;
    s_io = s_io * 1e6;


    p0 = [1];
%    p0 = [1, 0];
    [beta, r, ~, covbeta] = nlinfit(ii, io, @lin, p0);
    
    s_eff = sqrt( s_io.^2 + (beta(1) * s_ii).^2);
    k = 0;
    for j = 1:length(r)
        k = k + r(j)^2/s_eff(j)^2;
    end
    k = k/(length(ii)-1);


    m_original = [m_original, beta(1)];
    s_m_original = [s_m_original, sqrt(covbeta(1, 1))];
    k_original = [k, k_original];

    errorbar(ii, io, 0.5*s_io, 0.5*s_io, 0.5*s_ii, 0.5*s_ii,'o', Color = color(i));
    if i == 1
        hold on
    end

    %plot(ii, lin(p0, ii), '--', 'Color', 'magenta');
    plot(ii, lin(beta, ii), '-', Color = color(i));
end
grid on;
grid minor;
hold off;






% second plot, rescaled data and linear fit
ax2 = nexttile();
for i = 1:length(filenames)


    rawData = readmatrix(strcat(dataPosition, filenames(i), '.txt'));
    tt = rawData(:, 1);
    ch1 = rawData(:, 2);
    ch2 = rawData(:, 3);




    vi = [];
    vo = [];
    for j = 1:length(ch1)
        if ch1(j) > thr
            vi = [vi, ch1(j) ];
            vo = [vo, ch2(j) ];
        end
    end
    ii = vi ./ Ri;
    io = vo ./ Ro;

    s_vi = repelem(0.025, length(vi));
    s_vo = repelem(0.025, length(vo));

    rel_s_vi = s_vi ./ vi;
    rel_s_vo = s_vo ./ vo;

    s_ii = rel_s_vi .* ii;
    s_io = rel_s_vo .* io;

    io = io * 1e6;
    s_io = s_io * 1e6;

    i_rescaled = io ./ Afl(i);
    swap_s_ir = s_io ./ io;
    s_ir = swap_s_ir .* i_rescaled;

    ii = ii * 1e3;
    s_ii = s_ii * 1e3;




p0 = [1];
%    p0 = [1, 0];
    [beta_rescaled, r_rescaled, ~, covbeta_rescaled] = nlinfit(ii, i_rescaled, @lin, p0);

    s_eff = sqrt( s_io.^2 + (beta(1) * s_ii).^2);
    k = 0;
    for j = 1:length(r)
        k = k + r(j)^2/s_eff(j)^2;
    end
    k = k/(length(ii)-1);

    m_rescaled = [m_rescaled, beta_rescaled(1)];
    s_m_rescaled = [s_m_rescaled, sqrt(covbeta_rescaled(1, 1))];
    k_rescaled = [k, k_rescaled];


    errorbar(ii, i_rescaled, 0.5*s_ir, 0.5*s_ir, 0.5*s_ii, 0.5*s_ii, 'x', Color = color(i));
    if i == 1
        hold on
    end
    plot(ii, lin(beta_rescaled, ii), '-', Color = color(i));
    
end
grid on;
grid minor;
hold off;










%m_rescaled = m_original ./ Afl;









% third plot, response curve of original data
ax3 = nexttile();
for i = 1:length(m_original)
    plot(ufl, m_original, '--', Color = "magenta");
    if i == 1
        hold on
    end
    errorbar(ufl(i), m_original(i), 0.5*s_m_original(i), 0.5*s_m_original(i), 0.5*gaml(i), 0.5*gaml(i), 'o', Color = color(i));
end
grid on;
grid minor;
hold off;

% fourth plot, response curve of rescaled data
ax4 = nexttile();
for i = 1:length(m_original)
    plot(ufl, m_rescaled, '--', Color = "magenta");
    if i == 1
        hold on
    end
    errorbar(ufl(i), m_rescaled(i), 0.5*s_m_rescaled(i), 0.5*s_m_rescaled(i), 0.5*gaml(i), 0.5*gaml(i), 'x', Color = color(i));
end
grid on;
grid minor;
hold off;




title(t, 'Photodiode Spectral Response Curve');
%legend('Amplitude in - 4.5k divider', 'Offset in - 4.5k divider', 'Amplitude in - 45k divider', 'Offset in - 45k divider', Location= 'ne')
title(ax1, 'Raw data - linear fit and connecting line');
title(ax2, 'Data rescaled by LED emission spectrum - linear fit and connecting line');

ylabel(ax1, 'Photodiode Current [ ${ \mathrm{\mu A} }$ ]', 'interpreter', 'latex');
xlabel(ax1, 'LED Current [mA]', 'interpreter', 'latex');
ylabel(ax2, 'Rescaled Photodiode Current [ ${ \mathrm{ u.a. } }$ ]', 'interpreter', 'latex');
xlabel(ax2, 'LED Current [mA]', 'interpreter', 'latex');

ylabel(ax3, 'Photodiode Sensitivity [ ${ \mathrm{ \mu A / mA } }$ ]', 'interpreter', 'latex');
xlabel(ax3, '${ \lambda  [\mathrm{nm}] }$', 'interpreter', 'latex');
ylabel(ax4, 'Rescaled Photodiode Sensitivity [ ${ \mathrm{ u.a. } }$ ]', 'interpreter', 'latex');
xlabel(ax4, '${ \lambda  [\mathrm{nm}] }$', 'interpreter', 'latex');


fontsize(14, "points");


if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
