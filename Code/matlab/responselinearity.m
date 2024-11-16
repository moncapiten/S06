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
gaml = 1e-5 * [1.6444    2.0878    1.7625   4.1198    3.5799    3.3395];
l_ = 1./ufl;

Afl = Afl ./ gaml



function y = lin(params, x)
    y = params(1) * x ;%+ params(2);
end

m_original = [];
m_rescaled = [];

t = tiledlayout(2, 2, "TileSpacing","tight", "Padding","tight");

% first plot, original data no scaling and just linear fit
ax1 = nexttile();
for i = 1:length(filenames) 

    rawData = readmatrix(strcat(dataPosition, filenames(i), '.txt'));
    tt = rawData(:, 1);
    ch1 = rawData(:, 2);
    ch2 = rawData(:, 3);


    ii = [];
    io = [];
    for j = 1:length(ch1)
        if ch1(j) > thr
            ii = [ii, ch1(j) ];
            io = [io, ch2(j) ];
        end
    end
    ii = ii ./ Ri;
    io = io ./ Ro;

p0 = [1];
%    p0 = [1, 0];
    [beta, r, ~, covbeta] = nlinfit(ii, io, @lin, p0);


    m_original = [m_original, beta(1)];

    plot(ii, io, 'o', Color = color(i));
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


    ii = [];
    io = [];
    for j = 1:length(ch1)
        if ch1(j) > thr
            ii = [ii, ch1(j) ];
            io = [io, ch2(j) ];
        end
    end
    ii = ii ./ Ri;
    io = io ./ Ro;

    i_rescaled = io ./ Afl(i);



p0 = [1];
%    p0 = [1, 0];
    [beta_rescaled, r_rescaled, ~, covbeta_rescaled] = nlinfit(ii, i_rescaled, @lin, p0);
    m_rescaled = [m_rescaled, beta_rescaled(1)];


    plot(ii, i_rescaled, 'x', Color = color(i));
    if i == 1
        hold on
    end
    plot(ii, lin(beta_rescaled, ii), '-', Color = color(i));
    
end
grid on;
grid minor;
hold off;










m_rescaled = m_original ./ Afl;









% third plot, response curve of original data
ax3 = nexttile();
for i = 1:length(m_original)
    plot(ufl, m_original, '--', Color = "magenta");
    if i == 1
        hold on
    end
    plot(ufl(i), m_original(i), 'o', Color = color(i));
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
    plot(ufl(i), m_rescaled(i), 'x', Color = color(i));
end
grid on;
grid minor;
hold off;




%title('Amlitude and Offset of input signal');
%legend('Amplitude in - 4.5k divider', 'Offset in - 4.5k divider', 'Amplitude in - 45k divider', 'Offset in - 45k divider', Location= 'ne')
ylabel(ax1, 'Photodiode Current [A]')
xlabel(ax1, 'LED Current [A]')
xlabel(ax2, 'LED Current [A]')

ylabel(ax3, 'Photodiode sensibility ')
xlabel(ax3, '${ \lambda  [\mathrm{nm}] }$', 'interpreter', 'latex');
xlabel(ax4, '${ \lambda  [\mathrm{nm}] }$', 'interpreter', 'latex');




if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
